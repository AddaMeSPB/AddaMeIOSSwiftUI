//
//  ContentView.swift
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

struct ContentView: View {

    @State private var phoneNumber = String()
    @State private var isValidPhoneNumber = Bool()

    let phoneNumberKit = PhoneNumberKit()
    @State private var phoneField: PhoneNumberTextFieldView?
    @ObservedObject var viewModel = AuthViewModel()
    
    var body: some View {

        VStack {
            Text("Adda")
                .font(Font.system(size: 56, weight: .heavy, design: .rounded))
                .foregroundColor(.red)
                .padding(.top, 120)

            if ((self.viewModel.lAndVRes?.attemptId) == nil) {
                Text("Register Or Login")
                    .font(Font.system(size: 33, weight: .heavy, design: .rounded))
                    .foregroundColor(.blue)
                    .padding()
            }

            if ((self.viewModel.lAndVRes?.attemptId) != nil) {
                Text("Verification Code")
                    .font(Font.system(size: 33, weight: .heavy, design: .rounded))
                    .foregroundColor(.blue)
                    .padding(.top, 10)
            }

            ZStack {

                if ((self.viewModel.lAndVRes?.attemptId) == nil) {
                    HStack {
                        phoneField.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 60)
                            .keyboardType(.phonePad)
                            .padding(.leading)

                        Button(action: {
                            print(self.$isValidPhoneNumber)
                            do {
                                self.phoneField?.getCurrentText()
                                let parseNumber = try phoneNumberKit.parse(phoneNumber)
                                _ = phoneNumberKit.format(parseNumber, toType: .e164)

                                viewModel.lAndVRes = LoginAndVerificationResponse(phoneNumber: phoneNumber)
                                viewModel.login()
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

                if ((self.viewModel.lAndVRes?.attemptId) != nil) {
                    VStack {
                        HStack {
                            TextField(
                                "__ __ __ __",
                                text: self.$viewModel.verificationCodeResponse
                            )
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

            }
            .padding(.top, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            .padding(.bottom, 20)
            .padding(.leading, 10)
            .padding(.trailing, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)

            Spacer()
        }

    }
}

extension ContentView {
    private func action() {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
