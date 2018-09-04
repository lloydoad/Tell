//
//  SettingsControllerExtension.swift
//  Tell
//
//  Created by Lloyd Dapaah on 7/13/18.
//  Copyright © 2018 Lloyd Dapaah. All rights reserved.
//

import UIKit
import MessageUI

extension SettingController: MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    func shareToFriends() {
        let alertVC = UIAlertController(title: "Share", message: nil, preferredStyle: .actionSheet)
        
        if MFMailComposeViewController.canSendMail() {
            let composeMailVC = MFMailComposeViewController()
            composeMailVC.mailComposeDelegate = self
            composeMailVC.delegate = self
            
            composeMailVC.setSubject("Client Request: 03134")
            composeMailVC.setMessageBody("Hello, I have an issue with ...", isHTML: false)
            
            let sendMailAction = UIAlertAction(title: "Share via mail", style: .default) { (action) in
                self.present(composeMailVC, animated: true, completion: nil)
            }
            alertVC.addAction(sendMailAction)
        }
        
        if MFMessageComposeViewController.canSendText() {
            let composeTextVC = MFMessageComposeViewController()
            composeTextVC.delegate = self
            composeTextVC.messageComposeDelegate = self
            
            composeTextVC.body = "Testing 1343 texting capabilities"
            
            let sendTextAction = UIAlertAction(title: "Share via text", style: .default) { (action) in
                self.present(composeTextVC, animated: true, completion: nil)
            }
            alertVC.addAction(sendTextAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(cancelAction)
        
        present(alertVC, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
