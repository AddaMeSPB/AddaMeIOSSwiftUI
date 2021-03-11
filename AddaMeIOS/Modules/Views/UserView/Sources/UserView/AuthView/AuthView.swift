//
//  AuthView.swift
//  AddaMeIOS
//
//  Created by Alif on 11/7/20.
//

import SwiftUI
import Combine
import SwiftUIExtension
import AuthClient
import PhoneNumberKit
import InfoPlist

public struct PhoneNumberTextFieldView: UIViewRepresentable {
  public func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  @Binding var phoneNumber: String
  @Binding var isValid: Bool
  
  let phoneTextField = PhoneNumberTextField()
  
  public func makeUIView(context: Context) -> PhoneNumberTextField {
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
  
  public func updateUIView(_ view: PhoneNumberTextField, context: Context) {}
  
  public class Coordinator: NSObject, UITextFieldDelegate {
    
    var control: PhoneNumberTextFieldView
    
    init(_ control: PhoneNumberTextFieldView) {
      self.control = control
    }
    
    @objc func onTextUpdate(textField: UITextField) {
      control.isValid = self.control.phoneTextField.isValidNumber
    }
    
  }
}

public struct AuthView: View {
  
  @State private var phoneField: PhoneNumberTextFieldView?
  @ObservedObject private var avm: AuthViewModel
  @ObservedObject private var uvm: UserViewModel
  
  private var baseURL: URL { EnvironmentKeys.rootURL }
  
  public init(authViewModel: AuthViewModel, userViewModel: UserViewModel) {
    self.avm = authViewModel
    self.uvm = userViewModel
  }
  
//  @EnvironmentObject var appState: AppState
  
  @ViewBuilder fileprivate func inputMobileNumberTextView() -> some View {
    HStack {
      phoneField.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 60)
        .keyboardType(.phonePad)
        .padding(.leading)
      
      Button(action: {
        self.avm.goButtonTapped(phoneField)
      }, label: {
        Text("GO")
          .font(.headline)
          .bold()
          .padding()
      })
      .disabled(!self.avm.isValidPhoneNumber)
      .foregroundColor(.red)
      .background(
        self.avm.isValidPhoneNumber ? Color.yellow : Color.gray
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
      self.phoneField = PhoneNumberTextFieldView(
        phoneNumber: self.$avm.phoneNumber,
        isValid: self.$avm.isValidPhoneNumber
      )
    }
  }
  
  fileprivate func inputValidationCodeTextView() -> some View {
    return VStack {
      HStack {
        TextField(
          "__ __ __ __ __ __",
          text: self.$avm.verificationResponse
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
          self.avm.showingTermsSheet = true
        }, label: {
          Text("Terms")
            .font(.title3)
            .bold()
            .foregroundColor(.blue)
        })
        .sheet(isPresented: self.$avm.showingTermsSheet) {
          TermsAndPrivacyWebView(urlString: baseURL.appendingPathComponent("/terms").absoluteString )
        }
        
        Text("&")
          .font(.title3)
          .bold()
          .padding([.leading, .trailing], 10)
        
        Button(action: {
          avm.showingPrivacySheet = true
        }, label: {
          Text("Privacy")
            .font(.title3)
            .bold()
            .foregroundColor(.blue)
        })
        .sheet(isPresented: self.$avm.showingPrivacySheet) {
          TermsAndPrivacyWebView(urlString: baseURL.appendingPathComponent("/privacy").absoluteString )
        }
      }
    }
  }
  
  public var body: some View {
    ZStack {
      
      if avm.isAuthorized {
        EditProfileView(uvm: uvm)
      } else {
        
        if avm.isRegisterRequestInFlight {
          withAnimation {
            HUDProgressView(placeHolder: "Loading...", show: $avm.isRegisterRequestInFlight)
          }
        }
        
        if avm.inputWrongVarificationCode {
          withAnimation {
            HUDProgressView(placeHolder: "Wrong code please try again!", show: $avm.isRegisterRequestInFlight)
          }
        }
        
        VStack {
          
          Text("Adda")
            .font(Font.system(size: 56, weight: .heavy, design: .rounded))
            .foregroundColor(.red)
            .padding(.top, 120)
          
          if self.avm.isAttemptIdIsNil {
            Text("Register Or Login")
              .font(Font.system(size: 33, weight: .heavy, design: .rounded))
              .foregroundColor(.blue)
              .padding()
          }
          
          if !self.avm.isAttemptIdIsNil {
            Text("Verification Code")
              .font(Font.system(size: 33, weight: .heavy, design: .rounded))
              .foregroundColor(.blue)
              .padding(.top, 10)
          }
          
          ZStack {
            
            if self.avm.isAttemptIdIsNil {
              inputMobileNumberTextView()
            }
            
            if !self.avm.isAttemptIdIsNil {
              inputValidationCodeTextView()
            }
            
          }
          .padding(.top, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
          .padding(.bottom, 20)
          .padding(.leading, 10)
          .padding(.trailing, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
          
          if self.avm.isAttemptIdIsNil {
            termsAndPrivacyView()
          }
          
          Spacer()
        }
      }
    }
    .onTapGesture {
      avm.inputWrongVarificationCode = false
      avm.isRegisterRequestInFlight = false
    }
    .alert(item: self.$avm.errorAlert) { errorAlert in
      Alert(title: Text(errorAlert.title))
    }
  }
    
}

struct AuthView_Previews: PreviewProvider {
  static var previews: some View {
    let avm = AuthViewModel(authClient: .happyPath)
    let uvm = UserViewModel(
      eventClient: .happyPath,
      userClient: .happyPath,
      attachmentClient: .happyPath
    )

    AuthView(authViewModel: avm, userViewModel: uvm)
  }

}
