//
//  KeyboardDismissModifier.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 07.09.2020.
//

import SwiftUI

@available(iOS 13, *)
public struct KeyboardDismissModifier: ViewModifier {
    
    public func body(content: Content) -> some View {
        content.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

@available(iOS 13, *)
extension TextField {
    /// Dismiss the keyboard when pressing on something different then a form field
    /// - Returns: KeyboardDismissModifier
    public func hideKeyboardOnTap() -> ModifiedContent<Self, KeyboardDismissModifier> {
        return modifier(KeyboardDismissModifier())
    }
}
