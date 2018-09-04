//
//  RealmController.swift
//  Tell
//
//  Created by Lloyd Dapaah on 7/17/18.
//  Copyright © 2018 Lloyd Dapaah. All rights reserved.
//

import Foundation
import RealmSwift
import Firebase

let realm = try! Realm()

func addNewUserToRealm(contact: SearchContact, with uid: String, completion: @escaping(Contact)->Void) {
    let existingUsers = realm.objects(Contact.self)
    
    for user in existingUsers {
        if user.uid == uid {completion(user); return}
    }
    
    let user = Contact()
    user.uid = uid
    user.firstName = contact.firstName
    user.lastName = contact.lastName
    user.handle = contact.handle
    user.image = UIImageJPEGRepresentation(contact.profilePicture, 1)
    
    do {
        try realm.write {
            realm.add(user)
            
            let existingUsers = realm.objects(Contact.self)
            for user in existingUsers {
                if user.uid == uid {completion(user); return}
            }
        }
    } catch let error{
        print("Realm Saving: \(error)")
    }
}

func updateRealmMessages(of user: Contact, with messages: [String:[String:Any]]) {
    for message in messages {
        let messageDetails = message.value
        let messageId = message.key
        let text = messageDetails["text"] as? String
        let toId = messageDetails["toId"] as? String
        let fromId = messageDetails["fromId"] as? String
        let timeStampNSN = messageDetails["timeStamp"] as? NSNumber
        let timeStamp = timeStampNSN?.intValue
        
        let realmMessage = Message()
        realmMessage.text = text
        realmMessage.timeStamp.value = timeStamp
        realmMessage.fromId = fromId
        realmMessage.toId = toId
        
        do {
            try realm.write {
                user.messages.append(realmMessage)
                if user.messages.count > 1 {
                    user.messages.last?.isRecent = true
                    user.messages[user.messages.count-2].isRecent = false
                } else if user.messages.count == 1 {
                    user.messages.first?.isRecent = true
                }
                
                removeMessageFromFirebase(contactId: user.uid!, messageId: messageId)
            }
        } catch let error {
            print("Updating realm message: \(error)")
        }
    }
}

func searchRealmForUser(with uid: String, completion: @escaping(Contact?)->Void) {
    let existingUsers = realm.objects(Contact.self)
    
    for user in existingUsers {
        if user.uid == uid {completion(user); return}
    }
    
    completion(nil)
}
