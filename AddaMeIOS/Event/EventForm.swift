//
//  EventForm.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 07.09.2020.
//

import SwiftUI
import Combine
import MapKit

struct EventForm: View {
  
  @EnvironmentObject var appState: AppState
  @State private var title: String = String.empty
  @State private var selectedCateforyIndex: Int = 0
  @State private var selectedDurationIndex: Int = 0
  @State private var showCategorySheet = false
  @State private var showDurationSheet = false
  @State private var liveLocationtoggleisOn = true
  @State private var moveMapView = false
  @State private var selectLocationtoggleisOn = false {
    willSet {
      liveLocationtoggleisOn = false
    }
  }
  @State var selectedTag: String?
  @State var showSuccessActionSheet = false
  @State var placeMark: CLPlacemark?
  
  @Environment(\.colorScheme) var colorScheme
  @EnvironmentObject var eventViewModel: EventViewModel
  @Environment(\.presentationMode) var presentationMode
  
  @StateObject var conversationViewModel = ConversationViewModel()
  @EnvironmentObject var locationManager: LocationManager {
    didSet {
      selectedPlace = locationManager.currentEventPlace
    }
  }
  
  @State private var selectedPlace = EventResponse.Item.defint
  var currentPlace = EventResponse.Item.defint

  var searchTextBinding: Binding<String> {
    Binding<String>(
      get: {
        return selectedPlace.addressName.isEmpty ? "\(String(describing: locationManager.currentEventPlace.addressName))" : selectedPlace.addressName
      },
      set: { newString in
        selectedPlace.addressName = newString
      })
  }
  
  private var selectedDurations = DurationButtons.allCases.map { $0.rawValue }
  private var selectedCatagories = Categories.allCases.map { $0.rawValue }
  
  var body: some View {
    VStack {
      Form {
        Section() {
          TextField("Title", text: $title)
            .hideKeyboardOnTap()
            .padding()
            .lineLimit(3)
            .background(colorScheme == .dark ? Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)) : Color(.systemGray6))
            .foregroundColor(Color.blue)
            .accentColor(Color.green)
            .clipShape(Capsule())
          
          HStack {
            Text("Event Duration")
              .font(.title).bold()
            Text(self.selectedDurations[selectedDurationIndex])
              .font(.title).bold()
              .foregroundColor(Color(#colorLiteral(red: 0.9154241085, green: 0.2969468832, blue: 0.2259359956, alpha: 1)))
            
          }
          
          Picker("Hi", selection: $selectedDurationIndex) {
            ForEach(0..<selectedDurations.count) { i in
              Text("\(self.selectedDurations[i])")
            }
          }.pickerStyle(SegmentedPickerStyle())
          
          
          Button(action: {
            self.showCategorySheet = true
          }) {
            //self.categoryText = selectedCatagories[selectedDurationIndex]
            
            HStack {
              VStack(alignment: .leading) {
                Text("Select your")
                Text("Categoris")
              }
              Spacer()
              Text("⇡ \(selectedCatagories[selectedCateforyIndex])")
                .font(.title)
                .foregroundColor(Color(#colorLiteral(red: 0.9154241085, green: 0.2969468832, blue: 0.2259359956, alpha: 1)))
              
            }
          }
          .actionSheet(isPresented: $showCategorySheet, content: { sheetForCategory })
          
          //TextField("Location", text: $name)
          
          Toggle(isOn: $liveLocationtoggleisOn) {
            HStack {
              VStack(alignment: .leading) {
                Text("Your current address \(searchTextBinding.wrappedValue)" as String)
                if liveLocationtoggleisOn {
                  Spacer()
                  Text("Will use your current Location only while you using app")
                    .font(.system(size: 10, weight: .light, design: .rounded))
                    .foregroundColor(Color.red)
                }
              }
              Spacer()
              Text("\(liveLocationtoggleisOn ? "  On" : "  Off")").font(.title)
            }
          }
          .onTapGesture {
            if self.selectLocationtoggleisOn == true {
              self.selectLocationtoggleisOn = !self.selectLocationtoggleisOn
            }
          }
          
          if !liveLocationtoggleisOn {
            Text("Please choose your event address or use defualt")
            HStack {
              
              TextField("Search ...", text: searchTextBinding)
                .padding(.horizontal, 20)
                //.frame(height: .infinity, alignment: .center)
                .lineLimit(3)
                .overlay(
                  HStack {
                    Image(systemName: "magnifyingglass")
                      .foregroundColor(.gray)
                      .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                      .padding(.leading, -5)
                  }
                )
                .padding(.horizontal, 10)
                .onTapGesture {
                  self.selectedPlace = locationManager.currentEventPlace
                  self.moveMapView = true
                }
            }
            .padding()
            .background(colorScheme == .dark ? Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)) : Color(.systemGray6))
            .foregroundColor(Color.blue)
            .accentColor(Color.green)
            .clipShape(Capsule())
            .sheet(isPresented: self.$moveMapView) {
              MapView(place: selectedPlace, places: [selectedPlace])
            }
//            .background(
//              NavigationLink.init(
//                destination: MapView(place: selectedPlace, places: [selectedPlace])
//                  .onAppear(perform: {
//                    appState.tabBarIsHidden = true
//                  })
//                  .onDisappear(perform: {
//                      appState.tabBarIsHidden = false
//                  })
//                  .navigationBarTitle(String.empty)
//                  .navigationBarHidden(true),
//                isActive: $moveMapView,
//                label: {}
//              )
//            )
            
          }
          
          Spacer()
          
        }
        .padding([.top, .bottom], 13)
        
        HStack() {
          Spacer()
          Button(action: send) {
            Image(systemName: "paperplane")
              .foregroundColor(Color.white)
          }
          .frame(width: 140, height: 40, alignment: .center)
          .background(isValid ? Color.gray : Color.yellow)
          .clipShape(Capsule())
          .disabled(isValid)
          .padding(8)
          Spacer()
        }
        .background(Color.clear)
      }
    }
    .navigationBarTitle("Create Event", displayMode: .automatic)
    .actionSheet(isPresented: $showSuccessActionSheet) {
      ActionSheet(
        title: Text("Your Event and GeoLocation was success"),
        message: Text("By tap cancel you will move to Event page"),
        buttons: [
          .cancel {
            self.presentationMode.wrappedValue.dismiss()
          },
        ]
      )
    }
    //        .toolbar {
    //            ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
    //                Button(action: {
    //                    DispatchQueue.main.async {
    //                        self.presentationMode.wrappedValue.dismiss()
    //                    }
    //                }) {
    //                    Image(systemName: "xmark.circle")
    //                        .imageScale(.large)
    //                        .font(.title)
    //                        .foregroundColor(Color.red)
    //                }
    //            }
    //        }
    
  }
  
