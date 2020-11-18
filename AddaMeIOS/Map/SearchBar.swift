//
//  SearchBar.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 12.09.2020.
//

import Foundation
import SwiftUI
import MapKit
import Combine

struct SearchBar: View {
  @Binding var text: String
  @State private var isEditing = false
  
  var body: some View {
    HStack {
      TextField("Search ...", text: $text)
        .padding(3)
        .padding(.horizontal, 25)
        .cornerRadius(8)
        .overlay(
          HStack {
            Image(systemName: "magnifyingglass")
              .foregroundColor(.gray)
              .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
              .padding(.leading, 0)
            
            if isEditing {
              Button(action: {
                self.text = String.empty
              }) {
                Image(systemName: "multiply.circle.fill")
                  .foregroundColor(.gray)
                  .padding(.trailing, 5)
              }
            }
          }
        )
        .padding(.horizontal, 10)
        .onTapGesture {
          self.isEditing = true
        }
      
    }
    .padding(10)
    .background(Color(.systemGray6))
    .clipShape(Capsule())
    
  }
}

struct SearchBar_Previews: PreviewProvider {
  static var previews: some View {
    SearchBar(text: .constant(String.empty))
  }
}
