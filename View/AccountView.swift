//
//  AccountView.swift
//  Tell
//
//  Created by Lloyd Dapaah on 7/11/18.
//  Copyright © 2018 Lloyd Dapaah. All rights reserved.
//

import UIKit
import PopupDialog

class AccountView: UIViewController, UITextFieldDelegate{
    var handle: UITextField!
    var firstName: UITextField!
    var lastName: UITextField!
    var email: UITextField!
    var password: UITextField!
    
    var logInRegisterBtn: UIButton!
    var toggleScreenBtn: UIButton!
    var profilePictureBtn: UIButton!
    
    var bounds: [UIView] = []
    
    var originalScreenHeight = UIScreen.main.bounds.height
    var isLogInPage: Bool! {
        didSet {
            if isLogInPage {
                handle.isHidden = true
                firstName.isHidden = true
                lastName.isHidden = true
                for i in 0...2 { self.bounds[i].isHidden = true }
                profilePictureBtn.isHidden = true
                logInRegisterBtn.setTitle("Log in", for: .normal)
                toggleScreenBtn.setTitle("Don't have an account? Create one", for: .normal)
            } else {
                handle.isHidden = false
                firstName.isHidden = false
                lastName.isHidden = false
                profilePictureBtn.isHidden = false
                for i in 0...2 { bounds[i].isHidden = false }
                logInRegisterBtn.setTitle("Register", for: .normal)
                toggleScreenBtn.setTitle("Have an account? Log in", for: .normal)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BASE_BACKGROUND_COLOR
        
        setupComponents()
        let mainContainer = UIStackView(arrangedSubviews: [profilePictureBtn])
        view.addSubview(mainContainer)
        
        mainContainer.translatesAutoresizingMaskIntoConstraints = false
        mainContainer.alignment = .center
        mainContainer.distribution = .fill
        mainContainer.axis = .vertical
        mainContainer.spacing = 30
        mainContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        mainContainer.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        let textFieldContainer = UIStackView(arrangedSubviews: [handle, bounds[0], firstName, bounds[1], lastName, bounds[2], email, bounds[3], password, bounds[4]])
        mainContainer.addArrangedSubview(textFieldContainer)
        textFieldContainer.alignment = .center
        textFieldContainer.distribution = .fill
        textFieldContainer.axis = .vertical
        textFieldContainer.spacing = 2
        
        mainContainer.addArrangedSubview(logInRegisterBtn)
        isLogInPage = true
        
        registerForKeyboardNotifications()
        let swipedown = UISwipeGestureRecognizer(target: self, action: #selector(forceEndEditing))
        swipedown.direction = .down
        view.addGestureRecognizer(swipedown)
    }
    
    private func setupTextField(Str: String) -> UITextField {
        let temp = UITextField(frame: CGRect(x: 0, y: 0, width: 240, height: 40))
        temp.attributedPlaceholder = NSAttributedString(string: Str, attributes: [NSAttributedStringKey.foregroundColor: UIColor(red: 136/255, green: 152/255, blue: 208/255, alpha: 1)])
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.widthAnchor.constraint(equalToConstant: 240).isActive = true
        temp.heightAnchor.constraint(equalToConstant: 40).isActive = true
        temp.textAlignment = .center
        let newFont: UIFont = UIFont(name: (temp.font?.fontName)!, size: 14)!
        temp.font = newFont
        temp.textColor = UIColor.white
        
        return temp
    }
    
    private func setupSeperator() -> UIView {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.widthAnchor.constraint(equalToConstant: 240).isActive = true
        temp.heightAnchor.constraint(equalToConstant: 2).isActive = true
        temp.backgroundColor = UIColor(red: 136/255, green: 152/255, blue: 208/255, alpha: 1)

        return temp
    }
    
    private func setupComponents() {
        profilePictureBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 135, height: 135))
        profilePictureBtn.translatesAutoresizingMaskIntoConstraints = false
        profilePictureBtn.heightAnchor.constraint(equalToConstant: 135).isActive = true
        profilePictureBtn.widthAnchor.constraint(equalToConstant: 135).isActive = true
        profilePictureBtn.setBackgroundImage(#imageLiteral(resourceName: "default_profile"), for: .normal)
        profilePictureBtn.layer.cornerRadius = profilePictureBtn.frame.height/2
        profilePictureBtn.clipsToBounds = true
        profilePictureBtn.addTarget(self, action: #selector(handleChangeImage), for: .touchUpInside)
        
        handle = setupTextField(Str: "handle")
        handle.textContentType = UITextContentType.username
        handle.delegate = self
        firstName = setupTextField(Str: "first name")
        firstName.delegate = self
        lastName = setupTextField(Str: "last name")
        lastName.delegate = self
        email = setupTextField(Str: "email")
        email.textContentType = UITextContentType.emailAddress
        email.delegate = self
        password = setupTextField(Str: "password")
        password.textContentType = UITextContentType.password
        password.isSecureTextEntry = true
        password.delegate = self
        
        for _ in 0...4 { bounds.append(setupSeperator()) }
        
        logInRegisterBtn = UIButton(type: .system)
        logInRegisterBtn.tintColor = .white
        logInRegisterBtn.setTitle("login/Register", for: .normal)
        logInRegisterBtn.titleLabel?.font = UIFont(name: (logInRegisterBtn.titleLabel?.font.fontName)!, size: 15)
        logInRegisterBtn.translatesAutoresizingMaskIntoConstraints = false
        logInRegisterBtn.heightAnchor.constraint(equalToConstant: 35).isActive = true
        logInRegisterBtn.widthAnchor.constraint(equalToConstant: 104).isActive = true
        logInRegisterBtn.addTarget(self, action: #selector(showPopUp), for: .touchUpInside)
        
        toggleScreenBtn = UIButton(type: .system)
        self.view.addSubview(toggleScreenBtn)
        toggleScreenBtn.tintColor = .white
        toggleScreenBtn.setTitle("Don't have an account? Create one", for: .normal)
        toggleScreenBtn.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 12)
        toggleScreenBtn.backgroundColor = BASE_BACKGROUND_COLOR_DARK
        toggleScreenBtn.translatesAutoresizingMaskIntoConstraints = false
        toggleScreenBtn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        toggleScreenBtn.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        toggleScreenBtn.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        toggleScreenBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        toggleScreenBtn.addTarget(self, action: #selector(handleToggleScreen), for: .touchUpInside)
        
        let safeAreaCover = UIView()
        safeAreaCover.backgroundColor = BASE_BACKGROUND_COLOR_DARK
        self.view.addSubview(safeAreaCover)
        safeAreaCover.translatesAutoresizingMaskIntoConstraints = false
        safeAreaCover.heightAnchor.constraint(equalToConstant: 40).isActive = true
        safeAreaCover.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        safeAreaCover.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        safeAreaCover.topAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    @objc func forceEndEditing() {
        resignFirstResponder()
        view.endEditing(true)
    }
    
    @objc func showPopUp() {
        if isLogInPage {
            handleLoginRegister()
        } else {
            let popUpTitle = "Age Verification"
            let popUpMessage = "You must be 13+ to use this application. By clicking continue, you agree that you've read and understood this term and condition"
            let popUpView = PopupDialog(title: popUpTitle, message: popUpMessage)
            let cancelButton = CancelButton(title: "Cancel") {}
            let continueButton = DefaultButton(title: "Continue") {
                self.handleLoginRegister()
                popUpView.dismiss()
            }
            popUpView.addButtons([continueButton, cancelButton])
            popUpView.buttonAlignment = .horizontal
            self.present(popUpView, animated: true, completion: nil)
        }
    }
    
    @objc func handleLoginRegister() {}
    
    @objc func handleToggleScreen() {
        isLogInPage = !isLogInPage
    }
    
    @objc func handleChangeImage() {
        getImageFromUser(sender: profilePictureBtn, presentingView: self)
    }
}
