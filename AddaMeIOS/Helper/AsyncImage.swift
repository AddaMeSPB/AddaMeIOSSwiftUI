//
//  AsyncImage.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 31.08.2020.
//

import SwiftUI
import Combine

struct AsyncImage<Placeholder: View>: View {
    
    @ObservedObject private var loder: ImageLoader
    private let placeholder: Placeholder?
    private let configulation: (Image) -> Image
    
    init(
        url: URL,
        placeholder: Placeholder? = nil,
        cache: ImageCache? = nil,
        configuration: @escaping (Image) -> Image = { $0 }
    ) {
        loder = ImageLoader(url: url, cache: cache)
        self.placeholder = placeholder
        self.configulation = configuration
    }
    
    var body: some View {
        image
            .onAppear(perform: loder.load)
            .onDisappear(perform: loder.cancel)
    }
    
    private var image: some View {
        Group {
            if loder.image != nil {
                configulation(Image(uiImage: loder.image!))
            } else {
                placeholder
            }
        }
    }
}
