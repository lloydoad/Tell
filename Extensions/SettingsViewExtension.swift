//
//  SettingsViewExtension.swift
//  Tell
//
//  Created by Lloyd Dapaah on 7/13/18.
//  Copyright © 2018 Lloyd Dapaah. All rights reserved.
//

import UIKit

extension SettingsView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func getImageFromUser(sender: Any?, presentingView: UIImagePickerControllerDelegate & UINavigationControllerDelegate & UIViewController) {
        let imageDelegate = UIImagePickerController()
        imageDelegate.delegate = presentingView
        imageDelegate.allowsEditing = true
        let alertVC = UIAlertController(title: "Select Image", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Access Camera", style: .default) { (action) in
                imageDelegate.sourceType = .camera
                presentingView.present(imageDelegate, animated: true, completion: nil)
            }
            alertVC.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pictureLibraryAction = UIAlertAction(title: "Picture Library", style: .default) { (action) in
                imageDelegate.sourceType = .photoLibrary
                presentingView.present(imageDelegate, animated: true, completion: nil)
            }
            
            alertVC.addAction(pictureLibraryAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(cancelAction)
        
        if let sender = sender {
            alertVC.popoverPresentationController?.sourceView = sender as! UIButton
        }
        presentingView.present(alertVC, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selected = info[UIImagePickerControllerEditedImage] as? UIImage {
            profTopCell.profileImageBtn.setBackgroundImage(selected, for: .normal)
            profTopCell.profileImageBtn.imageView?.contentMode = .scaleAspectFill
            profTopCell.profileImageBtn.contentHorizontalAlignment = .center
            profTopCell.profileImageBtn.contentVerticalAlignment = .center
            dismiss(animated: true, completion: nil)
        }
    }
}
