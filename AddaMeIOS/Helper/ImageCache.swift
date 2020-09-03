//
//  ImageCache.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 31.08.2020.
//

import SwiftUI

protocol ImageCache {
    subscript(_ url: URL) -> UIImage? { get set }
}

struct TemporaryImageCache: ImageCache {
    
    private let cache = NSCache<NSURL, UIImage>()
    
    subscript(key: URL) -> UIImage? {
        get { cache.object(forKey: key as NSURL) }
        set {
            newValue == nil ? cache.removeObject(forKey: key as NSURL) : cache.setObject(newValue!, forKey: key as NSURL)
        }
    }
}
