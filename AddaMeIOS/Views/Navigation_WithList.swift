//
//  Navigation_WithList.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 16.10.2020.
//

import SwiftUI
import Combine

class TestViewModel: ObservableObject {
    @Published var questions = [Int: String]()
    
    var count: Int = 0
    
    init() {
      self.questions = [
        0: "Hello",
        1: "Private",
        2: "Asalamualikum"
      ]
    }
    
    func add() {
        count = self.questions.count
        count += 1
        self.questions.updateValue("Hello Alif \(count)", forKey: 0)
        self.questions[count] = "Hi \(count)"
    }
}

struct Navigation_WithList: View {

    @ObservedObject var data: TestViewModel = .init()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(data.questions.map { $1 }.sorted() , id: \.self) { datum in
                        NavigationLink(destination: ShoppingDetail(shoppingItem: datum)) {
                            Text(datum).font(Font.system(size: 24)).padding()
                        }
                    }
                    .listStyle(GroupedListStyle())
                    .navigationTitle("Shopping")
                    .toolbar {
                        ToolbarItem {
                            Button("Add", action: {self.data.add()})
                        }
                        
                    }
                }
            }
        }
        
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
            Text("Shopping List Details")
                .font(.title)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color("Theme3ForegroundColor"))
                .foregroundColor(Color("Theme3BackgroundColor"))
            Spacer()
            Text(shoppingItem).font(.title)
            Spacer()
            
        }.navigationTitle(shoppingItem)
        
    }
    
}
