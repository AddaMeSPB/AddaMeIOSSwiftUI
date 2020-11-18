//
//  AwsS3Manager.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 18.11.2020.
//

import UIKit
import S3
import NIO

//class AwsS3Manager: NSObject {
//  
//  static let sharedInstance = AwsS3Manager()
//  
//  var getCurrentMillis: Int64 {
//    return Int64(Date().timeIntervalSince1970 * 1000)
//  }
//  
//  func uploadImage(image: UIImage, completion: @escaping (String?) -> Void) {
//    
//    
//    // let newImage = image.resizeWithWidth(width: 512)
//    let cgSize = CGSize(width: 512, height: 512)
//    let newImage = image.RBResizeImage(targetSize: cgSize)
//    let data: Data = newImage.pngData()!
//    
//    let expression =  AWSS3TransferUtilityUploadExpression()
//    expression.setValue("public-read", forRequestHeader: "x-amz-acl")
//    expression.progressBlock = {(task, progress) in
//      DispatchQueue.main.async(execute: {
//        // Do something e.g. Update a progress bar.
//        print("upload in process \(progress)")
//      })
//    }
//    
//    var s3ImageUrl = String.empty
//    var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
//    completionHandler = { (task, error) -> Void in
//      guard error == nil else {
//        completion(nil)
//        return
//      }
//      
//      DispatchQueue.main.async(execute: {
//        // Do something e.g. Alert a user for transfer completion.
//        // On failed uploads, `error` contains the error object.
//        print("upload completed2 \(String(describing: task.response))")
//        
//        print("upload url \(String(describing: task.response?.url?.path))")
//        s3ImageUrl = "https://\(task.bucket).nyc3.digitaloceanspaces.com/\(task.key)"
//        print("s2ImageUrl", s3ImageUrl)
//        completion(s3ImageUrl)
//      })
//    }
//    
//    let transferUtility = AWSS3TransferUtility.default()
//    let currentTime = getCurrentMillis()
//    var imageKey = String(format: "%ld", currentTime)
//    imageKey = "uploads/images/\(PerfectLocalAuth.userID)_\(imageKey).jpg"
//    
//    transferUtility.uploadData(
//      data,
//      bucket: "adda",
//      key: imageKey,
//      contentType: "image/jpeg",
//      expression: expression,
//      completionHandler: completionHandler
//    ).continueWith { (task) -> AnyObject? in
//      if let error = task.error {
//        print("Error: \(error.localizedDescription)")
//      }
//      
//      if task.result != nil {
//        // Do something with uploadTask.
//        print("something upload completed \(String(describing: task.result.debugDescription))")
//      }
//      
//      return nil
//    }
//  }
//  
//}

//extension UIImage {
//  
//  func RBResizeImage(targetSize: CGSize) -> UIImage {
//    let size = self.size
//    
//    let widthRatio  = targetSize.width  / self.size.width
//    let heightRatio = targetSize.height / self.size.height
//    
//    // Figure out what our orientation is, and use that to form the rectangle
//    var newSize: CGSize
//    if widthRatio > heightRatio {
//      newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio) //CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
//    } else {
//      newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
//    }
//    
//    // This is the rect that we've calculated out and this is what is actually used below
//    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height) //CGRectMake(0, 0, newSize.width, newSize.height)
//    
//    // Actually do the resizing to the rect using the ImageContext stuff
//    UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
//    self.draw(in: rect)
//    let newImage = UIGraphicsGetImageFromCurrentImageContext()
//    UIGraphicsEndImageContext()
//    
//    return newImage!
//  }
//}

class AWSS3Helper {
  
  var getCurrentMillis: Int64 {
    return Int64(Date().timeIntervalSince1970 * 1000)
  }
  
  func uploadImage(
    _ image: UIImage, sender: UIViewController,
    _ conversationId: String?,
    completion: @escaping (String?) -> ()) {
    
    guard let currentUSER : CurrentUser = KeychainService.loadCodable(for: .currentUser) else {
      print(#line, "Missing current user from KeychainService")
      return
    }
    
    let s3 = S3.init(
      accessKeyId: "Q5VTF3ARNCQANQJSGIAB",
      secretAccessKey: "WdzHvZE3bNq8z/ylf3EzqA1trk4pyI2wuFrRYOCbj4w",
      region: .useast1, endpoint: "https://nyc3.digitaloceanspaces.com"
    )
    
    guard let imageData = image.jpegData(compressionQuality: 1) else {
      completion(nil)
      return
    }
    
    let uuid = UUID().uuidString
    let fileName = "\(uuid).jpeg"
    
    let currentTime = getCurrentMillis
    var imageKey = String(format: "%ld", currentTime)
    if conversationId == nil {
      imageKey = "uploads/images/\(currentUSER.id)_\(imageKey).jpg"
    } else {
      imageKey = "uploads/images/\(conversationId!)/\(currentUSER.id)_\(imageKey).jpg"
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
      print(#line, self, response)
      completion(fileName)
    })
    
    futureOutput.whenFailure({ (error) in
      print(#line, self, error)
      completion(nil)
    })
    
  }
  
}
