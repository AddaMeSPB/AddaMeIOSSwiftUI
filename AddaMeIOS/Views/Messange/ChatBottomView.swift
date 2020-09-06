//
//  ChatBottomView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 05.09.2020.
//

import SwiftUI

struct ChatBottomView: View {
    
    @State var txt = ""

    var body: some View {
        
        HStack{
            Button(action: {
                
            }) {
                Image(systemName: "camera.fill")
                    .font(.body)
            }.foregroundColor(.gray)
            
            HStack(spacing : 8){
                
                Button(action: {
                    
                }) {
                    Image(systemName: "smiley").resizable().frame(width: 20, height: 20)
                }.foregroundColor(.gray)
                
                TextField("Type Something", text: $txt)
                
                Button(action: {
                    
                }) {
                    Image(systemName: "paperclip")
                        .font(.body)
                }.foregroundColor(.gray)
            }.padding()
                .background(Color("Color"))
                .clipShape(Capsule())
            
            Button(action: {

            }) {
                Image(systemName: "mic.fill")
                    .resizable()
                    .frame(width: 15, height: 23)
                    .padding(13)
                    .foregroundColor(.white)
                    .background(Color("bg"))
                    .clipShape(Circle())
                
            }.foregroundColor(.gray)
            
        }.padding(.horizontal, 15)
            .background(Color.white)
        .padding(.bottom, 8)
            .background(Color.white)
            
        
    }
}


struct ChatBottomView_Previews: PreviewProvider {
    static var previews: some View {
        ChatBottomView()
    }
}
