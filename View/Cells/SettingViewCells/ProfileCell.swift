//
//  ProfileTopCell.swift
//  Tell
//
//  Created by Lloyd Dapaah on 7/12/18.
//  Copyright © 2018 Lloyd Dapaah. All rights reserved.
//

import UIKit


class ProfileTopCell: UITableViewCell{
    var profileImageBtn: UIButton!
    var handleLabel: UILabel!
    var usernameLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupContent() {
        let margin = contentView.layoutMarginsGuide
        profileImageBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        profileImageBtn.setBackgroundImage(#imageLiteral(resourceName: "default_profile"), for: .normal)
        profileImageBtn.layer.cornerRadius = profileImageBtn.frame.height/2
        profileImageBtn.clipsToBounds = true
        contentView.addSubview(profileImageBtn)
        
        profileImageBtn.translatesAutoresizingMaskIntoConstraints = false
        profileImageBtn.heightAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageBtn.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageBtn.centerYAnchor.constraint(equalTo: margin.centerYAnchor).isActive = true
        profileImageBtn.leadingAnchor.constraint(equalTo: margin.leadingAnchor, constant: 15).isActive = true
        
        let nameContainer = UIStackView(frame: CGRect(x: 0, y: 0, width: 200, height: 45))
        contentView.addSubview(nameContainer)
        nameContainer.translatesAutoresizingMaskIntoConstraints = false
        nameContainer.leadingAnchor.constraint(equalTo: profileImageBtn.trailingAnchor, constant: 15).isActive = true
        nameContainer.trailingAnchor.constraint(equalTo: margin.trailingAnchor, constant: -15).isActive = true
        nameContainer.heightAnchor.constraint(equalToConstant: 45).isActive = true
        nameContainer.centerYAnchor.constraint(equalTo: margin.centerYAnchor).isActive = true
        nameContainer.axis = .vertical
        nameContainer.alignment = .leading
        nameContainer.distribution = .fillEqually
        nameContainer.spacing = 3
        
        handleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 24))
        handleLabel.text = "handle"
        handleLabel.textColor = UIColor.darkGray
        handleLabel.font = UIFont(name: handleLabel.font.fontName, size: 15)
        
        usernameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 24))
        usernameLabel.text = "username"
        
        nameContainer.addArrangedSubview(usernameLabel)
        nameContainer.addArrangedSubview(handleLabel)
    }
}

class ProfileBottomCell: UITableViewCell {
    var firstNameTextField: UITextField!
    var lastNameTextField: UITextField!
    var handleTextField: UITextField!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupContent() {
        let margin = contentView.layoutMarginsGuide
        let textContainers = UIStackView(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        contentView.addSubview(textContainers)
        textContainers.backgroundColor = .red
        textContainers.translatesAutoresizingMaskIntoConstraints = false
        textContainers.centerYAnchor.constraint(equalTo: margin.centerYAnchor).isActive = true
        textContainers.leadingAnchor.constraint(equalTo: margin.leadingAnchor, constant: 15).isActive = true
        textContainers.trailingAnchor.constraint(equalTo: margin.trailingAnchor, constant: -15).isActive = true
        
        textContainers.axis = .vertical
        textContainers.alignment = .fill
        textContainers.distribution = .fillEqually
        textContainers.spacing = 21
        
        firstNameTextField = setupTextField(placeholder: "first name")
        firstNameTextField.tag = 0
        lastNameTextField = setupTextField(placeholder: "last name")
        lastNameTextField.tag = 1
        handleTextField = setupTextField(placeholder: "handle")
        handleTextField.tag = 2
        
        textContainers.addArrangedSubview(firstNameTextField)
        textContainers.addArrangedSubview(lastNameTextField)
        textContainers.addArrangedSubview(handleTextField)
    }
    
    func setupTextField(placeholder: String)-> UITextField {
        let temp = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        temp.placeholder = placeholder
        temp.textAlignment = .center
        temp.borderStyle = .roundedRect
        return temp
    }
    
    
}
