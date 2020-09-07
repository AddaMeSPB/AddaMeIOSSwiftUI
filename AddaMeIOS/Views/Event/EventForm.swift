//
//  EventForm.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 07.09.2020.
//

import SwiftUI

struct EventForm: View {
    @State private var title: String = ""
    @State private var durationText: String = ""
    @State private var categoryText: String = ""
    @State private var selectedCateforyIndex: Int = 0
    @State private var selectedDurationIndex: Int = 0
    @State private var showCategorySheet = false
    @State private var showDurationSheet = false
    
    private var selectedDurations = DurationLable.allCases.map { $0.rawValue }
    private var selectedCatagories = Categories.allCases.map { $0.rawValue }
    
    var body: some View {
        VStack {
            Form {
                Section(
                    header: Text("Create Event")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(Color.blue)
                ) {
                    TextField("Title", text: $title)
                        .hideKeyboardOnTap()
                        .lineLimit(3)
//                        .frame(height: 50)
//                        .background(Color.gray)
//                        .clipShape(Capsule())
                    
                    Text("Event Duration \(self.selectedDurations[selectedDurationIndex])")
                        .font(.title).bold()
                    Picker("Hi", selection: $selectedDurationIndex) {
                        ForEach(0..<selectedDurations.count) { i in
                            Text("\(self.selectedDurations[i])")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    Button(action: {
                        self.showCategorySheet = true
                    }) {
                        //self.categoryText = selectedCatagories[selectedDurationIndex]
                        Text("Selected Categoris \(selectedCatagories[selectedCateforyIndex])")
                    }
                    .actionSheet(isPresented: $showCategorySheet, content: { sheetForCategory })
                        
                    //TextField("Location", text: $name)
                }
                .padding()
                
            }
            
            HStack() {
                Spacer()
                Button(action: {
                    // call send button here
                }) {
                    Image(systemName: "paperplane")
                        .foregroundColor(Color.white)
                }
                .frame(width: 240, height: 50, alignment: .center)
                .background(title.isEmpty ? Color.gray : Color.yellow)
                .clipShape(Capsule())
                .disabled(title.isEmpty)
                Spacer()
            }
            Spacer()
        }
    }
   
    private var sheetForDuration: ActionSheet {
           let action = ActionSheet(title: Text("Select your Category"), buttons: [
               .default(Text("30 Min")) { self.selectedDurationIndex = 0 },
               .default(Text("1 Hour")) { self.selectedDurationIndex = 1 },
               .default(Text("2 Hoours")) { self.selectedDurationIndex = 2 },
               .default(Text("3 Hours")) { self.selectedDurationIndex = 3 },
               .default(Text("4 Hours")) { self.selectedDurationIndex = 4 },
               .cancel()
           ])
           
           return action
       }
    
    private var sheetForCategory: ActionSheet {
        let action = ActionSheet(title: Text("Select your Category"), buttons: [
            .default(Text("General")) { self.selectedCateforyIndex = 0 },
            .default(Text("TakeOff")) { self.selectedCateforyIndex = 1 },
            .default(Text("Pass")) { self.selectedCateforyIndex = 2 },
            .default(Text("Acquaintances")) { self.selectedCateforyIndex = 3 },
            .default(Text("Work")) { self.selectedCateforyIndex = 4 },
            .default(Text("Question")) { self.selectedCateforyIndex = 5 },
            .default(Text("News")) { self.selectedCateforyIndex = 6 },
            .default(Text("Services")) { self.selectedCateforyIndex = 7 },
            .default(Text("Event")) { self.selectedCateforyIndex = 8 },
            .default(Text("Meal")) { self.selectedCateforyIndex = 9 },
            .default(Text("Children")) { self.selectedCateforyIndex = 10 },
            .default(Text("Shop")) { self.selectedCateforyIndex = 11 },
            .default(Text("Mood")) { self.selectedCateforyIndex = 12 },
            .default(Text("Sport")) { self.selectedCateforyIndex = 13 },
            .default(Text("Accomplishment")) { self.selectedCateforyIndex = 14 },
            .default(Text("Ugliness")) { self.selectedCateforyIndex = 15 },
            .default(Text("Driver")) { self.selectedCateforyIndex = 16 },
            .default(Text("Discounts")) { self.selectedCateforyIndex = 17 },
            .default(Text("Warning")) { self.selectedCateforyIndex = 18 },
            .default(Text("Health")) { self.selectedCateforyIndex = 19 },
            .default(Text("Animals")) { self.selectedCateforyIndex = 20 },
            .default(Text("Weekend")) { self.selectedCateforyIndex = 21 },
            .default(Text("Education")) { self.selectedCateforyIndex = 22 },
            .default(Text("Walker")) { self.selectedCateforyIndex = 23 },
            .default(Text("Realty")) { self.selectedCateforyIndex = 24 },
            .default(Text("Charity")) { self.selectedCateforyIndex = 25 },
            .default(Text("Accident")) { self.selectedCateforyIndex = 26 },
            .default(Text("Weather")) { self.selectedCateforyIndex = 27 },
            .default(Text("I will buy")) { self.selectedCateforyIndex = 28 },
            .default(Text("Accept as a gift")) { self.selectedCateforyIndex = 29 },
            .default(Text("The Council")) { self.selectedCateforyIndex = 30 },
            .default(Text("Give Away")) { self.selectedCateforyIndex = 31 },
            .default(Text("Life hack")) { self.selectedCateforyIndex = 32 },
            .default(Text("Looking for a company")) { self.selectedCateforyIndex = 33 },
            .default(Text("Sell Off")) { self.selectedCateforyIndex = 34 },
            .default(Text("Found")) { self.selectedCateforyIndex = 35 },
            .cancel() {
                self.showDurationSheet = false
                self.showCategorySheet = false
            }
        ])
        
        return action
    }
    
    func send() {
        durationText = selectedDurations[selectedDurationIndex]
        categoryText = selectedCatagories[selectedCateforyIndex]
    }
}

struct EventForm_Previews: PreviewProvider {
    static var previews: some View {
        EventForm()
    }
}

enum Categories: String, CaseIterable { // cant change serial
    case General, TakeOff, Pass, Acquaintances, Work,
    Question, News, Services, Event, Meal,
    Children, Shop, Mood, Sport, Accomplishment, Ugliness,
    Driver, Discounts, Warning, Health, Animals, Weekend,
    Education, Walker, Realty, Charity, Accident, Weather

    case iWillbuy = "I will buy"
    case acceptAsAgift = "Accept as a gift"
    case theCouncil = "The Council"
    case giveAway = "Give Away"
    case lifeHack = "Life hack"
    case lookingForAcompany = "Looking for a company"
    case SellOff = "Sell Off"
    case Found
}

enum DurationLable: String, CaseIterable {
    case ThirtyMinutes = "30m"
    case OneHour = "1hr"
    case TwoHours = "2hr"
    case ThreeHours = "3hr"
    case FourHours = "4hr"
    
    
}
