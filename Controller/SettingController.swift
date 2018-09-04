//
//  SettingController.swift
//  Tell
//
//  Created by Lloyd Dapaah on 7/11/18.
//  Copyright © 2018 Lloyd Dapaah. All rights reserved.
//

import UIKit

class SettingController: SettingsView {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(textField.text ?? "nothing")
        
        textField.resignFirstResponder()
        //update online info
        return true
    }
    
    override func selected(language: String) {
        transTopCell.userLanguageLabel.text = language
    }

    override func handleImageChange() {
        getImageFromUser(sender: profTopCell.profileImageBtn, presentingView: self)
    }
    
    override func handlePresentNewView(caller: String) {
        switch caller {
        case "about":
            print("showing safari with link")
            break
        case "share":
            shareToFriends()
            break
        case "blockedUsers":
            print("showing blocked users view")
            break
        default:
            break
        }
    }

}
