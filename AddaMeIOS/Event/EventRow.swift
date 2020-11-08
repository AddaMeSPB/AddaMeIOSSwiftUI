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
  @StateObject private var locationManager = LocationManager()
  
  var body: some View {
    HStack {
      AsyncImage(
        avatarLink: event.imageUrl,
        placeholder: Text("Loading ..."), cache: self.cache,
        configuration: {
          $0.resizable()
        }
      )
      .aspectRatio(contentMode: .fit)
      .frame(width: 45, height: 60)
      .clipShape(Circle())
      .padding(5)
      .padding(.leading)
      VStack(alignment: .leading) {
        Text(event.name)
          .lineLimit(2)
          .alignmentGuide(.leading) { d in d[.leading] }
          .font(.system(size: 23, weight: .light, design: .serif))
          .padding(.top, 10)
        Text("\(event.eventPlaces.last?.addressName ?? "")")
          .lineLimit(2)
          .alignmentGuide(.leading) { d in d[.leading] }
          .font(.system(size: 15, weight: .light, design: .serif))
          .foregroundColor(.blue)
        HStack {
          Spacer()
          Text("\(distance) away")
            .lineLimit(2)
            .alignmentGuide(.leading) { d in d[.leading] }
            .font(.system(size: 15, weight: .light, design: .serif))
            .foregroundColor(.blue)
            .padding(.bottom, 10)
        }
        .padding(.bottom, 5)
        
        //Spacer()
        //                HStack() {
        //                    ForEach(1...6, id: \.self){ i in
        //                        Image("Avatar\(Int.random(in: 0...1))")
        //                            .resizable()
        //                            .renderingMode(.original)
        //                            .frame(width: 30, height: 30)
        //                            .clipShape(Circle())
        //                            .overlay(
        //                             RoundedRectangle(cornerRadius: 16)
        //                                .stroke(Color.red, lineWidth: 1.5)
        //                            )
        //                    }
        //                    .padding(.trailing, -15)
        //                    .padding(.bottom, 10)
        //                    //Spacer()
        //                }
        
      }
      
      Spacer()
    }
    .background(
      RoundedRectangle(cornerRadius: 10)
        .foregroundColor(Color(#colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 0.5)))
    )
    .padding(7)
  }
  
  var distance: String {
    event.eventPlaces.last != nil ?
      locationManager.distance(event.eventPlaces.last!) : "unknown"
    
  }
}

struct EventRow_Previews: PreviewProvider {
  static var previews: some View {
    EventRow(event: eventData[0])
  }
}
