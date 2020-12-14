//
//  AddaMeIOSUITests.swift
//  AddaMeIOSUITests
//
//  Created by Saroar Khandoker on 08.12.2020.
//
import XCTest

class AddaMeIOSUITests: XCTestCase {
  override func setUp() {
    let app = XCUIApplication()
    app.resetAuthorizationStatus(for: .contacts)
    setupSnapshot(app)
    app.launch()
  }
  
  override func setUpWithError() throws {
    continueAfterFailure = false
    
    addUIInterruptionMonitor(withDescription: "Allow Notification") { element -> Bool in
      
      let notificationAlertButton = element.buttons["Allow"].firstMatch
      
      if element.elementType == .alert && notificationAlertButton.exists {
        notificationAlertButton.tap()
        return true
      }
      
      return false
    }
    
    addUIInterruptionMonitor(withDescription: "Allow While Using App") { element -> Bool in
      
      let okButton = element.buttons.element(boundBy: 1)
      if okButton.exists {
          okButton.tap()
          return true
      }
      
      //      let allowButtonForLocation = element.buttons["Allow While Using App"].firstMatch
      //
      //      if element.elementType == .alert && allowButtonForLocation.exists {
      //        allowButtonForLocation.tap()
      //        return true
      //      }
      
      return false
      
    }

    addUIInterruptionMonitor(withDescription: "Contacts Access") { element -> Bool in
      
      let okButton = element.buttons["OK"].firstMatch
      
      if element.elementType == .alert && okButton.exists {
        okButton.tap()
        return true
      }
      
      return false
    }
    
  }
  
  override func tearDownWithError() throws {}
  
  func testTakeScreenshots() {
    let secondDigit = Int.random(in: 1..<9)
    let firstDigit = Int.random(in: 1..<9)
    let app = XCUIApplication()

    app.typeText("60975795\(firstDigit)\(secondDigit)")
    sleep(1)
    snapshot("inputMobileNumber")
    app.buttons["GO"].tap()
    sleep(4)
    
    let textField = app.textFields.element
    snapshot("inputVerificationCode")
    textField.tap()
    sleep(1)
    textField.typeText("336699")
    
    sleep(2)
    snapshot("userform")
    let firstNameTextField = app.textFields["First Name"]
    firstNameTextField.tap()
    firstNameTextField.typeText("Alex")
    
    let lastNameOptionalTextField = app.textFields["Last Name - Optional"]
    lastNameOptionalTextField.tap()
    lastNameOptionalTextField.typeText("Semina")
    
    app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
    app.buttons["Save"].tap()
    sleep(4)

    app.navigationBars["Hangouts"].buttons["plus.circle"].tap()
    sleep(2)
    snapshot("createEvent")
    sleep(1)
    app.navigationBars["Create Event"].buttons["Hangouts"].tap()
    snapshot("events")
    sleep(2)

    app.buttons["Chat"].tap()
    app.navigationBars["Chats"].buttons["plus.circle"].tap()
    app.navigationBars["Contacts"].buttons["Chats"].tap()
    sleep(2)
    snapshot("chat")

    app.buttons["Profile"].tap()
    snapshot("profile")

  }

}
