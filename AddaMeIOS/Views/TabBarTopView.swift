//
//  TabBarTopView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 03.09.2020.
//

import SwiftUI

struct TabBarTopView: View {
    @State var search = ""
    @Binding var expand: Bool
    @Binding var searchExpand: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            
            if self.expand {
                                
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack(spacing: 18) {
                        
                        Button(action: {
                            
                        }) {
                            Image(systemName: "plus")
                            .resizable()
                            .frame(width: 25, height: 25)
                                .foregroundColor(Color.yellow)
                            .padding(18)
                            
                        }.background(Color.red)
                        .clipShape(Circle())
                        
                        ForEach(1...7, id: \.self){i in
                            
                            Button(action: {
                                
                            }) {
                                
                                Image(systemName: "ant.circle")
                                .resizable()
                                .renderingMode(.original)
                                .frame(width: 60, height: 60)
                                
                            }
                        }
                    }
                }
                
            }
            
            if self.searchExpand {
                HStack(spacing: 15){
                    
                    Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundColor(Color.black.opacity(0.3))
                    
                    TextField("Search", text: self.$search)
                    
                }.padding()
                .background(Color.white)
                .cornerRadius(8)
                .padding(.bottom, 10)
            }
        }.padding()
        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
            .background(Color.gray.opacity(0.1))
            .clipShape(shape())
        .animation(.default)
    }
}

var globalBool: Bool = true {
    didSet {
        // This will get called
        NSLog("Did Set" + globalBool.description)
    }
}

struct TabBarTopView_Previews: PreviewProvider {
    
    static var previews: some View {
        TabBarTopView(expand:
            Binding<Bool>(get: { globalBool }, set: { globalBool = $0 }),
            searchExpand: Binding<Bool>(get: { globalBool }, set: { globalBool = $0 })
        )
    }
}

struct shape: Shape {
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 22, height: 22) )
    
        return Path(path.cgPath)
    }
}
