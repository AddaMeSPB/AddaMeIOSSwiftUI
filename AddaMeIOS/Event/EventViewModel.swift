//
//  EventViewModel.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 28.08.2020.
//

import Foundation
import Combine
import Pyramid

//class APIClient {
//    private let provider = Pyramid()
//    
//    private var refreshToken: String?
//    private var accessToken: String?
//    
//    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
//    private func refreshToken() -> AnyPublisher<Bool, Never> {
//        // normally you'd have your refresh logic here
//        print("refreshToken logic here")
//        
//        return Just(true).eraseToAnyPublisher()
//    }
//    
//    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
//    public func request<D: Decodable>(
//        with api: APIConfiguration,
//        class type: D.Type) -> AnyPublisher<D, ErrorManager> {
//        
//        provider.request(with: api, scheduler: DispatchQueue.main, class: type)
//            .tryCatch({ error  in
//                guard let apiError = error as? ErrorManager, apiError.errorDescription.contains("401") else {
//                    throw error
//                }
//
//                return self.refreshToken()
//                    .tryMap({ success -> AnyPublisher<D, Error> in
//                        print(success)
//                        guard success != nil else { throw error }
//                        return self.request(with: api, scheduler: scheduler, class: type)
//                    })
//                    .switchToLatest().eraseToAnyPublisher()
//            })
//    }
//}

//extension APIClient {
//    static let eventAPIConfig: APIConfiguration, RequiresAuth {
//
//    }
//}

//struct EventAPIConfig: APIConfiguration, RequiresAuth {
//    //
//}
//
//struct MarketplaceAPIConfig: APIConfiguration, RequiresAuth {
//    //
//}

import Combine
import SwiftUI
import MapKit

final class DemoData: ObservableObject {
    @Published var events = eventData
}

class EventViewModel: ObservableObject {

    private static let eventProcessingQueue =  DispatchQueue(label: "event-processing")
    
    @Published var events = [EventResponse.Item]()
    @Published var myEvents = [EventResponse.Item]()
    
    @Published var isLoadingPage = false
    private var currentPage = 1
    private var canLoadMorePages = true
    
    let provider = Pyramid()
    var cancellable: AnyCancellable?
    
    init() {}
    
    private func onStart() {
        isLoadingPage = true
    }
    
    private func onFinished() {
        isLoadingPage = false
    }

}

extension EventViewModel {

    func fetchMoreEventIfNeeded(currentItem item: EventResponse.Item?) {
        guard let item = item else {
            fetchMoreEvents()
            return
        }

        let threshouldIndex = events.index(events.endIndex, offsetBy: -7)
        if events.firstIndex(where: { $0.id == item.id }) == threshouldIndex {
            fetchMoreEvents()
        }
    }
    
    func fetchMoreMyEventIfNeeded(currentItem item: EventResponse.Item?) {
        guard let item = item else {
            fetchMoreMyEvents()
            return
        }

        let threshouldIndex = myEvents.index(myEvents.endIndex, offsetBy: -7)
        if myEvents.firstIndex(where: { $0.id == item.id }) == threshouldIndex {
            fetchMoreMyEvents()
        }
    }
    
    func fetchMoreEvents() {
        
        guard !isLoadingPage && canLoadMorePages else {
            return
        }
        
        isLoadingPage = true
        
        print(#line, currentPage, canLoadMorePages)
        
        let query = QueryItem(page: "page", pageNumber: "\(currentPage)", per: "per", perSize: "10")
        
        cancellable = provider.request(
            with: EventAPI.events(query),
            scheduler: RunLoop.main,
            class: EventResponse.self
        )
        .handleEvents(receiveOutput: { [weak self] response in
          guard let self = self else { return }
            self.canLoadMorePages = self.events.count < response.metadata.total
            self.isLoadingPage = false
            self.currentPage += 1
        })
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { completionResponse in
            switch completionResponse {
            case .failure(let error):
                print(#line, error)
                self.canLoadMorePages = false
            case .finished:
                break
            }
        }, receiveValue: { [weak self] res in
          guard let self = self else { return }
            DispatchQueue.main.async {
                self.events = (self.events + res.items)
            }
           
        })
    }

    func createEvent(_ event: Event, _ completionHandler: @escaping (Bool) -> Void) {
        
      cancellable = provider.request(
            with: EventAPI.create(event),
            scheduler: RunLoop.main,
            class: Event.self
      )
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { completionResponse in
          switch completionResponse {
          case .failure(let error):
              print(#line, error)
              self.canLoadMorePages = false
            completionHandler(false)
          case .finished:
              break
          }
      }, receiveValue: {  res in
        print(#line, res)
        completionHandler(true)
      })
      
    }
    

    func fetchMoreMyEvents() {
        
        guard !isLoadingPage && canLoadMorePages else {
            return
        }
        
        isLoadingPage = true
        
        print(#line, currentPage, canLoadMorePages)
        
        let query = QueryItem(page: "page", pageNumber: "\(currentPage)", per: "per", perSize: "10")
        
        cancellable = provider.request(
            with: EventAPI.myEvents(query),
            scheduler: RunLoop.main,
            class: EventResponse.self
        )
        .handleEvents(receiveOutput: { [weak self] response in
          guard let self = self else { return }
          
            self.canLoadMorePages = self.myEvents.count < response.metadata.total
            self.isLoadingPage = false
            self.currentPage += 1
        })
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { completionResponse in
            switch completionResponse {
            case .failure(let error):
                print(#line, error)
                self.canLoadMorePages = false
            case .finished:
                break
            }
        }, receiveValue: { [weak self] res in
          guard let self = self else { return }
            DispatchQueue.main.async {
                self.myEvents = (self.myEvents + res.items)
            }
           
        })
    }
}
