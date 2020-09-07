//
//  ChatDetailsTopview.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 05.09.2020.
//

import SwiftUI

struct ChatDetailsTopview: View {
    
    @Environment(\.msgDatas) var data: MsgDatas
    
    var body : some View {
        
        HStack(spacing: 15) {
            
            Button(action: {
                self.data.show.toggle()
            }) {
                Image(systemName: "control")
                    .font(.title)
                    .rotationEffect(.init(degrees: -90))
            }
            
            Spacer()
            
            VStack(spacing: 5) {
                Image(data.selectedData.pic)
                    .resizable()
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
                
                Text(data.selectedData.name)
                    .fontWeight(.heavy)
                
            }.offset(x: 25)
            
            Spacer()
            
            Button(action: {
                
            }) {
                Image(systemName: "phone.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                
            }.padding(.trailing, 25)
            
            Button(action: {
                
            }) {
                Image(systemName: "video.fill")
                    .resizable()
                    .frame(width: 23, height: 16)
            }
            
        }.foregroundColor(.white)
            .padding()
            .padding(.top, -15)
            .padding(.bottom, -15)
    }
}

struct ChatDetailsTopview_Previews: PreviewProvider {
    static var previews: some View {
        ChatDetailsTopview().environmentObject(MsgDatas())
    }
}
