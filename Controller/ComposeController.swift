//
//  ComposeController.swift
//  Tell
//
//  Created by Lloyd Dapaah on 7/15/18.
//  Copyright © 2018 Lloyd Dapaah. All rights reserved.
//

import UIKit
import RealmSwift

class ComposeController: ComposeView, UITableViewDelegate, UITableViewDataSource {
    var isShowingPopUp: Bool = false
    var isViewSetup: Bool = false
    
    var contact: Contact!
    var loadedMessages: List<Message>?
    var notificationToken: NotificationToken? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let img = UIImage(data: contact.image!)
        userImageButton.backgroundColor = .clear
        userImageButton.setBackgroundImage(img!, for: .normal)
        userImageButton.contentMode = .center
        userImageButton.contentHorizontalAlignment = .center
        userImageButton.contentVerticalAlignment = .center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isViewSetup {            
            textBubbleTableView.delegate = self
            textBubbleTableView.dataSource = self
            textBubbleTableView.separatorStyle = .none
            textBubbleTableView.estimatedRowHeight = 50
            textBubbleTableView.rowHeight = UITableViewAutomaticDimension
            
            textBubbleTableView.register(ContactTextCell.self, forCellReuseIdentifier: ContactTextCell.selfIdentifier)
            textBubbleTableView.register(UserTextCell.self, forCellReuseIdentifier: UserTextCell.selfIdentifier)
            
            popUpUserImage.image = UIImage(data: contact.image!)
            popUpUserNameLabel.text = (contact.firstName?.capitalized)! + " " + (contact.lastName?.capitalized)!
            popUpUserNameHandle.text = (contact.handle?.first)! == "@" ? contact.handle : "@" + contact.handle!
            
            loadedMessages = contact.messages
            registerForRealmNotifications()
            
            isViewSetup = true
        }
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loadedMessages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = loadedMessages![indexPath.row]
        
        if message.fromId == contact.uid {
            let cell = tableView.dequeueReusableCell(withIdentifier: UserTextCell.selfIdentifier, for: indexPath) as! UserTextCell
            cell.customtextLabel.text = message.text!
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ContactTextCell.selfIdentifier, for: indexPath) as! ContactTextCell
            cell.customtextLabel.text = message.text!
            return cell
        }
    }
    
    func registerForRealmNotifications() {
        notificationToken = loadedMessages?.observe({ (changes) in
            switch changes {
            case .initial:
                self.textBubbleTableView.reloadData()
                if self.textBubbleTableView.contentSize.height > self.textBubbleTableView.frame.size.height {
                    let offset: CGPoint = CGPoint(x: 0, y: self.textBubbleTableView.contentSize.height - self.textBubbleTableView.frame.size.height)
                    self.textBubbleTableView.setContentOffset(offset, animated: false)
                }
                break
            case .update(_, _, let insertions, let modifications):
                for insertedInt in insertions {
                    let i = IndexPath(row: insertedInt, section: 0)
                    self.textBubbleTableView.insertRows(at:[i], with: .automatic)
                }
                for modInt in modifications {
                    let i = IndexPath(row: modInt, section: 0)
                    self.textBubbleTableView.reloadRows(at: [i], with: .automatic)
                }
                
                self.textBubbleTableView.scrollToRow(at: IndexPath(row: (self.loadedMessages?.count)! - 1, section: 0),
                                                     at: UITableViewScrollPosition.bottom,
                                                     animated: true)
                break
            case .error(let err):
                fatalError("\(err)")
                break
            }
        })
    }
    
    override func handleMessageSent() {
        let text = textEntryBox.text ?? ""
        if text.isEmpty {return}
        
        uploadMessage(toid: contact.uid!, text: text)
        
        textEntryBox.text = ""
        textViewDidChange(textEntryBox)
    }
    
    override func handleContactDetailsTapped() {
        isShowingPopUp = !isShowingPopUp
        
        if isShowingPopUp {
            showContactDetails()
        } else {
            hideContactDetails()
        }
    }
    
    override func handleHidePopUp() {
        hideContactDetails()
        isShowingPopUp = false
    }
    
    override func handleReportUser() {
        hideContactDetails()
        isShowingPopUp = false
    }
    
    override func handleBlockUser() {
        hideContactDetails()
        isShowingPopUp = false
    }
}
