//
//  SketchViewModel.swift
//  Chameleon Drawing
//
//  Created by Mostafa Shuman on 9/21/18.
//  Copyright © 2018 Mostafa Shuman. All rights reserved.
//

import UIKit


class SketchViewModel {
    var swiped: Bool = false
    var brushSize: CGFloat = 5.0
    // Colors Properties
    var red: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var green: CGFloat = 0.0
    var alpha: CGFloat = 1.0
    // Tool State Brush or Eraser
    var isDrawing: Bool = true
    // Selected Image From your Gallery
    var selectedImage: UIImage!
    //
    var lastPoint: CGPoint =  CGPoint.zero
    func setColors(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.red = red
        self.green = green
        self.blue = blue
    }
    
    func selectedColor(with tag: Int) {
        if isDrawing {
            switch tag {
            case 0:
                setColors(red: 1, green: 0, blue: 0)
            case 1:
                setColors(red: 0, green: 1, blue: 0)
            case 2:
                setColors(red: 0, green: 0, blue: 1)
            case 3:
                setColors(red: 1, green: 0, blue: 1)
            case 4:
                setColors(red: 1, green: 1, blue: 0)
            case 5:
                setColors(red: 0, green: 1, blue: 1)
            case 6:
                setColors(red: 0, green: 0, blue: 0)
            case 7:
                setColors(red: 1, green: 1, blue: 1)
            default :
                setColors(red: red, green: green, blue: blue)
            }
        }
    }
    
    func didFinishPickingMedia(with info: [String: Any]) {
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = possibleImage
        } else {
            return
        }
    }
    
    
}
