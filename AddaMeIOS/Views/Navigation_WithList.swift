//
//  Navigation_WithList.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 16.10.2020.
//

import SwiftUI

//ScrollView {
//    LazyVStack {
//        ForEach(
//            NavigationLink(

struct Navigation_WithList: View {
    @State var data = ["Milk", "Bread", "Tomatoes", "Lettuce", "Onions", "Rice", "Limes"]
    var body: some View {
        ScrollView {
            LazyVStack {
//                NavigationView {
                    ForEach(data, id: \.self) { datum in
                        NavigationLink(destination: ShoppingDetail(shoppingItem: datum)) {
                            Text(datum).font(Font.system(size: 24)).padding()
                        }
                    }
                    .listStyle(GroupedListStyle())
                    .navigationTitle("Shopping")
                    .toolbar {
                        ToolbarItem {
                            Button("Add", action: { data.append("New Shopping Item") })
                            
                        }
                        
                    }
//                }
            }
        }
//        NavigationView {
//            List(data, id: \.self) { datum in
//                NavigationLink(destination: ShoppingDetail(shoppingItem: datum)) {
//                Text(datum).font(Font.system(size: 24)).padding()
//
//            }
//
//            }
//
//            .listStyle(GroupedListStyle())
//            .navigationTitle("Shopping")
//            .toolbar {
//                ToolbarItem {
//                    Button("Add", action: { data.append("New Shopping Item") })
//
//                }
//
//            }
//
//        }
        
    }
    
}


struct Navigation_WithList_Previews: PreviewProvider {
    static var previews: some View {
        Navigation_WithList()
    }
}


struct ShoppingDetail: View {
    var shoppingItem: String!
    var body: some View {
        VStack {
            Text("Shopping List Details").font(.title)                .frame(maxWidth: .infinity).padding()                .background(Color("Theme3ForegroundColor"))                .foregroundColor(Color("Theme3BackgroundColor"))
            Spacer()
            Text(shoppingItem).font(.title)
            Spacer()
            
        }.navigationTitle(shoppingItem)
        
    }
    
}
