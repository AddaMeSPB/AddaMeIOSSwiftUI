//
//  ChatView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 05.09.2020.
//

import SwiftUI

struct ChatView: View {
    
    @EnvironmentObject var data: MsgDatas
    
    var body : some View {
        ZStack {
            Color("bg")
            .edgesIgnoringSafeArea(.top)
            
            NavigationLink(destination: ChatDetailsView(), isActive: $data.show) {
                EmptyView()
            }
            
            VStack {
                ChatTopView()
                MessageListView()
                        .clipShape(RoundLeft())
            }
        
        }
        
    }
}


struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
        .environmentObject(MsgDatas())
    }
}
