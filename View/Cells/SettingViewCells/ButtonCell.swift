//
//  ButtonCell.swift
//  Tell
//
//  Created by Lloyd Dapaah on 7/13/18.
//  Copyright © 2018 Lloyd Dapaah. All rights reserved.
//

import UIKit

class AboutButtonCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        let margin = contentView.layoutMarginsGuide
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        titleLabel.text = "About"
        titleLabel.textColor = BASE_BACKGROUND_COLOR
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: margin.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: margin.leadingAnchor, constant: 15).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true

    }
}

class ShareButtonCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        let margin = contentView.layoutMarginsGuide
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        titleLabel.text = "Tell A Friend"
        titleLabel.textColor = BASE_BACKGROUND_COLOR
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: margin.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: margin.leadingAnchor, constant: 15).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
}

class BlockedButtonCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        let margin = contentView.layoutMarginsGuide
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        titleLabel.text = "Blocked Users"
        titleLabel.textColor = BASE_BACKGROUND_COLOR
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: margin.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: margin.leadingAnchor, constant: 15).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
}
