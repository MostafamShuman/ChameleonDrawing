//
//  ViewController.swift
//  Chameleon Drawing
//
//  Created by Mostafa Shuman on 9/21/18.
//  Copyright © 2018 Mostafa Shuman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // work Space where u can Drawing 🎨
    @IBOutlet weak var sketchSpace: UIImageView?
    // toolButton where u can select ur tool brush or eraser (✏️ or 🚿)
    @IBOutlet weak var toolButton: UIButton!
    // tool is Current tool that u use (✏️ or 🚿)
    var tool: UIImageView!
    // For fetching Image From Gallery
    var imagePicker = UIImagePickerController()
    var viewModel: SketchViewModel!
    // to track log of changes history 🐕
    var imageHistory: [UIImage?] = []
    var index = -1
    var undoCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SketchViewModel()
        imagePicker.delegate = self
        imageHistory.append(sketchSpace?.image)
        tool = UIImageView()
        tool.frame = CGRect(x: self.view.bounds.size.width, y:  self.view.bounds.size.height, width: 35, height: 35)
        tool.image = #imageLiteral(resourceName: "pen")
        self.view.addSubview(tool)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // if you select earser 🚿 and change setting of tools ⚙️ this lines to avoid this changes 😅
        if !viewModel.isDrawing {
            viewModel.alpha = 1
            viewModel.setColors(red: 1, green: 1, blue: 1)
        }
    }
    
    ////// handling touch events 👆🏼
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewModel.swiped = false
        if let touch = touches.first {
            viewModel.lastPoint = touch.location(in: self.view)
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewModel.swiped = true
        if let touch = touches.first {
            let current = touch.location(in: self.view)
            drawLines(fromPoint: viewModel.lastPoint, toPoint: current)
            viewModel.lastPoint = current
        }
    }
    func drawLines(fromPoint: CGPoint, toPoint: CGPoint) {
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        sketchSpace?.image?.draw(in: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        let context = UIGraphicsGetCurrentContext()
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        tool.center = toPoint
        context?.setBlendMode(.normal)
        context?.setLineCap(.round)
        context?.setLineWidth(viewModel.brushSize)
        context?.setStrokeColor(red: viewModel.red, green: viewModel.green, blue: viewModel.blue, alpha: viewModel.alpha)
        context?.strokePath()
        sketchSpace?.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // if u end ur drawing event, app save this changes in imageHistory and increment index
        self.imageHistory.append(sketchSpace?.image)
        index = imageHistory.count - 1
        if !viewModel.swiped {
            drawLines(fromPoint: viewModel.lastPoint, toPoint: viewModel.lastPoint)
        }
    }
    
    // MARK: Actions
    @IBAction func setColor(_ sender: UIButton) {
        viewModel.selectedColor(with: sender.tag)
        if sender.tag == 8 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "settingsView") as! SettingsViewController
            vc.viewModel = viewModel
            present(vc, animated: true, completion: nil)
        }
        
    }
    // where u can delete the lines without earsing photo
    @IBAction func reset(_ sender: UIButton) {
        self.sketchSpace?.image = nil
        self.sketchSpace?.image = viewModel.selectedImage
    }
    // where u can save ur changes in gallery
    @IBAction func saveImage(_ sender: UIButton) {
        if let image = sketchSpace?.image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
    // this act as bruser with white color
    @IBAction func eraser(_ sender: UIButton) {
        if viewModel.isDrawing {
            viewModel.setColors(red: 1, green: 1, blue: 1)
            tool.image = #imageLiteral(resourceName: "eraser")
            toolButton.setImage(#imageLiteral(resourceName: "pen"), for: .normal)
            viewModel.isDrawing = false
        } else {
            viewModel.setColors(red: 0, green: 0, blue: 0)
            tool.image = #imageLiteral(resourceName: "pen")
            toolButton.setImage(#imageLiteral(resourceName: "eraser"), for: .normal)
            viewModel.isDrawing = true
        }
    }
    // to clear all changes
    @IBAction func clearAll(_ sender: UIButton) {
        self.sketchSpace?.image = nil
        viewModel.selectedImage = nil
        imageHistory = []
        imageHistory.append(sketchSpace?.image)
    }
    // to undo and redo changes
    @IBAction func undoRedo(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            if imageHistory.count > 0 && index >= 1 {
                sketchSpace?.image = imageHistory[index - 1]
                imageHistory.append(sketchSpace?.image)
                index -= 1
                undoCount += 1
            }
        default:
            if index > -1 && index < imageHistory.count && imageHistory.count > 0 {
                if undoCount > 0 {
                    imageHistory.removeLast()
                    sketchSpace?.image = imageHistory[imageHistory.count - 1]
                    undoCount -= 1
                }
            }
        }
    }
}


