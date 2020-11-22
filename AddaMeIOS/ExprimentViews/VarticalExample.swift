////
////  VarticalExample.swift
////  AddaMeIOS
////
////  Created by Saroar Khandoker on 26.10.2020.
////

import SwiftUI
import MapKit
import UIKit



struct MapViewWithAnnotations: View {
  let colors: [UIColor] = [UIColor.red, UIColor.white, UIColor.yellow, UIColor.gray, UIColor.green, UIColor.black, UIColor.blue, UIColor.magenta, UIColor.red, UIColor.white, UIColor.yellow, UIColor.gray, UIColor.green, UIColor.black, UIColor.blue, UIColor.magenta]
  var rendomImage: MoodView = MoodView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
  //let image = UIImage.gradientImageWithBounds(bounds: CGRect(x: 0, y: 0, width: 400, height: 400), colors: [UIColor.red, UIColor.white, UIColor.yellow, UIColor.gray, UIColor.green, UIColor.black, UIColor.blue, UIColor.magenta, UIColor.red, UIColor.white, UIColor.yellow, UIColor.gray, UIColor.green, UIColor.black, UIColor.blue, UIColor.magenta])
  
    var body: some View {
      VStack {
//        Image(systemName: "person")
//        Spacer()[;.omjn
        Text("Hello")
          .padding([.bottom], 55)
      }.onAppear {
        rendomImage.colors = colors
      }
    }
}

struct MapViewWithAnnotations_Previews: PreviewProvider {
    static var previews: some View {
        MapViewWithAnnotations()
            //.environment(\.colorScheme, .dark)
    }
}

extension UIImage {
    static func gradientImageWithBounds(bounds: CGRect, colors: [UIColor]) -> UIImage {
      
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
//        gradientLayer.colors = colors
        
      guard let ctx = UIGraphicsGetCurrentContext() else { fatalError("must have graphics context") }
     
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: ctx)

      drawShape(colors, shapes: Rectangle(size: gradientLayer.bounds.size).divide(), context: ctx)
      
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension UIImage {
    func imageWithColor(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color.setFill()
      

        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)

        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}


//extension UIView {
//
//    // Using a function since `var image` might conflict with an existing variable
//    // (like on `UIImageView`)
//    func asImage() -> UIImage {
//        let renderer = UIGraphicsImageRenderer(bounds: bounds)
//        return renderer.image { rendererContext in
//            layer.render(in: rendererContext.cgContext)
//        }
//    }
//}


extension UIView {

    func asImage() -> UIImage? {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
            defer { UIGraphicsEndImageContext() }
            guard let currentContext = UIGraphicsGetCurrentContext() else {
                return nil
            }
            self.layer.render(in: currentContext)
            return UIGraphicsGetImageFromCurrentImageContext()
        }
    }
}

class MoodView: UIView {

    var colors: [UIColor] = [] {
        didSet { setNeedsDisplay() }
    }

    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { fatalError("must have graphics context") }
        drawShape(colors, shapes: Rectangle(size: bounds.size).divide(), context: ctx)
    }

}


// MARK: - Private

private func drawShape(_ colors: [UIColor], shapes: (DivisableShape, DivisableShape), context: CGContext) {
    if let (head, tail) = colors.decomposed {
        context.setFillColor(head.cgColor)
        let path = shapes.0.path
        if tail.count == 0 {
            path.append(shapes.1.path)
        }
        context.addPath(path.cgPath)
        context.fillPath()
        drawShape(tail, shapes: shapes.1.divide(), context: context)
    }
}


private protocol DivisableShape {

    var path: UIBezierPath { get }
    func divide() -> (DivisableShape, DivisableShape)

}

private struct Rectangle: DivisableShape {

    var point1: CGPoint
    var point2: CGPoint
    var point3: CGPoint
    var point4: CGPoint

    var path: UIBezierPath {
        return UIBezierPath(points: [point1, point2, point3, point4])
    }

    init(size: CGSize) {
        point1 = CGPoint.zero
        point2 = CGPoint(x: size.width, y: 0)
        point3 = CGPoint(x: size.width, y: size.height)
        point4 = CGPoint(x: 0, y: size.height)
    }

    func divide() -> (DivisableShape, DivisableShape) {
        return (Triangle(point1: point1, point2: point2, point3: point3), Triangle(point1: point3, point2: point4, point3: point1))
    }

}

private struct Triangle: DivisableShape {

    var point1: CGPoint
    var point2: CGPoint
    var point3: CGPoint

    var path: UIBezierPath {
        return UIBezierPath(points: [point1, point2, point3])
    }

    func divide() -> (DivisableShape, DivisableShape) {
        let midPoint = CGPoint(x: (point1.x + point3.x) / 2, y: (point1.y + point3.y) / 2)
        return (Triangle(point1: point2, point2: midPoint, point3: point1), Triangle(point1: point3, point2: midPoint, point3: point2))
    }

}


extension UIBezierPath {
    fileprivate convenience init(points: [CGPoint]) {
        self.init()
        if points.count > 0 {
            move(to: points[0])
            for p in points[1..<points.count] {
                addLine(to: p)
            }
            close()
        }
    }
}

extension Array {
    var decomposed: (Iterator.Element, [Iterator.Element])? {
        guard let x = first else { return nil }
        return (x, Array(self[1..<count]))
    }

    func sliced(size: Int) -> [[Iterator.Element]] {
        var result: [[Iterator.Element]] = []
        for idx in stride(from: startIndex, to: endIndex, by: size) {
            let end = Swift.min(idx + size, endIndex)
            result.append(Array(self[idx..<end]))
        }
        return result
    }
}
