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
    private var placeholder: Placeholder?
    private var configulation: (Image) -> Image
    
    init(
        avatarLink: String? = nil,
        placeholder: Placeholder? = nil,
        cache: ImageCache? = nil,
        configuration: @escaping (Image) -> Image = { $0 }
    ) {
        var imageURL = URL(string: "")
        let rendomInt = Int.random(in: 0...1)
        if avatarLink == nil {
            if let fileURL = AssetExtractor.createLocalUrl(forImageNamed: "Avatar\(rendomInt)") {
                imageURL = fileURL
            }
        } else {
            imageURL = URL(string: avatarLink!)!
        }

        loder = ImageLoader(url: imageURL!, cache: cache)
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
