//
//  ImageDraw.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 22.11.2020.
//

import Foundation
import UIKit

class ImageDraw {
  private let renderer = UIGraphicsImageRenderer(size: CGSize(width: 400, height: 400))
  private var colors = [UIColor.red, UIColor.brown, UIColor.yellow, UIColor.green, UIColor.black, UIColor.blue]
  
  func random() -> UIImage {
    colors.shuffle()
    let image = renderer.image { (context) in
      UIColor.darkGray.setStroke()
      context.stroke(renderer.format.bounds)
      
      
      
      let count = 400 / colors.count
      
      colors.enumerated().forEach { (idx, color) in
        color.setFill()
        context.fill(CGRect(x: idx * count, y: 0, width: idx * count, height: 400))
      }
    }
    
    return image
  }
  
}
