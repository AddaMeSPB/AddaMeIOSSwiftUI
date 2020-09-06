//
//  ChatTopView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 05.09.2020.
//

import SwiftUI

struct ChatTopView: View {
    
    @EnvironmentObject var data: MsgDatas
    
    var body : some View {
        VStack {
            HStack(spacing: 16) {
                Text("Chats")
                    .fontWeight(.heavy)
                    .font(.system(size: 23))
                
                Spacer()
                
                
                Button(action: {
                    self.data.show.toggle()
                }) {
                    Image(systemName: "magnifyingglass").resizable().frame(width: 20, height: 20)
                }
                .padding(.trailing, 10)
                
                Button(action: {
                    self.data.show.toggle()
                }) {
                    Image(systemName: "plus").resizable().frame(width: 20, height: 20)
                }
            }
            .foregroundColor(Color.white)
            .padding()
            .padding(.bottom, -13)
            
            MessageListView().clipShape(RoundLeft())
            
        }
    }
}


struct ChatTopView_Previews: PreviewProvider {
    static var previews: some View {
        ChatTopView()
    }
}
