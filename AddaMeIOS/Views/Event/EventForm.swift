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
    @State private var title: String = ""
    
    @State var checkPointResponse: CheckPoint = CheckPoint(
        title: "",
        coordinate: CLLocationCoordinate2DMake(60.014506, 30.388123)
    )
    
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

    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var globalBoolValue: GlobalBoolValue
    
    @EnvironmentObject var locationSearchService: LocationSearchService
    @EnvironmentObject var eventViewModel: EventViewModel
    
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

//    @State var checkPoints: [CheckPoint] = [
//      CheckPoint(title: "Da Nang", coordinate: .init(latitude: 16.047079, longitude: 108.206230)),
//      CheckPoint(title: "Ha Noi", coordinate: .init(latitude: 21.027763, longitude: 105.834160))
//    ]
    
    var searchTextBinding: Binding<String> {
        Binding<String>(
            get: {
                return self.checkPointResponse.title ?? ""
        },
            set: { newString in
                self.checkPointResponse.title = newString
        })
    }
    
    private var selectedDurations = DurationButtons.allCases.map { $0.rawValue }
    private var selectedCatagories = Categories.allCases.map { $0.rawValue }
    
    var body: some View {
        VStack {
            Form {
                Section(header:
                    HStack {
                        Text("Create Event")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(Color.blue)
                        
                        Spacer()
                        Button(action: {
                            DispatchQueue.main.async {
                                self.globalBoolValue.isTabBarHidden.toggle()
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }) {
                            Image(systemName: "xmark.circle")
                                .imageScale(.large)
                                .font(.title)
                                .foregroundColor(Color.red)
                        }
                        
                    }
                    
                ) {
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
                                //.bold()
                        }
                    }
                    .actionSheet(isPresented: $showCategorySheet, content: { sheetForCategory })
                        
                    //TextField("Location", text: $name)
                    
                    Toggle(isOn: $liveLocationtoggleisOn) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Location tracking is")
                                Spacer()
                                if liveLocationtoggleisOn {
                                    Text("Will use your current Location only while you usin app")
                                        .font(.system(size: 10, weight: .light, design: .serif))
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
                        Text("Please choose your event address")
                        HStack {
                            
                            TextField("Search ...", text: searchTextBinding)
                                .padding(.horizontal, 20)
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
                                    self.moveMapView = true
                                }
                        }
                        .padding()
                        .background(colorScheme == .dark ? Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)) : Color(.systemGray6))
                        .foregroundColor(Color.blue)
                        .accentColor(Color.green)
                        .clipShape(Capsule())
                        .sheet(isPresented: self.$moveMapView) {
                            MapView(checkPointRequest: $checkPointResponse)
                        }
                    }

                    Spacer()

                }
                .padding([.top, .bottom], 13)
                
            }.keyboardAdaptive()
            
            HStack() {
                Spacer()
                Button(action: send) {
                    Image(systemName: "paperplane")
                        .foregroundColor(Color.white)
                }
                .frame(width: 240, height: 40, alignment: .center)
                .background(title.isEmpty ? Color.gray : Color.yellow)
                .clipShape(Capsule())
                .disabled(title.isEmpty)
                .padding(.top, 8)
                Spacer()
            }
            .background(Color.clear)
            
        }
        .navigationBarTitle("",displayMode: .inline)
        .navigationBarHidden(true)

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
                .font(.system(size: 35, weight: .bold, design: .serif))
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
        let durationValue = DurationButtons.allCases[selectedDurationIndex]
        let categoryValue = Categories.allCases[selectedCateforyIndex]
        
        // add user image url from user profile
        let event = Event(name: title, duration: durationValue.value, categories: "\(categoryValue)")

        eventViewModel.createEvent(event, checkPointResponse, completionHandler: { result in
            _ = result.map { bool in
                if bool == true {
                    _ = Alert(title: Text("Event create successfully completed"))
                    sleep(2)
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        })
    }
}

struct EventForm_Previews: PreviewProvider {
    static var previews: some View {
        EventForm()
            //.environment(\.colorScheme, .dark)
    }
}

enum Categories: String, CaseIterable { // cant change serial
    case General, Hangouts
    case lookingForAcompany = "Looking for a company"
    case Acquaintances, Work,
    Question, News, Services, Meal,
    Children, Shop, Mood, Sport, Accomplishment, Ugliness,
    Driver, Discounts, Warning, Health, Animals, Weekend,
    Education, Walker, Realty, Charity, Accident, Weather

    case GetTogether = "Get Together"
    case TakeOff = "Take Off"
    case iWillbuy = "I will buy"
    case acceptAsAgift = "Accept as a gift"
    case theCouncil = "The Council"
    case giveAway = "Give Away"
    case lifeHack = "Life hack"
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