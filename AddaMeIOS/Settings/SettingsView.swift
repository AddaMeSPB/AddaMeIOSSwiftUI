//
//  SettingsView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 26.11.2020.
//

import SwiftUI

struct SettingsView: View {
  @AppStorage(AppUserDefaults.Key.distance.rawValue) var distance: Double = 250.0
  
  @State private var showingTermsSheet = false
  @State private var showingPrivacySheet = false
  
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      
      Text("Settings")
        .font(.title)
        .bold()
        .padding()
      
      DistanceFilterView(distance: self.$distance)
        .padding([.top, .bottom], 20)
        .transition(.opacity)
      
      HStack {
        Spacer()
        Button(action: {
          showingTermsSheet = true
        }, label: {
          Text("Terms")
            .font(.title)
            .bold()
            .foregroundColor(.blue)
        })
        .sheet(isPresented: $showingTermsSheet) {
          TermsAndPrivacyWebView(urlString: EnvironmentKeys.rootURL.absoluteString + "/terms")
        }
        
        Text("&")
          .font(.title3)
          .bold()
          .padding([.leading, .trailing], 10)
        
        Button(action: {
          showingPrivacySheet = true
        }, label: {
          Text("Privacy")
            .font(.title)
            .bold()
            .foregroundColor(.blue)
        })
        .sheet(isPresented: $showingPrivacySheet) {
          TermsAndPrivacyWebView(urlString: EnvironmentKeys.rootURL.absoluteString + "/privacy")
        }
        
        Spacer()
      }
      .frame(width: .infinity, height: 100, alignment: .center)
      .background(Color.yellow)
      .clipShape(Capsule.init())
      .padding()
      
      Spacer()
      
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}

struct DistanceFilterView: View {
  
  @Binding var distance: Double
  @AppStorage(AppUserDefaults.Key.distance.rawValue) var distanceValue: Double = 250.0
  
  var minDistance = 5.0
  var maxDistance = 250.0
  
  var body: some View {
    VStack(alignment: .leading) {
      
      Text("Near by distance \(Int(distance)) km")
        .font(.title3)
        .bold()
        .onChange(of: /*@START_MENU_TOKEN@*/"Value"/*@END_MENU_TOKEN@*/, perform: { value in
          distanceValue = distance
        })
        .font(.system(.headline, design: .rounded))
      
      HStack {
        Slider(value: $distance, in: minDistance...maxDistance, step: 1, onEditingChanged: {changing in self.update(changing) })
          .accentColor(.green)
      }
      
      HStack {
        Text("\(Int(minDistance))")
          .font(.system(.footnote, design: .rounded))
        
        Spacer()
        
        Text("\(Int(maxDistance))")
          .font(.system(.footnote, design: .rounded))
      }
      
    }
    .onAppear {
      update(true)
    }
    .padding(.horizontal)
    .padding(.bottom, 10)
  }
  
  func update(_ changing: Bool) -> Void {
    distanceValue = distance == 0 ? 249 : distance
  }
  
}

struct DistanceFilterView_Previews: PreviewProvider {
  static var previews: some View {
    DistanceFilterView(distance: .constant(250))
  }
}
