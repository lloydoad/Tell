//
//  AccountViewExtension.swift
//  Tell
//
//  Created by Lloyd Dapaah on 7/11/18.
//  Copyright © 2018 Lloyd Dapaah. All rights reserved.
//

import UIKit

extension AccountView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            profilePictureBtn.setBackgroundImage(selected, for: .normal)
            profilePictureBtn.imageView?.contentMode = .scaleAspectFill
            profilePictureBtn.contentHorizontalAlignment = .center
            profilePictureBtn.contentVerticalAlignment = .center
            dismiss(animated: true) {
                self.isLogInPage = false
            }
        }
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector:
            #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:
            #selector(keyboardWillBeHidden(_:)), name: .UIKeyboardWillHide, object: nil)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let info = notification.userInfo,
            let keyboardFrameValue = info[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let animationCurve = info[UIKeyboardAnimationCurveUserInfoKey] as? UInt,
            let animationDuration = info[UIKeyboardAnimationDurationUserInfoKey] as? Double
            else { return }
        
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        let animationOptions = UIViewAnimationOptions(rawValue: animationCurve)
        
        if self.view.frame.origin.y == 0 {
            UIView.animate(withDuration: animationDuration - 0.05, delay: 0, options: animationOptions, animations: {
                self.view.frame.origin.y = self.view.frame.origin.y - keyboardSize.height + 145
            }, completion: nil)
        }
    }
    
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        self.view.frame.size.height = originalScreenHeight
        UIView.animate(withDuration: 0.1) {
            self.view.frame.origin.y = 0
        }
    }
}
