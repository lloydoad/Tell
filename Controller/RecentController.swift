//
//  RecentController.swift
//  Tell
//
//  Created by Lloyd Dapaah on 7/11/18.
//  Copyright © 2018 Lloyd Dapaah. All rights reserved.
//

import UIKit

class RecentController: RecentView {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func segueToCompose() {
        let VC = ComposeController()
        VC.navigationItem.title = "SelectedUser"
        present(UINavigationController(rootViewController: VC), animated: true, completion: nil)
    }

}
