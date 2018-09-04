//
//  TranslationsCell.swift
//  Tell
//
//  Created by Lloyd Dapaah on 7/13/18.
//  Copyright © 2018 Lloyd Dapaah. All rights reserved.
//

import UIKit

class translationTopCell: UITableViewCell {
    var userLanguageLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        let margins = contentView.layoutMarginsGuide
        
        let width: CGFloat = 160
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 90, height: 40))
        title.text = "Language"
        title.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(title)
        title.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        title.widthAnchor.constraint(equalToConstant: 90).isActive = true
        title.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 15).isActive = true
        
        userLanguageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 40))
        userLanguageLabel.text = "Updating.."
        userLanguageLabel.textAlignment = .right
        userLanguageLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(userLanguageLabel)
        userLanguageLabel.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        userLanguageLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        userLanguageLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -15).isActive = true
    }
}

protocol transBottomCellDelegate {
    func selected(language: String)
}

class translationBottomCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    var languages: [String] = ["English", "Spanish", "French", "Russian", "Swahili", "Zulu"]
    var languagePickerView: UIPickerView!
    var delegate: transBottomCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        let margins = contentView.layoutMarginsGuide
        
        languagePickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 100, height: 0))
        languagePickerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(languagePickerView)
        languagePickerView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        languagePickerView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        languagePickerView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        let cons = languagePickerView.bottomAnchor.constraint(lessThanOrEqualTo: margins.bottomAnchor)
        cons.priority = UILayoutPriority(rawValue: 999)
        cons.isActive = true

        languagePickerView.dataSource = self
        languagePickerView.delegate = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if delegate != nil {
            delegate?.selected(language: languages[row])
        }
    }
    
    
}


