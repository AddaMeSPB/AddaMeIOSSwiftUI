////
////  VarticalExample.swift
////  AddaMeIOS
////
////  Created by Saroar Khandoker on 26.10.2020.
////
//
//import SwiftUI
//import MapKit
//
//struct MapViewWithAnnotations: View {
//    
//    @State var hud = false
//    
//    var body: some View {
//      NavigationView {
//              List {
//                  ForEach(demoConversations) { conversation in
//                      NavigationLink(
//                          destination: ChatRoomView(conversation: conversation)
//                              .edgesIgnoringSafeArea(.bottom)
//                              .onAppear(perform: {
//                                  //appState.tabBarIsHidden = true
//                              })
//                              .onDisappear(perform: {
//                                  //appState.tabBarIsHidden = false
//                              })
//                      ) {
//                          
//                          ConversationRow(conversation: conversation)
//                          
//                      }
//                  }
//                  
////                  if conversationViewModel.isLoadingPage {
////                      ProgressView()
////                  }
//                  
//              }
//              .onAppear {
//                  //self.conversationViewModel.fetchMoreConversations()
//              }
//              .navigationTitle("Chats")
////              .toolbar {
////                  ToolbarItem(placement: .navigationBarTrailing ) {
////                      Button(action: {
////                          self.moveToContacts = true
////                      }) {
////                          Image(systemName: "plus").resizable().frame(width: 20, height: 20)
////                      }
////                      .background (
////                          NavigationLink(destination: ContactsView(), isActive: self.$moveToContacts ) {
////                              EmptyView()
////                          }
////                          .navigationTitle("Chats")
////                      )
////                  }
////              }
////              .background(Color(.systemBackground))
//      
//    }
//  }
//}
//
//struct MapViewWithAnnotations_Previews: PreviewProvider {
//    static var previews: some View {
//        MapViewWithAnnotations()
//            .environment(\.colorScheme, .dark)
//    }
//}
//
