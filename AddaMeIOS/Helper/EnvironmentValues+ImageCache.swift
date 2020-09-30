//
//  EnvironmentValues+ImageCache.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 31.08.2020.
//

import SwiftUI

struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCache = TemporaryImageCache()
}

extension EnvironmentValues {
    var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}

//struct MsgDatasKey: EnvironmentKey {
//    static let defaultValue: MsgDatas = MsgDatas()
//}
//
//extension EnvironmentValues {
//    var msgDatas: MsgDatas {
//        get { self[MsgDatasKey.self] }
//        set { self[MsgDatasKey.self] = newValue }
//    }
//}

 //@Environment(\.imageCache) var cache: ImageCache
