//
//  ChatsView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 05.09.2020.
//

import SwiftUI

struct ChatsView: View {
    @State var expand = false
    @EnvironmentObject var data: MsgDatas
    
    var body: some View {
        
        ZStack {
            Color("bg")
                .edgesIgnoringSafeArea(.top)
            
            NavigationLink(destination: ChatDetailsView(), isActive: $data.show) {
                EmptyView()
            }
            
            VStack {
                ChatTopView()
            }
            
        }
    }
}

struct ChatsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsView().environmentObject(MsgDatas())
    }
}

class MsgDatas: ObservableObject {
    @Published var show : Bool = false
    @Published var selectedData: MsgType = .init(id: -1, msg: "", time: "", msgs: "", name: "", pic: "")
}

struct MsgType : Identifiable {
    var id : Int
    var msg : String
    var time : String
    var msgs : String
    var name : String
    var pic : String
}

var msgs : [MsgType] = [
    
    MsgType(id: 0, msg: "New Album Is Going To Be Released!!!!", time: "14:32", msgs: "2", name: "Taylor", pic: "p0")
    ,MsgType(id: 1, msg: "Hi this is Steve Rogers !!!", time: "14:35", msgs: "2", name: "Steve", pic: "p1")
    ,MsgType(id: 2, msg: "New Tutorial From Kavosft !!!", time: "14:39", msgs: "1", name: "Kavsoft", pic: "p2")
    ,MsgType(id: 3, msg: "New SwiftUI API Is Released!!!!", time: "14:50", msgs: "", name: "SwiftUI", pic: "p3")
    ,MsgType(id: 4, msg: "Free Publicity For Apple Products!!!", time: "15:00", msgs: "", name: "Justine", pic: "p4"),
     MsgType(id: 5, msg: "Founder Of Microsoft !!!", time: "14:50", msgs: "", name: "Bill Gates", pic: "p5"),
     MsgType(id: 6, msg: "Founder Of Amazon", time: "14:39", msgs: "1", name: "Jeff", pic: "p6"),
     MsgType(id: 7, msg: "Released New iPhone 11!!!", time: "14:32", msgs: "2", name: "Tim Cook", pic: "p7")
     
     
]
