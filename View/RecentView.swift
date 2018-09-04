//
//  RecentView.swift
//  Tell
//
//  Created by Lloyd Dapaah on 7/11/18.
//  Copyright © 2018 Lloyd Dapaah. All rights reserved.
//

import UIKit

class RecentView: UITableViewController {
    lazy var rootPageView = self.parent as! RootPageView
    var contact: [String] = ["test 1", "test 2", "test 3", "test 4"]
    var isTableSetup: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recent"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        rootPageView.navigationItem.title = "Recent"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !isTableSetup {
            tableView.estimatedRowHeight = 110
            tableView.separatorStyle = .none
            
            tableView.register(ContactCell.self, forCellReuseIdentifier: "contactCell")
            isTableSetup = true
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contact.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        segueToCompose()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        
        return cell
    }
    
    func segueToCompose() { }
}
