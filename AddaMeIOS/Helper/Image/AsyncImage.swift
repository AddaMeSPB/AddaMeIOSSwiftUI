//
//  AsyncImage.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 31.08.2020.
//

import SwiftUI
import Combine

struct AsyncImage<Placeholder: View>: View {
  
  @StateObject private var loader: ImageLoader
  private var placeholder: Placeholder
  private var image: (UIImage) -> Image
  
  init(
    url: URL,
    @ViewBuilder placeholder: () -> Placeholder,
    @ViewBuilder image: @escaping (UIImage) -> Image = Image.init(uiImage:)
  ) {
    self.placeholder = placeholder()
    self.image = image
    _loader = StateObject(wrappedValue: ImageLoader(url: url, cache: Environment(\.imageCache).wrappedValue))
  }
  
  init(
    urlString: String?,
    @ViewBuilder placeholder: () -> Placeholder,
    @ViewBuilder image: @escaping (UIImage) -> Image = Image.init(uiImage:)
  ) {
    
    var url = URL(string: String.empty)
    if urlString == nil {
      if let fileURL = AssetExtractor.createLocalUrl(forImageNamed: "Avatar") {
        url = fileURL
      }
    } else {
      url = URL(string: urlString!)!
    }
    
    self.placeholder = placeholder()
    self.image = image
    _loader = StateObject(
      wrappedValue: ImageLoader(
        url: url!,
        cache: Environment(\.imageCache).wrappedValue
      )
    )
  }
  
  var body: some View {
    content
      .onAppear(perform: loader.load)
  }
  
  private var content: some View {
    Group {
      if loader.image != nil {
        image(loader.image!)
      } else {
        placeholder
      }
    }
  }
  
}
