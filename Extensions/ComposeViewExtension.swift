//
//  ComposeViewExtension.swift
//  Tell
//
//  Created by Lloyd Dapaah on 7/15/18.
//  Copyright © 2018 Lloyd Dapaah. All rights reserved.
//

import UIKit

extension ComposeView {
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

        if self.view.frame.size.height == self.originalScreenHeight {
            UIView.animate(withDuration: animationDuration - 0.05, delay: 0, options: animationOptions, animations: {
                self.view.frame.size.height = self.view.frame.size.height - keyboardSize.height
            }, completion: nil)
            
            if self.textBubbleTableView.contentSize.height > self.textBubbleTableView.frame.size.height {
                let offset: CGPoint = CGPoint(x: 0, y: self.textBubbleTableView.contentSize.height - self.textBubbleTableView.frame.size.height)
                self.textBubbleTableView.setContentOffset(offset, animated: true)
            }
        }
    }
    
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        self.view.frame.size.height = originalScreenHeight
        UIView.animate(withDuration: 0.1) {
            self.view.frame.size.height = self.originalScreenHeight
        }
    }
}
