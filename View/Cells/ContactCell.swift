//
//  ContactCell.swift
//  Tell
//
//  Created by Lloyd Dapaah on 7/13/18.
//  Copyright © 2018 Lloyd Dapaah. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    var profileImageView: UIImageView!
    var usernameLabel: UILabel!
    var handleLabel: UILabel!
    var lastTextLabel: UILabel!
    var dateLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        let margins = contentView.layoutMarginsGuide
        
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 90))
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = CONTACT_CELL_BGD
        contentView.addSubview(container)
        container.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 3).isActive = true
        container.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -3).isActive = true
        container.topAnchor.constraint(equalTo: margins.topAnchor, constant: 4).isActive = true
        container.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -3).isActive = true
        container.layer.cornerRadius = 14
        container.clipsToBounds = true
        container.layer.borderWidth = 0.7
        container.layer.borderColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 0.3).cgColor
        
        let outContainer = UIStackView(frame: CGRect(x: 0, y: 0, width: 200, height: 80))
        outContainer.alignment = .fill
        outContainer.axis = .vertical
        outContainer.distribution = .fillProportionally
        outContainer.spacing = 5
        outContainer.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(outContainer)
        outContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15).isActive = true
        outContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15).isActive = true
        outContainer.topAnchor.constraint(equalTo: container.topAnchor, constant: 5).isActive = true
        outContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -5).isActive = true
        
        let topContainer = UIStackView(frame: CGRect(x: 0, y: 0, width: 200, height: 52))
        topContainer.translatesAutoresizingMaskIntoConstraints = false
        topContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        topContainer.axis = .horizontal
        topContainer.alignment = .center
        topContainer.distribution = .fill
        topContainer.spacing = 5
        
        profileImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 52, height: 52))
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = .gray
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.image = #imageLiteral(resourceName: "default_profile")
        
        dateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 17))
        dateLabel.text = "hh/mm/dd..."
        dateLabel.textColor = UIColor.darkGray
        dateLabel.font = UIFont(name: dateLabel.font.fontName, size: 11)
        dateLabel.textAlignment = .right
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 80).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 17).isActive = true
        
        usernameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        usernameLabel.text = "Username..."
        usernameLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        handleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        handleLabel.text = "Handle..."
        handleLabel.textColor = UIColor.lightGray
        handleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        let identityContainer = UIStackView(frame: CGRect(x: 0, y: 0, width: 70, height: 20))
        identityContainer.alignment = .fill
        identityContainer.axis = .vertical
        identityContainer.distribution = .fillEqually
        identityContainer.addArrangedSubview(usernameLabel)
        identityContainer.addArrangedSubview(handleLabel)
        
        topContainer.addArrangedSubview(profileImageView)
        topContainer.addArrangedSubview(identityContainer)
        topContainer.addArrangedSubview(dateLabel)
        
        lastTextLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        lastTextLabel.text = "last text sent label"
        
        outContainer.addArrangedSubview(topContainer)
        outContainer.addArrangedSubview(lastTextLabel)
    }
    
    
}
