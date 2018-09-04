//
//  ComposeView.swift
//  Tell
//
//  Created by Lloyd Dapaah on 7/13/18.
//  Copyright © 2018 Lloyd Dapaah. All rights reserved.
//

import UIKit

class ComposeView: UIViewController, UITextViewDelegate {
    var textEntryBox: UITextView!
    var textBubbleTableView: UITableView!
    var bottomContainer: UIView!
    var originalScreenHeight = UIScreen.main.bounds.height
    var sendButton: UIButton!
    var viewIsSetup: Bool = false
    
    var popUpUserNameLabel: UILabel!
    var popUpUserNameHandle: UILabel!
    var popUpUserImage: UIImageView!
    let popUpHeight: CGFloat = 238
    let popUpWidth: CGFloat = 229
    var blurredPopUp: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .light)
        let cont = UIVisualEffectView(effect: effect)
        cont.frame = UIScreen.main.bounds
        return cont
    }()
    
    var usernameLabel: UILabel?
    var handleLabel: UILabel?
    var profileImage: UIImageView?
    var userImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = BASE_BACKGROUND_COLOR
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]

        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
        
        if !viewIsSetup {
            setupView()
            textViewDidChange(textEntryBox)
            let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
            swipeDown.direction = .down
            view.addGestureRecognizer(swipeDown)
            
            let container = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
            container.backgroundColor = .white
            
            view.addSubview(container)
            container.translatesAutoresizingMaskIntoConstraints = false
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            container.topAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            container.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            view.addSubview(blurredPopUp)
            blurredPopUp.isHidden = true
            let popUpTapReg = UITapGestureRecognizer(target: self, action: #selector(blurredViewTapped(tapper:)))
            blurredPopUp.addGestureRecognizer(popUpTapReg)
            
            let popUpContainer = UIView()
            popUpContainer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.75)
            popUpContainer.frame = CGRect(x: 0, y: 0, width: 209, height: 248)
            popUpContainer.layer.cornerRadius = 5
            popUpContainer.clipsToBounds = true
            
            popUpContainer.translatesAutoresizingMaskIntoConstraints = false
            popUpContainer.heightAnchor.constraint(equalToConstant: popUpHeight).isActive = true
            popUpContainer.widthAnchor.constraint(equalToConstant: popUpWidth).isActive = true
            blurredPopUp.contentView.addSubview(popUpContainer)
            popUpContainer.centerYAnchor.constraint(equalTo: blurredPopUp.centerYAnchor).isActive = true
            popUpContainer.centerXAnchor.constraint(equalTo: blurredPopUp.centerXAnchor).isActive = true
            
            popUpUserImage = UIImageView()
            popUpUserImage.image = #imageLiteral(resourceName: "default_profile")
            popUpUserImage.translatesAutoresizingMaskIntoConstraints = false
            popUpUserImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
            popUpUserImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
            popUpUserImage.layer.cornerRadius = 40
            popUpUserImage.clipsToBounds = true
            popUpContainer.addSubview(popUpUserImage)
            popUpUserImage.centerXAnchor.constraint(equalTo: popUpContainer.centerXAnchor).isActive = true
            popUpUserImage.topAnchor.constraint(equalTo: popUpContainer.topAnchor, constant: 7).isActive = true
            
            popUpUserNameLabel = UILabel()
            popUpUserNameLabel.text = "first middle last"
            popUpUserNameLabel.textAlignment = .center
            popUpUserNameLabel.font = UIFont.systemFont(ofSize: 16)
            popUpUserNameLabel.adjustsFontForContentSizeCategory = false
            
            popUpUserNameHandle = UILabel()
            popUpUserNameHandle.text = "user handle"
            popUpUserNameHandle.textAlignment = .center
            popUpUserNameHandle.font = UIFont.systemFont(ofSize: 16)
            popUpUserNameHandle.adjustsFontForContentSizeCategory = false
            
            let reportUserButton = UIButton(type: .system)
            reportUserButton.setTitle("Report User", for: .normal)
            reportUserButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            reportUserButton.titleLabel?.adjustsFontForContentSizeCategory = false
            reportUserButton.addTarget(self, action: #selector(handleReportUser), for: .touchUpInside)
            
            let blockUserButton = UIButton(type: .system)
            blockUserButton.setTitle("Block User", for: .normal)
            blockUserButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            blockUserButton.titleLabel?.adjustsFontForContentSizeCategory = false
            blockUserButton.addTarget(self, action: #selector(handleBlockUser), for: .touchUpInside)
            
            let stackContainer = UIStackView(arrangedSubviews: [popUpUserNameLabel, popUpUserNameHandle, reportUserButton, blockUserButton])
            stackContainer.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
            stackContainer.axis = .vertical
            stackContainer.distribution = .fillEqually
            stackContainer.spacing = 5
            stackContainer.alignment = .fill
            
            popUpContainer.addSubview(stackContainer)
            stackContainer.translatesAutoresizingMaskIntoConstraints = false
            stackContainer.topAnchor.constraint(equalTo: popUpUserImage.bottomAnchor, constant: 7).isActive = true
            stackContainer.bottomAnchor.constraint(equalTo: popUpContainer.bottomAnchor, constant: -7).isActive = true
            stackContainer.leadingAnchor.constraint(equalTo: popUpContainer.leadingAnchor, constant: 20).isActive = true
            stackContainer.trailingAnchor.constraint(equalTo: popUpContainer.trailingAnchor, constant: -20).isActive = true
            
            viewIsSetup = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
        resignFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        var newHeight: CGFloat!

        if estimatedSize.height >= 285 {
            newHeight = 285
            textView.isScrollEnabled = true
        } else {
            newHeight = estimatedSize.height
            textView.isScrollEnabled = false
        }

        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = newHeight
            }
        }
        bottomContainer.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = newHeight + 15
            }
        }
    }
    
    func setupNavigationBar() {
        userImageButton = UIButton(type: .system)
        userImageButton.setBackgroundImage(#imageLiteral(resourceName: "default_profile"), for: .normal)
        userImageButton.layer.cornerRadius = 20
        userImageButton.clipsToBounds = true
        userImageButton.addTarget(self, action: #selector(handleContactDetailsTapped), for: .touchUpInside)
        
        userImageButton.translatesAutoresizingMaskIntoConstraints = false
        userImageButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userImageButton.widthAnchor.constraint(equalToConstant: 40).isActive = true

        let customButtomItem = UIBarButtonItem(customView: userImageButton)
        navigationItem.rightBarButtonItem = customButtomItem
        
        let customLeft = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(handleDismiss))
        customLeft.tintColor = .white
        navigationItem.leftBarButtonItem = customLeft
    }
    
    func setupView() {
        bottomContainer = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        view.addSubview(bottomContainer)
        
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        bottomContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        textEntryBox = UITextView(frame: CGRect(x: 0, y: 0, width: 100, height: 55))
        textEntryBox.isScrollEnabled = false
        textEntryBox.backgroundColor = UIColor(red: 232/255, green: 236/255, blue: 238/255, alpha: 1)
        textEntryBox.layer.cornerRadius = 6
        textEntryBox.clipsToBounds = true
        textEntryBox.font = UIFont.systemFont(ofSize: 16)
        textEntryBox.text = ""
        textEntryBox.delegate = self
        textEntryBox.isScrollEnabled = false
        
        bottomContainer.addSubview(textEntryBox)
        textEntryBox.translatesAutoresizingMaskIntoConstraints = false
        textEntryBox.widthAnchor.constraint(equalToConstant: 310).isActive = true
        textEntryBox.heightAnchor.constraint(equalToConstant: 30).isActive = true
        textEntryBox.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor, constant: 6).isActive = true
        textEntryBox.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor).isActive = true
        
        sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        sendButton.titleLabel?.textColor = BASE_BACKGROUND_COLOR_DARK
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        bottomContainer.addSubview(sendButton)
        sendButton.widthAnchor.constraint(lessThanOrEqualToConstant: 50).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor, constant: -7).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: bottomContainer.bottomAnchor, constant: -7.5).isActive = true
        sendButton.addTarget(nil, action: #selector(self.handleMessageSent), for: .touchUpInside)
        
        textBubbleTableView = UITableView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), style: .plain)
        view.addSubview(textBubbleTableView)
        textBubbleTableView.translatesAutoresizingMaskIntoConstraints = false
        textBubbleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        textBubbleTableView.bottomAnchor.constraint(equalTo: bottomContainer.topAnchor).isActive = true
        textBubbleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        textBubbleTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        textBubbleTableView.setContentHuggingPriority(UILayoutPriority(rawValue: 200), for: .vertical)
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func blurredViewTapped(tapper: UITapGestureRecognizer) {
        let location = tapper.location(in: view)
        let minX = (view.frame.width/2) - (popUpWidth/2)
        let maxX = (view.frame.width/2) + (popUpWidth/2)
        let minY = (view.frame.height/2) - (popUpHeight/2)
        let maxY = (view.frame.height/2) + (popUpHeight/2)
        
        if location.x < minX || location.x > maxX || location.y < minY || location.y > maxY {
            handleHidePopUp()
        }
    }
    
    @objc func handleMessageSent() {}
    @objc func handleContactDetailsTapped() {}
    @objc func handleHidePopUp() {}
    @objc func handleReportUser() {}
    @objc func handleBlockUser() {}
    
}
