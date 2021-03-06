//
//  AuthView.swift
//  AddaMeIOS
//
//  Created by Alif on 11/7/20.
//

import SwiftUI
import PhoneNumberKit

struct PhoneNumberTextFieldView: UIViewRepresentable {
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  @Binding var phoneNumber: String
  @Binding var isValid: Bool
  
  let phoneTextField = PhoneNumberTextField()
  
  func makeUIView(context: Context) -> PhoneNumberTextField {
    phoneTextField.withExamplePlaceholder = true
    phoneTextField.withFlag = true
    phoneTextField.withPrefix = true
    phoneTextField.withExamplePlaceholder = true
    //phoneTextField.placeholder = "Enter phone number"
    phoneTextField.becomeFirstResponder()
    phoneTextField.addTarget(context.coordinator, action: #selector(Coordinator.onTextUpdate), for: .editingChanged)
    return phoneTextField
  }
  
  func getCurrentText() {
    self.phoneNumber = phoneTextField.text!
  }
  
  func updateUIView(_ view: PhoneNumberTextField, context: Context) {}
  
  class Coordinator: NSObject, UITextFieldDelegate {
    
    var control: PhoneNumberTextFieldView
    
    init(_ control: PhoneNumberTextFieldView) {
      self.control = control
    }
    
    @objc func onTextUpdate(textField: UITextField) {
      control.isValid = self.control.phoneTextField.isValidNumber
    }
    
  }
}

struct AuthView: View {
  
  let phoneNumberKit = PhoneNumberKit()
  
  @State private var phoneNumber: String = String.empty
  @State private var isValidPhoneNumber: Bool = false
  
  @State private var showingTermsSheet = false
  @State private var showingPrivacySheet = false
  
  @State private var phoneField: PhoneNumberTextFieldView?
  @EnvironmentObject var viewModel: AuthViewModel
  
  @EnvironmentObject var appState: AppState
  
  @AppStorage(AppUserDefaults.Key.isAuthorized.rawValue) var isAuthorized: Bool = false
  
  @ViewBuilder fileprivate func inputMobileView() -> some View {
    HStack {
      phoneField.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 60)
        .keyboardType(.phonePad)
        .padding(.leading)
      
      Button(action: {
        print(self.$isValidPhoneNumber)
        do {
          self.phoneField?.getCurrentText()
          let parseNumber = try self.phoneNumberKit.parse(self.phoneNumber)
          _ = self.phoneNumberKit.format(parseNumber, toType: .e164)
          
          self.viewModel.lAndVRes = LoginAndVerificationResponse(phoneNumber: self.phoneNumber)
          self.viewModel.login()
        } catch {
          print("Error validating phone number")
        }
      }, label: {
        Text("GO")
          .font(.headline)
          .bold()
          .padding()
      })
      .disabled(!isValidPhoneNumber)
      .foregroundColor(.red)
      .background(
        isValidPhoneNumber ? Color.yellow : Color.gray
      )
      .cornerRadius(60)
    }
    .cornerRadius(25)
    .overlay(
      RoundedRectangle(cornerRadius: 25)
        .stroke(Color.black.opacity(0.2), lineWidth: 0.6)
        .foregroundColor(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.06563035103)))
    )
    .onAppear {
      self.phoneField = PhoneNumberTextFieldView(phoneNumber: self.$phoneNumber, isValid: self.$isValidPhoneNumber)
    }
  }
  
  fileprivate func inputValidationCodeView() -> some View {
    return VStack {
      HStack {
        TextField(
          "__ __ __ __ __ __",
          text: self.$viewModel.verificationCodeResponse
        )
        .font(.largeTitle)
        .multilineTextAlignment(.center)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 60)
        .keyboardType(.phonePad)
        .padding(.leading)
        
      }.cornerRadius(25)
      .overlay(
        RoundedRectangle(cornerRadius: 25)
          .stroke(Color.black.opacity(0.2), lineWidth: 0.6)
          .foregroundColor(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.06563035103)))
      )
    }
  }
  
  fileprivate func termsAndPrivacyView() -> some View {
    VStack {
      Text("Check our terms and privacy")
        .font(.footnote)
        .bold()
        .foregroundColor(.blue)
        .padding()
      
      HStack {
        Button(action: {
          showingTermsSheet = true
        }, label: {
          Text("Terms")
            .font(.title3)
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
            .font(.title3)
            .bold()
            .foregroundColor(.blue)
        })
        .sheet(isPresented: $showingPrivacySheet) {
          TermsAndPrivacyWebView(urlString: EnvironmentKeys.rootURL.absoluteString + "/privacy")
        }
      }
    }
  }
  
  var body: some View {
    ZStack {
      
      if isAuthorized {
        AuthProfileView()
      } else {
        
        if viewModel.isLoadingPage {
          withAnimation {
            HUDProgressView(placeHolder: "Loading...", show: $viewModel.isLoadingPage)
          }
        }
        
        if viewModel.inputWrongVarificationCode {
          withAnimation {
            HUDProgressView(placeHolder: "Wrong code please try again!", show: $viewModel.isLoadingPage)
          }
        }
        
        VStack {
          
          Text("Adda")
            .font(Font.system(size: 56, weight: .heavy, design: .rounded))
            .foregroundColor(.red)
            .padding(.top, 120)
          
          if isAttemptIdIsNil {
            Text("Register Or Login")
              .font(Font.system(size: 33, weight: .heavy, design: .rounded))
              .foregroundColor(.blue)
              .padding()
          }
          
          if !isAttemptIdIsNil {
            Text("Verification Code")
              .font(Font.system(size: 33, weight: .heavy, design: .rounded))
              .foregroundColor(.blue)
              .padding(.top, 10)
          }
          
          ZStack {
            
            if isAttemptIdIsNil {
              inputMobileView()
            }
            
            if !isAttemptIdIsNil {
              inputValidationCodeView()
            }
            
          }
          .padding(.top, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
          .padding(.bottom, 20)
          .padding(.leading, 10)
          .padding(.trailing, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
          
          
          if isAttemptIdIsNil {
            termsAndPrivacyView()
          }
          
          Spacer()
        }
      }
    }
    .onTapGesture {
      viewModel.inputWrongVarificationCode = false
    }
    
  }
  
  var isAttemptIdIsNil: Bool {
    return viewModel.lAndVRes.attemptId == nil
  }
  
  
}

struct AuthView_Previews: PreviewProvider {
  static var previews: some View {
    AuthView()
      .environmentObject(AuthViewModel())
  }

}
