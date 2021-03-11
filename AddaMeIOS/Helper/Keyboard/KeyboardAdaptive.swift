////
////  KeyboardAdaptive.swift
////  AddaMeIOS
////
////  Created by Saroar Khandoker on 13.09.2020.
////
//
//import Combine
//import SwiftUI
//
//struct KeyboardAdaptive: ViewModifier {
//    @State private var bottomPadding: CGFloat = 0
//    
//    func body(content: Content) -> some View {
//        GeometryReader { geometry in
//            content
//                .padding(.bottom, self.bottomPadding)
//                .onReceive(Publishers.keyboardHeight) { keyboardHeight in
//                    let keyboardTop = geometry.frame(in: .global).height - keyboardHeight
//                    let focusedTextInputBottom = UIResponder.currentFirstResponder?.globalFrame?.maxY ?? 0
//                    
//                    self.bottomPadding = max(0, focusedTextInputBottom - keyboardTop - geometry.safeAreaInsets.bottom)
//                }
//                .animation(.easeOut(duration: 0.16))
//        }
//    }
//}
//
//extension View {
//    func keyboardAdaptive() -> some View {
//        ModifiedContent(content: self, modifier: KeyboardAdaptive())
//    }
//}
