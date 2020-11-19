//
//  Image+Compress.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 19.11.2020.
//

import UIKit
import AVFoundation

extension UIImage {
  enum JPEGQuality: CGFloat {
      case lowest  = 0
      case low     = 0.25
      case medium  = 0.5
      case high    = 0.75
      case highest = 1
  }
  
  func compressImage(_ compressionQuality: JPEGQuality? = .medium) -> Data? {
    var imageData = Data()
    do {
      let data = try self.heicData(compressionQuality: compressionQuality!)
      
      imageData =  data
    } catch {
      print("Error creating HEIC data: \(error.localizedDescription)")
      return nil
    }
    
    return imageData
  }
  
}

extension UIImage {
  enum HEICError: Error {
    case heicNotSupported
    case cgImageMissing
    case couldNotFinalize
  }
  
  func heicData(compressionQuality: JPEGQuality) throws -> Data {
    let data = NSMutableData()
    guard let imageDestination =
            CGImageDestinationCreateWithData(
              data, AVFileType.heic as CFString, 1, nil
            )
    else {
      throw HEICError.heicNotSupported
    }
    
    guard let cgImage = self.cgImage else {
      throw HEICError.cgImageMissing
    }
    
    let options: NSDictionary = [
      kCGImageDestinationLossyCompressionQuality: compressionQuality
    ]
    
    CGImageDestinationAddImage(imageDestination, cgImage, options)
    guard CGImageDestinationFinalize(imageDestination) else {
      throw HEICError.couldNotFinalize
    }
    
    return data as Data
  }
}

