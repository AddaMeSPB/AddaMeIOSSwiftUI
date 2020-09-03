//
//  CardView.swift
//  AddaMeIOS
//
//  Created by Alif on 4/8/20.
//

import SwiftUI

struct CardView: View {
    @State private var selectedTab = Tab.First
    
    private enum Tab {
        case First, Second
    }
    
    var body: some View {
        ZStack {
            RedView()
                .tabItem {
                    Image(systemName: "phone.fill")
                    Text("First Tab")
                }
            BlueView()
                .tabItem {
                    Image(systemName: "tv.fill")
                    Text("Second Tab")
                }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView().frame(height: 400).padding()
    }
}

struct RedView: View {
    var body: some View {
        Color.red
    }
}
struct BlueView: View {
    var body: some View {
        Color.blue
    }
}
