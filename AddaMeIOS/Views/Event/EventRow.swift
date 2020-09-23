//
//  EventRow.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 31.08.2020.
//

import SwiftUI
import Combine

struct EventRow: View {
    var event: EventResponse.Item
    
    @Environment(\.imageCache) var cache: ImageCache
    
    var body: some View {
        HStack {
            AsyncImage(
                url: URL(string: event.imageURL ?? "https://image.tmdb.org/t/p/original/pThyQovXQrw2m0s9x82twj48Jq4.jpg")!,
                placeholder: Text("Loading ..."), cache: self.cache,
                configuration: {
                    $0.resizable()
                }
            )
            .aspectRatio(contentMode: .fit)
            .frame(width: 65, height: 100)
            .clipShape(Circle())
            .padding(5)
            .padding(.leading)
            VStack(alignment: .leading) {
                Text(event.name)
                    .alignmentGuide(.leading) { d in d[.leading] }
                    .font(.system(size: 21, weight: .light, design: .serif))
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                
                Spacer()
                HStack() {
                    ForEach(1...6, id: \.self){ i in
                        Image("Alif")
                            .resizable()
                            .renderingMode(.original)
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                            .overlay(
                             RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.red, lineWidth: 1.5)
                            )
                    }
                    .padding(.trailing, -15)
                    .padding(.bottom, 8)
                    //Spacer()
                }

            }
            
            Spacer()
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(#colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 0.5)))
        )
        .padding(.top, 3)
    }
}

struct EventRow_Previews: PreviewProvider {
    static var previews: some View {
        EventRow(event: eventData.items[0] )
    }
}
