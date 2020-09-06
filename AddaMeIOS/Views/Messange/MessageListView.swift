//
//  MessageListView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 05.09.2020.
//

import SwiftUI

struct MessageListView: View {
    @EnvironmentObject var data: MsgDatas
    
    var body : some View {
        List(msgs) { i in
            MessageCellView(pic: i.pic, name: i.name, msg: i.msg, time: i.time, msgs: i.msgs)
                .onTapGesture {

                    DispatchQueue.main.async {
                        self.data.selectedData = i
                        self.data.show.toggle()
                    }
            }
        }
    }
}


struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView()
    }
}
