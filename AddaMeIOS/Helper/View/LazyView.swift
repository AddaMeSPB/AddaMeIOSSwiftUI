//
//  LazyView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 24.10.2020.
//

import SwiftUI

struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
