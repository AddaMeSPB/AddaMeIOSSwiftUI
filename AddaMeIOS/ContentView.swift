//
//  ContentView.swift
//  AddaMeIOS
//
//  Created by Alif on 11/7/20.
//

import SwiftUI
import PhoneNumberKit

struct PhoneNumberTextFieldView: UIViewRepresentable {

    @Binding var phoneNumber: String

    let textField = PhoneNumberTextField()

    func makeUIView(context: Context) -> PhoneNumberTextField {
        textField.withExamplePlaceholder = true
        textField.withFlag = true
        textField.withPrefix = true
        textField.withExamplePlaceholder = true
        //textField.placeholder = "Enter phone number"
        textField.becomeFirstResponder()

        return textField
    }

    func getCurrentText() {
        self.phoneNumber = textField.text!
    }


    func updateUIView(_ view: PhoneNumberTextField, context: Context) {}
}

struct ContentView: View {

    @State private var phoneNumber = String()

    let phoneNumberKit = PhoneNumberKit()
    @State private var phoneField: PhoneNumberTextFieldView?

    @State private var showVerification = false
    @State private var codeTextField: String = ""

    @ObservedObject var viewModel = AuthViewModel()
    
    var body: some View {

        VStack {
            Text("Adda")
                .font(.largeTitle).bold()
                .foregroundColor(.red)
                .padding(.top, 120)

            if !showVerification {
                Text("Register Or Login")
                    .font(.largeTitle).bold()
                    .foregroundColor(.blue)
                    .padding()
            }

            if showVerification {
                Text("Verification Code")
                    .font(.largeTitle).bold()
                    .foregroundColor(.blue)
                    .padding(.top, 10)
            }

            ZStack {

                if !showVerification {
                    HStack {
                        phoneField.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 60)
                            .keyboardType(.phonePad)
                            .padding(.leading)

                        Button(action: {
                            do {
                                self.phoneField?.getCurrentText()
                                print(phoneNumber)
                                let parseNumber = try phoneNumberKit.parse("+\(phoneNumber)")
                                let pNumber = phoneNumberKit.format(parseNumber, toType: .e164)

                                viewModel.lAndVRes = LoginAndVerificationResponse(phoneNumber: phoneNumber)
                                print("Validated Number: \(pNumber)")
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
                        .foregroundColor(.red)
                        .background(Color.yellow)
                        .cornerRadius(60)
                    }
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.black.opacity(0.2), lineWidth: 0.6)
                            .foregroundColor(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.06563035103)))
                        //.shadow(color: Color.black, radius: 5, x: 3,y: 3)
                    )
                    .onAppear {
                        self.phoneField = PhoneNumberTextFieldView(phoneNumber: self.$phoneNumber)
                        //
                    }
                }

                if showVerification {
                    VStack {
                        HStack {
                            TextField("__ __ __ __", text: $codeTextField)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
