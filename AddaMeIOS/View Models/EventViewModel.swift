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


class EventViewModel: ObservableObject {

    typealias Handler = (Result<Bool, Never>) -> Void
    
    @Published var events = [Event]()
    @Published var event: Event?
    
    let provider = Pyramid()
    var cancellable: AnyCancellable?
    let authenticator = Authenticator()
    
    init() {
        fetchEvents()
    }

}


extension EventViewModel {
    func fetchEvents() {
        cancellable = provider.request(
            with: EventAPI.events,
            scheduler: RunLoop.main,
            class: [Event].self
        )
        .sink(receiveCompletion: { completionResponse in
            switch completionResponse {
            case .failure(let error):
                print(#line, error)
            case .finished:
                break
            }
        }, receiveValue: { res in
            print(res)
            self.events = res
        })
    }
    
    func createEvent(_ event: Event, _ checkPoint: CheckPoint, completionHandler: @escaping Handler) {
        
        cancellable = provider.request(
            with: EventAPI.create(event),
            scheduler: RunLoop.main,
            class: Event.self
        )
        .sink(receiveCompletion: { completionResponse in
            switch completionResponse {
            case .failure(let error):
                print(#line, error)
            case .finished:
                break
            }
        }, receiveValue: { res in
            print(res)
            // create GeoLocation
            self.creatGeoLocation(res.id!, checkPoint) { result in
                _ = result.map { bool in
                    completionHandler(.success(bool == true ? true : false ))
                }
            }
        })
    
    }
    
    private func creatGeoLocation(_ eventID: String, _ checkPoint: CheckPoint, completionHandler: @escaping Handler) {
        let geoLocation = GeoLocation(addressName: checkPoint.title!, type: .Point, coordinates: checkPoint.coordinate.coordinate, eventID: eventID)
        
        cancellable = provider.request(
            with: GeoLocationAPI.create(geoLocation),
            scheduler: RunLoop.main,
            class: GeoLocationResponse.self
        )
        .sink(receiveCompletion: { completionResponse in
            switch completionResponse {
            case .failure(let error):
                print(#line, error)
                completionHandler(.success(false))
            case .finished:
                break
            }
        }, receiveValue: { res in
            print(res)
            completionHandler(.success(true))
        })
        
    }

}
