//
//  SettingsViewController.swift
//  Chameleon Drawing
//
//  Created by Mostafa Shuman on 9/21/18.
//  Copyright © 2018 Mostafa Shuman. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    // MARK:- Outltes
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet weak var brushSizeSlider: UISlider!
    @IBOutlet weak var opacitySlider: UISlider!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    
    // properties
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    
    var viewModel: SketchViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        brushSizeSlider.value = Float(viewModel?.brushSize ?? 0)
        opacitySlider.value = Float(viewModel?.alpha ?? 0)
        
        redSlider.value = Float(viewModel?.red ?? 0)
        greenSlider.value = Float(viewModel?.green ?? 0)
        blueSlider.value = Float(viewModel?.blue ?? 0)
        changePreviewColor(red: viewModel?.red ?? 0, green: viewModel?.green ?? 0, blue: viewModel?.blue ?? 0)
    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeColor(_ sender: UISlider) {
        switch sender.tag {
        case 0:
            red = CGFloat(sender.value)
            changePreviewColor(red: red, green: green, blue: blue)
        case 1:
            green = CGFloat(sender.value)
            changePreviewColor(red: red, green: green, blue: blue)
        default:
            blue = CGFloat(sender.value)
            changePreviewColor(red: red, green: green, blue: blue)
        }
    }
    @IBAction func changeBrushSize(_ sender: UISlider) {
        viewModel?.brushSize = CGFloat(sender.value)
        changePreviewColor(red: red, green: green, blue: blue)
    }
    @IBAction func changeOpacity(_ sender: UISlider) {
        viewModel?.alpha = CGFloat(sender.value)
        changePreviewColor(red: red, green: green, blue: blue)
    }
    
    private func changePreviewColor(red: CGFloat, green: CGFloat, blue: CGFloat) {
//        imageView.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
        UIGraphicsBeginImageContext(imageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(red: (viewModel?.red)!, green: (viewModel?.green)!, blue: (viewModel?.blue)!, alpha: (viewModel?.alpha)!)
        context?.setLineWidth(viewModel?.brushSize ?? 0)
        context?.setLineCap(.round)
        context?.move(to: CGPoint(x: 50, y: 50))
        context?.addLine(to: CGPoint(x: 50, y: 50))
        context?.strokePath()
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        viewModel?.setColors(red: red, green: green, blue: blue)
    }

}
