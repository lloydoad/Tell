//
//  PrivacyCell.swift
//  Tell
//
//  Created by Lloyd Dapaah on 7/13/18.
//  Copyright © 2018 Lloyd Dapaah. All rights reserved.
//

import UIKit

class PrivacyDescriptionCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        let margins = contentView.layoutMarginsGuide
        
        let description = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        description.text = "Messages from blocked users are automatically deleted. Blocked users are not notified"
        description.numberOfLines = 2
        description.font = UIFont(name: description.font.fontName, size: 14)
        description.textColor = UIColor.darkGray
        
        contentView.addSubview(description)
        description.translatesAutoresizingMaskIntoConstraints = false
        description.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 15).isActive = true
        description.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -15).isActive = true
        description.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        description.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
}
