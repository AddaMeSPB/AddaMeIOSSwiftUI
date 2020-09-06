//
//  MessageCellView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 05.09.2020.
//

import SwiftUI

struct MessageCellView : View {
    
    var pic: String
    var name: String
    var msg: String
    var time: String
    var msgs: String
    
    var body : some View {
        
        HStack(spacing: 15){
            
            Image(pic)
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            
            VStack(alignment:.leading,spacing: 5) {
                Text(name)
                    .font(.system(size: 18, weight: .semibold, design: .serif))
                
                Text(msg).lineLimit(2)
            }
            
            Spacer()
            
            VStack(spacing: 10) {
                
                Text(time)
                if msgs != "" {
                    
                    Text(msgs).padding(8).background(Color("bg")).foregroundColor(.white).clipShape(Circle())
                }
                else{
                    
                    Spacer()
                }
            }
            
        }.padding(9)
    }
}

struct MessageCellView_Previews: PreviewProvider {
    static var previews: some View {
        MessageCellView(pic: "", name: "", msg: "", time: "", msgs: "")
    }
}
