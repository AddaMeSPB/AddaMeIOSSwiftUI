//
//  CardView.swift
//  AddaMeIOS
//
//  Created by Alif on 4/8/20.
//

import SwiftUI

struct CardView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Image("77")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.75)
                    .clipped()
            }
            .padding(.bottom)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView().frame(height: 400).padding()
    }
}
