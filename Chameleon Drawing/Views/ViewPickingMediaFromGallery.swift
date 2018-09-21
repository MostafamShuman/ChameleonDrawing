//
//  ViewPickingMediaFromGallery.swift
//  Chameleon Drawing
//
//  Created by Mostafa Shuman on 9/21/18.
//  Copyright © 2018 Mostafa Shuman. All rights reserved.
//

import UIKit

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBAction func insertPhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        viewModel.didFinishPickingMedia(with: info)
        if let image = viewModel.selectedImage {
            sketchSpace?.image = image
        }
        dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
