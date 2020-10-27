//
//  MapViewModel.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 10.09.2020.
//

import SwiftUI
import MapKit
import Foundation

struct MapView: View {

    @State private var moveSearchView = false
    @State private var isSearchHidden = false
    
    @State var checkPoint: CheckPoint = CheckPoint(title: "", coordinate: CLLocationCoordinate2DMake(60.014506, 30.388123))
    @State var moveToEventForm = false
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var locationSearchService: LocationSearchService
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var checkPointRequest: CheckPoint
    
    var textBinding: Binding<String> {
        Binding<String>(
            get: {
                return self.checkPoint.title ?? ""
        },
            set: { newString in
                self.checkPoint.title = newString
                addressNameValidation = newString
        })
    }
    
    var idAddressNameValid: Bool {
        checkPoint.title?.count ?? 0 < 1
    }
    
    @State var addressNameValidation: String = ""
    
    var body: some View {
        ZStack {

            if isSearchHidden {
                HStack(alignment: .top) {
                    Spacer()
                    VStack {
                        HStack {
                            TextField("Search ...", text: textBinding)
                                .padding(3)
                                .padding(.horizontal, 25)
                                .cornerRadius(8)
                                .overlay(
                                    HStack {
                                        Image(systemName: "magnifyingglass")
                                            .foregroundColor(.gray)
                                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                            .padding(.leading, 0)
                                    }
                                )
                                .padding(.horizontal, 10)
                                .onTapGesture {
                                    self.moveSearchView.toggle()
                                }
                        }
                        .padding(10)
                        .background(Color(.systemGray6))
                        .clipShape(Capsule())
                        .sheet(isPresented: self.$moveSearchView) {
                            MapView(checkPointRequest: $checkPointRequest)
                        }

                        Spacer()
                    }
                }
                .zIndex(33)
                .padding()
                
            }
            VStack {
                let isEventDetailsPage: Binding = .constant(false)
                MapViewModel(checkPoint: $checkPoint, isEventDetailsPage: isEventDetailsPage)
            }
            
            VStack(alignment: .center) {
                Spacer()
                Button(action: {
                    self.checkPointRequest = self.checkPoint
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Done")
                        .font(.title)
                        .bold()
                }
                .disabled(idAddressNameValid)
                .opacity(idAddressNameValid ? 0 : 1)
                .padding()
            }
        }
    }

}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        let data = eventData[0].geoLocations.last!

        let checkPoint = CheckPoint(title: data.addressName, coordinate: CLLocationCoordinate2DMake(data.coordinates[0], data.coordinates[1]))
        MapView(checkPointRequest: .constant(checkPoint) )
    }
}
