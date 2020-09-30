//
//  MessageCellView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 05.09.2020.
//

import SwiftUI

struct MessageCellView : View {
    
    var lastMsg: LastMessage
    @Environment(\.imageCache) var cache: ImageCache
    
    var body : some View {
        
        HStack(spacing: 15) {
            
            AsyncImage(
                url: URL(string: lastMsg.avatar)!,
                placeholder: Text("Loading ..."), cache: self.cache,
                configuration: {
                    $0.resizable()
                }
            )
            .aspectRatio(contentMode: .fit)
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            
            VStack(alignment:.leading,spacing: 5) {
                Text(lastMsg.firstName ?? lastMsg.phoneNumber)
                    .font(.system(size: 18, weight: .semibold, design: .serif))
                
                Text(lastMsg.messageBody).lineLimit(2)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 10) {
                
                Text("\(lastMsg.timestamp)")
                if lastMsg.messageBody != "" {
                    Text("\(lastMsg.totalUnreadMessages)").padding(8).background(Color("bg")).foregroundColor(.white).clipShape(Circle())
                } else{
                    Spacer()
                }
            }
            
        }
        .padding(9)
    }
}

struct MessageCellView_Previews: PreviewProvider {
    static var previews: some View {
        MessageCellView(lastMsg: demoLastMessages[0])
    }
}
