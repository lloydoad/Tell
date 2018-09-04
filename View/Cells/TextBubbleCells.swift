//
//  TextBubbleCells.swift
//  Tell
//
//  Created by Lloyd Dapaah on 7/15/18.
//  Copyright © 2018 Lloyd Dapaah. All rights reserved.
//

import UIKit

class ContactTextCell: UITableViewCell {
    static var selfIdentifier = "ContactTextCell"
    var customtextLabel: InsetLabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        customtextLabel = InsetLabel()
        customtextLabel.text = ""
        customtextLabel.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        customtextLabel.backgroundColor = UIColor(red: 127/255, green: 146/255, blue: 175/255, alpha: 1)
        customtextLabel.numberOfLines = 0
        customtextLabel.layer.cornerRadius = 11
        customtextLabel.clipsToBounds = true
        
        contentView.addSubview(customtextLabel)
        customtextLabel.translatesAutoresizingMaskIntoConstraints = false
        customtextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 13).isActive = true
        customtextLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3).isActive = true
        customtextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3).isActive = true
        customtextLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 300).isActive = true
        customtextLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
    }
}

class UserTextCell: UITableViewCell {
    static var selfIdentifier = "UserTextCell"
    var customtextLabel: InsetLabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        customtextLabel = InsetLabel()
        customtextLabel.text = ""
        customtextLabel.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        customtextLabel.backgroundColor = UIColor(red: 147/255, green: 159/255, blue: 201/255, alpha: 1)
        customtextLabel.numberOfLines = 0
        customtextLabel.layer.cornerRadius = 11
        customtextLabel.clipsToBounds = true
        
        contentView.addSubview(customtextLabel)
        customtextLabel.translatesAutoresizingMaskIntoConstraints = false
        customtextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -13).isActive = true
        customtextLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3).isActive = true
        customtextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3).isActive = true
        customtextLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 300).isActive = true
        customtextLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
    }
}

class InsetLabel: UILabel {
    let topInset = CGFloat(5)
    let bottomInset = CGFloat(5)
    let leftInset = CGFloat(7)
    let rightInset = CGFloat(7)
    
    override func drawText(in rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override public var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
}
