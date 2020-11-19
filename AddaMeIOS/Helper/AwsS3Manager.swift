//
//  AwsS3Manager.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 18.11.2020.
//

import UIKit
import S3
import NIO

class AWSS3Helper {
  
  static var bucketWithEndpoint = "https://adda.nyc3.digitaloceanspaces.com/"
  
  static var getCurrentMillis: Int64 {
    return Int64(Date().timeIntervalSince1970 * 1000)
  }
  
  static func uploadImage(
    _ image: UIImage,
    conversationId: String? = nil,
    userId: String? = nil,
    completion: @escaping (String?) -> ()) {
    
    guard let currentUSER : CurrentUser = KeychainService.loadCodable(for: .currentUser) else {
      print(#line, "Missing current user from KeychainService")
      return
    }
    
    let s3 = S3.init(
      accessKeyId: EnvironmentKeys.accessKeyId,
      secretAccessKey: EnvironmentKeys.secretAccessKey,
      region: .useast1, endpoint: "https://nyc3.digitaloceanspaces.com"
    )
    
    guard let imageData = image.compressImage(conversationId == nil ? .highest : .medium) else {
      completion(nil)
      return
    }
    
    let currentTime = AWSS3Helper.getCurrentMillis
    var imageKey = String(format: "%ld", currentTime)
    if conversationId != nil {
      imageKey = "uploads/images/\(conversationId!)/\(imageKey).jpeg"
    } else if userId != nil {
      imageKey = "uploads/images/\(userId!)/\(imageKey).jpeg"
    } else {
      imageKey = "uploads/images/\(currentUSER.id)_\(imageKey).jpeg"
    }
    
    // Put an Object
    let putObjectRequest = S3.PutObjectRequest(
      acl: .publicRead,
      body: imageData,
      bucket: "adda",
      contentLength: Int64(imageData.count),
      key: imageKey
    )
    
    let futureOutput = s3.putObject(putObjectRequest)
    
    futureOutput.whenSuccess({ (response) in
      print(#line, self, response, imageKey)
      let finalURL = bucketWithEndpoint + imageKey
      completion(finalURL)
    })
    
    futureOutput.whenFailure({ (error) in
      print(#line, self, error)
      completion(nil)
    })
    
  }
  
}
