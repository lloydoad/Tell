//
//  SettingsView.swift
//  Tell
//
//  Created by Lloyd Dapaah on 7/11/18.
//  Copyright © 2018 Lloyd Dapaah. All rights reserved.
//

import UIKit

class SettingsView: UIViewController, UITableViewDelegate, UITableViewDataSource, transBottomCellDelegate, UITextFieldDelegate {
    lazy var rootPageView = self.parent as! RootPageView
    var mainTableView: UITableView!
    var cellRegistered: Bool = false
    
    // table view variables
    let sectionTitles: [String] = ["  Profile", "  Translations", "  Privacy", "  "]
    var heightForProfileEdit: CGFloat = 164
    var heightForTranslationPicker: CGFloat = 0
    var isProfileEditHidden: Bool = false {
        didSet {
            if isProfileEditHidden {
                heightForProfileEdit = 0
            } else {
                heightForProfileEdit = 164
            }
        }
    }
    var isPickerHidden: Bool = true {
        didSet {
            if isPickerHidden {
                heightForTranslationPicker = 0.6
            } else {
                heightForTranslationPicker = 164
            }
        }
    }
    
    var transBottomCell: translationBottomCell!
    var transTopCell: translationTopCell!
    var profTopCell: ProfileTopCell!
    var profBottomCell: ProfileBottomCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        rootPageView.navigationItem.title = "Settings"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !cellRegistered {
            
            let screenDim = UIScreen.main.bounds
            mainTableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenDim.width, height: screenDim.height), style: .grouped)
            mainTableView.delegate = self
            mainTableView.dataSource = self
            view.addSubview(mainTableView)
            mainTableView.translatesAutoresizingMaskIntoConstraints = false
            mainTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            mainTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            mainTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            mainTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            mainTableView.sectionHeaderHeight = 30
            mainTableView.sectionFooterHeight = 0
            registerCells();
            cellRegistered = true
        }
    }
    
    func registerCells() {
        mainTableView.register(ProfileTopCell.self, forCellReuseIdentifier: "profileTopCell")
        mainTableView.register(ProfileBottomCell.self, forCellReuseIdentifier: "profileBottomCell")
        mainTableView.register(translationTopCell.self, forCellReuseIdentifier: "transTopCell")
        mainTableView.register(translationBottomCell.self, forCellReuseIdentifier: "transBottomCell")
        mainTableView.register(PrivacyDescriptionCell.self, forCellReuseIdentifier: "privacyDescription")
        
        mainTableView.register(BlockedButtonCell.self, forCellReuseIdentifier: "blockedUsersCell")
        mainTableView.register(AboutButtonCell.self, forCellReuseIdentifier: "aboutCell")
        mainTableView.register(ShareButtonCell.self, forCellReuseIdentifier: "shareCell")
    }
    
    // headers and footers
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = FLAT_WHITE
        headerView.alpha = 0.97

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 20, height: 20))
        if section < sectionTitles.count { label.text = sectionTitles[section] }
        else { label.text = "   " }
        label.textColor = UIColor.black
        headerView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true

        return headerView
    }

    // Section control
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    // Row control
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            return 88
        case (0, 1):
            return heightForProfileEdit
        case (1, 1):
            return heightForTranslationPicker
        case (2, 0):
            return 60
        default:
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            isProfileEditHidden = !isProfileEditHidden
            let index = IndexPath(row: 1, section: 0)
            mainTableView.reloadRows(at: [index], with: .automatic)
            break
        case (1,0):
            isPickerHidden = !isPickerHidden
            let index = IndexPath(row: 1, section: 1)
            mainTableView.reloadRows(at: [index], with: .automatic)
            break
        case (2,1):
            handlePresentNewView(caller: "blockedUsers")
            break
        case (3,0):
            handlePresentNewView(caller: "about")
            break
        case (3,1):
            handlePresentNewView(caller: "share")
            break
        default:
            break
        }
        
        mainTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        switch (indexPath.section, indexPath.row){
        case (0,1), (1,1), (2, 0):
            return false
        default:
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        if indexPath.row == 0 && indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "profileTopCell", for: indexPath)
            profTopCell = cell as! ProfileTopCell
            profTopCell.profileImageBtn.addTarget(self, action: #selector(handleImageChange), for: .touchUpInside)
        } else if indexPath.row == 0 && indexPath.section == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "transTopCell", for: indexPath)
            transTopCell = cell as! translationTopCell
        } else if indexPath.row == 1 && indexPath.section == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "transBottomCell", for: indexPath)
            transBottomCell = cell as! translationBottomCell
            transBottomCell.delegate = self
        } else if indexPath.row == 0 && indexPath.section == 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: "privacyDescription", for: indexPath)
        } else if indexPath.row == 1 && indexPath.section == 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: "blockedUsersCell", for: indexPath)
        } else if indexPath.row == 0 && indexPath.section == 3 {
            cell = tableView.dequeueReusableCell(withIdentifier: "aboutCell", for: indexPath)
        } else if indexPath.row == 1 && indexPath.section == 3 {
            cell = tableView.dequeueReusableCell(withIdentifier: "shareCell", for: indexPath)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "profileBottomCell", for: indexPath)
            profBottomCell = cell as! ProfileBottomCell
            profBottomCell.firstNameTextField.delegate = self
            profBottomCell.lastNameTextField.delegate = self
            profBottomCell.handleTextField.delegate = self
        }
        
        return cell
    }
    
    // Cell Functions
    func selected(language: String) { }
    
    @objc func handleImageChange() { }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { return true }
    
    func handlePresentNewView(caller: String) {}
}
