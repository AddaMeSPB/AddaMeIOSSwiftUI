//
//  EventRow.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 31.08.2020.
//

import SwiftUI
import Combine
import MapKit
import EventClient
import AsyncImageLoder
import AddaMeModels

public struct EventRow: View {
  
  var image: ImageDraw = ImageDraw()
  var event: EventResponse.Item
  var currentLocation: CLLocation?
  
  public var body: some View {
    HStack {

      if event.imageUrl != nil {
        AsyncImage(
          urlString: event.imageUrl,
          placeholder: { Text("Loading...").frame(width: 100, height: 100, alignment: .center) },
          image: {
            Image(uiImage: $0).resizable()
          }
        )
        .aspectRatio(contentMode: .fit)
        .frame(width: 120)
        .padding(.trailing, 15)
        .cornerRadius(radius: 10, corners: [.topLeft, .bottomLeft])
      } else {
        Image(systemName: "photo")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 55)
          .padding(40)
          .cornerRadius(radius: 10, corners: [.topLeft, .bottomLeft])
      }
      
      VStack(alignment: .leading) {
        Text(event.name)
          .lineLimit(2)
          .alignmentGuide(.leading) { d in d[.leading] }
          .font(.system(size: 23, weight: .light, design: .rounded))
          .padding(.top, 10)
        
        Text(event.addressName)
          .lineLimit(2)
          .alignmentGuide(.leading) { d in d[.leading] }
          .font(.system(size: 15, weight: .light, design: .rounded))
          .foregroundColor(.blue)
          .padding(.bottom, 5)
        
        
        Spacer()
        HStack {
          Spacer()
          Text("\(distance) away")
            .lineLimit(2)
            .alignmentGuide(.leading) { d in d[.leading] }
            .font(.system(size: 15, weight: .light, design: .rounded))
            .foregroundColor(.blue)
            .padding(.bottom, 10)
        }
        .padding(.bottom, 5)

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
    guard let currentCoordinate = self.currentLocation else {
      print(#line, "Missing currentCoordinate")
      return "Loading Coordinate"
    }
    
    let distance = currentCoordinate.distance(from: event.location) / 1000
    return String(format: "%.02f km", distance)
  }
}

//struct EventRow_Previews: PreviewProvider {
//  static var previews: some View {
//    EventRow(event: )
//  }
//}


public struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner

  public struct CornerRadiusShape: Shape {

        var radius = CGFloat.infinity
        var corners = UIRectCorner.allCorners

    public func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }

  public func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}

extension View {
    func cornerRadius(radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
}
