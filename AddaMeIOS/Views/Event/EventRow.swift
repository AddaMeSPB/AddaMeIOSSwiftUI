//
//  EventRow.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 31.08.2020.
//

import SwiftUI

struct EventRow: View {
    var event: Event
    
    @Environment(\.imageCache) var cache: ImageCache
    
    var body: some View {
        HStack {
            AsyncImage(
                url: URL(string: event.imageUrl ?? "https://image.tmdb.org/t/p/original/pThyQovXQrw2m0s9x82twj48Jq4.jpg")!,
                placeholder: Text("Loading ..."), cache: self.cache,
                configuration: {
                    $0.resizable()
                }
            )
                .aspectRatio(contentMode: .fit)
                .frame(width: 65, height: 100)
                .clipShape(Circle())
            VStack(alignment: .leading) {
                Text(event.name)
                    .alignmentGuide(.leading) { d in d[.leading] }
                    .font(.system(size: 21, weight: .light, design: .serif))
                
                Spacer()
                HStack {
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
                    Spacer()
                }

            }
            
            Spacer()
        }
    }
}

struct EventRow_Previews: PreviewProvider {
    static var previews: some View {
        EventRow(event: globalEvents[0])
    }
}

var globalEvents: [Event] = [Event(
    id: "",
    name: """
        As of Beta 3 you cannot create a top-level global @State variable. The compiler will segfault. You can place one in a struct and create an instance of the struct in order to build. However, if you actually instantiate that you'll get a runtime error like: Accessing State<Bool> outside View.body.
    """, imageUrl: "https://image.tmdb.org/t/p/original/pThyQovXQrw2m0s9x82twj48Jq4.jpg", duration: 36000,
         categories: "general",
         ownerID: ""
    ),
                             
                             Event(
                                id: "",
                                name: """
        As of Beta 3 you cannot create a top-level global @State variable. The compiler will segfault. You can place one in a struct and create an instance of the struct in order to build. However, if you actually instantiate that you'll get a runtime error like: Accessing State<Bool> outside View.body.
    """, imageUrl: "https://image.tmdb.org/t/p/original/pThyQovXQrw2m0s9x82twj48Jq4.jpg", duration: 36000,
         categories: "general",
         ownerID: ""
    ),
                             
                             Event(
                                id: "",
                                name: """
        As of Beta 3 you cannot create a top-level global @State variable. The compiler will segfault. You can place one in a struct and create an instance of the struct in order to build. However, if you actually instantiate that you'll get a runtime error like: Accessing State<Bool> outside View.body.
    """, imageUrl: "https://image.tmdb.org/t/p/original/pThyQovXQrw2m0s9x82twj48Jq4.jpg", duration: 36000,
         categories: "general",
         ownerID: ""
    ),
                             
                             Event(
                                id: "",
                                name: """
        As of Beta 3 you cannot create a top-level global @State variable. The compiler will segfault. You can place one in a struct and create an instance of the struct in order to build. However, if you actually instantiate that you'll get a runtime error like: Accessing State<Bool> outside View.body.
    """, imageUrl: "https://image.tmdb.org/t/p/original/pThyQovXQrw2m0s9x82twj48Jq4.jpg", duration: 36000,
         categories: "general",
         ownerID: ""
    ),
                             
                             Event(
                                id: "",
                                name: """
        As of Beta 3 you cannot create a top-level global @State variable. The compiler will segfault. You can place one in a struct and create an instance of the struct in order to build. However, if you actually instantiate that you'll get a runtime error like: Accessing State<Bool> outside View.body.
    """, imageUrl: "https://image.tmdb.org/t/p/original/pThyQovXQrw2m0s9x82twj48Jq4.jpg", duration: 36000,
         categories: "general",
         ownerID: ""
    ),
                             
                             Event(
                                id: "",
                                name: """
        As of Beta 3 you cannot create a top-level global @State variable. The compiler will segfault. You can place one in a struct and create an instance of the struct in order to build. However, if you actually instantiate that you'll get a runtime error like: Accessing State<Bool> outside View.body.
    """, imageUrl: "https://image.tmdb.org/t/p/original/pThyQovXQrw2m0s9x82twj48Jq4.jpg", duration: 36000,
         categories: "general",
         ownerID: ""
    )
]
