//
//  ContactPopUpController.swift
//  Tell
//
//  Created by Lloyd Dapaah on 7/16/18.
//  Copyright © 2018 Lloyd Dapaah. All rights reserved.
//

import UIKit

extension ComposeController {
    func showContactDetails() {
        blurredPopUp.isHidden = false
        blurredPopUp.alpha = 0
        
        UIView.animate(withDuration: 0.2) {
            self.blurredPopUp.alpha = 1
        }
    }
    
    func hideContactDetails() {
        blurredPopUp.alpha = 1
        
        UIView.animate(withDuration: 0.2, animations: {
            self.blurredPopUp.alpha = 0
        }) { (_) in
            self.blurredPopUp.isHidden = true
        }
    }
    
    
}
