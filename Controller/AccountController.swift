//
//  AccountView.swift
//  Tell
//
//  Created by Lloyd Dapaah on 7/11/18.
//  Copyright © 2018 Lloyd Dapaah. All rights reserved.
//

import UIKit

class AccountController: AccountView {
    var hasParent: Bool = false
    var errorMessageLabel: UILabel!
    var errorMessage: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        errorMessage = UIView()
        errorMessage.frame = CGRect(x: 0, y: 0, width: 280, height: 50)
        errorMessage.layer.cornerRadius = 6
        errorMessage.clipsToBounds = true
        errorMessage.backgroundColor = BASE_BACKGROUND_COLOR
        errorMessage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(errorMessage)
        errorMessage.widthAnchor.constraint(equalToConstant: 280).isActive = true
        errorMessage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        errorMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        errorMessage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        errorMessageLabel = UILabel()
        errorMessageLabel.text = "Network Error"
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.font = UIFont.systemFont(ofSize: 15)
        errorMessageLabel.textColor = .white
        errorMessage.addSubview(errorMessageLabel)
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.topAnchor.constraint(equalTo: errorMessage.topAnchor).isActive = true
        errorMessageLabel.bottomAnchor.constraint(equalTo: errorMessage.bottomAnchor).isActive = true
        errorMessageLabel.leadingAnchor.constraint(equalTo: errorMessage.leadingAnchor).isActive = true
        errorMessageLabel.trailingAnchor.constraint(equalTo: errorMessage.trailingAnchor).isActive = true
        errorMessage.isHidden = true
    }
    
    override func handleLoginRegister() {
        guard let btnTitle = logInRegisterBtn.titleLabel?.text else {return}
        
        if btnTitle == "Log in" {
            logInUser(email: email.text ?? "", password: password.text ?? "") { (isSuccessful) in
                if !isSuccessful {
                    self.promptError(err: "Wrong email/password")
                } else {
                    self.changeViews()
                    self.resetFields()
                }
            }
        } else {
            registerUser(handle: handle.text ?? "", first: firstName.text ?? "",
                         last: lastName.text ?? "", email: email.text ?? "",
                         password: password.text ?? "", image: (profilePictureBtn.backgroundImage(for: .normal))!) { (logstatus) in
                            if logstatus == RegisterStatus.Success {
                                self.changeViews()
                                self.resetFields()
                            } else {
                                self.promptError(err: logstatus.rawValue)
                            }
            }
        }
    }
    
    func changeViews() {
        UserDefaults.standard.set(true, forKey: "isLoggedIn")

        if hasParent {
            dismiss(animated: true, completion: nil)
        } else {
            let vc = RootPageView(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
            vc.hasParent = true
            present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        }
    }
    
    func resetFields() {
        handle.text = ""
        firstName.text = ""
        lastName.text = ""
        email.text = ""
        password.text = ""
        profilePictureBtn.setBackgroundImage(#imageLiteral(resourceName: "default_profile"), for: .normal)
        isLogInPage = true
    }
    
    func promptError(err: String) {
        errorMessageLabel.text = err
        errorMessage.isHidden = false
        errorMessage.alpha = 0
        errorMessage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.5, delay: 0.07, options: .curveEaseOut, animations: {
            self.errorMessage.alpha = 1
            self.errorMessage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { (_) in
            UIView.animate(withDuration: 0.2, delay: 0.3, options: .curveEaseIn, animations: {
                self.errorMessage.alpha = 0
                self.errorMessage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }, completion: { (_) in
                self.errorMessage.isHidden = true
            })
        }
    }

}