  func cateforyActionSheetBuilder() -> ActionSheet {
    
    let cancel = Alert.Button.cancel()
    var alertButtons: [Alert.Button] = Categories.allCases.enumerated().map { (idx, item) in
      return Alert.Button.default(Text("\(item.rawValue)")) {
        self.selectedCateforyIndex = idx
      }
    }
    alertButtons.append(cancel)
    
    let action = ActionSheet(
      title: Text("\n\nPlease select your category\n\n")
        .font(.system(size: 35, weight: .bold, design: .rounded))
        .bold(),
      buttons: alertButtons
    )
    
    return action
  }
  
  private var sheetForCategory: ActionSheet {
    let action = cateforyActionSheetBuilder()
    return action
  }
  
  func send() {
    self.selectedPlace = locationManager.currentEventPlace
      
    guard let currenUser: CurrentUser = KeychainService.loadCodable(for: .currentUser) else {
      print(#line, "Missing current user from KeychainService")
      return
    }
    
    let durationValue = DurationButtons.allCases[selectedDurationIndex]
    let categoryValue = Categories.allCases[selectedCateforyIndex]
    
    let event = Event(name: title, details: "", imageUrl: currenUser.attachments?.last?.imageUrlString, duration: durationValue.value, categories: "\(categoryValue)", isActive: true, addressName: searchTextBinding.wrappedValue, type: .Point, sponsored: false, overlay: false, coordinates: selectedPlace.coordinatesMongoDouble)

    eventViewModel.createEvent(event) { result in
      if result == true {
        self.showSuccessActionSheet = true
      }
    }
  }
  
  var isValid: Bool {
    title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || searchTextBinding.wrappedValue.isEmpty
  }
}

struct EventForm_Previews: PreviewProvider {
  static var previews: some View {
    
    EventForm()
    //.environment(\.colorScheme, .dark)
  }
}

enum Categories: String, CaseIterable, Codable { // cant change serial
  case General, Hangouts
  case LookingForAcompany = "Looking for a company"
  case Acquaintances, Work,
       Question, News, Services, Meal,
       Children, Shop, Mood, Sport, Accomplishment, Ugliness,
       Driver, Discounts, Warning, Health, Animals, Weekend,
       Education, Walker, Realty, Charity, Accident, Weather
  
  case GetTogether = "Get Together"
  case TakeOff = "Take Off"
  case IWillbuy = "I will buy"
  case AcceptAsAgift = "Accept as a gift"
  case TheCouncil = "The Council"
  case GiveAway = "Give Away"
  case LifeHack = "Life hack"
  case SellOff = "Sell Off"
  case Found
}

enum DurationButtons: String, CaseIterable {
  case FourHours = "4hr"
  case OneHour = "1hr"
  case TwoHours = "2hr"
  case ThreeHours = "3hr"
  
  var value: Int {
    switch self {
    case .FourHours:
      return 240 * 60
    case .OneHour:
      return 60 * 60
    case .TwoHours:
      return 120 * 60
    case .ThreeHours:
      return 180 * 60
    }
  }
  
  static func getPositionBy(_ minutes: Int) -> String {
    switch minutes {
    case 240 * 60:
      return DurationButtons.allCases[0].rawValue
    case 30 * 60:
      return DurationButtons.allCases[1].rawValue
    case 60 * 60:
      return DurationButtons.allCases[2].rawValue
    case 120 * 60:
      return DurationButtons.allCases[3].rawValue
    case 180 * 60:
      return DurationButtons.allCases[4].rawValue
    default:
      return "Missing minutes"
    }
  }
}

//for i in DurationLable.allCases {
//    print(i.rawValue, i.value)
//    // 30m 1800
//}
//
//print(DurationLable.getPositionBy(1800)) // 30m
