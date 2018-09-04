//
//  FirebaseController.swift
//  Tell
//
//  Created by Lloyd Dapaah on 7/16/18.
//  Copyright © 2018 Lloyd Dapaah. All rights reserved.
//

import Foundation
import Firebase
import SVProgressHUD
import SwiftyJSON
import Alamofire

enum RegisterStatus: String {
    case Fail = "Check Network"
    case InvalidFail = "Invalid username or password"
    case IncompleteFail = "Incomplete fields"
    case Success = "Success"
}

enum Cloud: String {
    case firstName = "firstName"
    case lastName = "lastName"
    case imageUrl = "imageUrl"
    case handle = "handle"
    case isActive = "isActive"
    
    case reciever = "toId"
    case sender = "fromId"
    case text = "text"
    case time = "timeStamp"
}

func addToSearchDatabase(username: String, uid: String) {
    let data: [String:Any] = ["uid":uid]
    let reference = Database.database().reference().child("search").child(username)
    reference.updateChildValues(data) { (err, newRef) in
        if err != nil {
            print(err ?? "None")
        }
    }
}

func logInUser(email: String, password: String, completion: @escaping (Bool)->Void) {
    SVProgressHUD.show()
    
    if email.isEmpty || password.isEmpty {
        SVProgressHUD.dismiss()
        completion(false)
        return
    } else {
        Auth.auth().signIn(withEmail: email, password: password) { (data, err) in
            if err != nil {
                SVProgressHUD.dismiss()
                completion(false)
            } else {
                SVProgressHUD.dismiss()
                completion(true)
            }
        }
    }
}

func registerUser(handle: String, first: String, last: String, email: String, password: String, image: UIImage, completion: @escaping (RegisterStatus)->Void) {
    SVProgressHUD.show()
    var registrationData: [String:Any] = [:]
    
    guard !handle.isEmpty && !first.isEmpty && !last.isEmpty && !email.isEmpty && !password.isEmpty else {
        SVProgressHUD.dismiss()
        completion(RegisterStatus.IncompleteFail)
        return
    }
    
    registrationData.updateValue(handle, forKey: "handle")
    registrationData.updateValue(first, forKey: "firstName")
    registrationData.updateValue(last, forKey: "lastName")
    registrationData.updateValue(email, forKey: "email")
    registrationData.updateValue("default", forKey: "imageUrl")
    registrationData.updateValue(true, forKey: "isActive")
    
    Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
        if err != nil {
            SVProgressHUD.dismiss()
            completion(.InvalidFail)
            return
        }
        
        // get uid of registered user
        guard let user = result?.user else {
            SVProgressHUD.dismiss()
            completion(.Fail)
            return
        }
        
        let uid = user.uid
        DispatchQueue.main.async {
            let storage = Storage.storage().reference().child("profile_images").child("\(uid).jpeg")
            
            guard let data = UIImageJPEGRepresentation(image, 0.2) else {
                SVProgressHUD.dismiss()
                completion(.Fail)
                return
            }
            
            // upload image and get absolute url of image
            storage.putData(data, metadata: nil) { (metadata, err) in
                if err != nil {SVProgressHUD.dismiss(); completion(.Fail); return}
                
                storage.downloadURL(completion: { (url, err) in
                    guard let purl = url else {SVProgressHUD.dismiss(); completion(.Fail); return}
                    
                    DispatchQueue.main.async {
                        registrationData.updateValue(purl.absoluteString, forKey: "imageUrl")
                        
                        let baseRef = Database.database().reference().child("users").child(uid)
                        baseRef.updateChildValues(registrationData, withCompletionBlock: { (err, ref) in
                            if err != nil {
                                print(err.debugDescription)
                                SVProgressHUD.dismiss(); completion(.Fail); return
                            } else {
                                addToSearchDatabase(username: handle, uid: uid)
                                SVProgressHUD.dismiss(); completion(.Success); return
                            }
                        })
                        return
                    }
                })
            }
        }
    }
}

func searchForUser(with uid: String, completion: @escaping (SearchContact)->Void) {
    let reference = Database.database().reference().child("users").child(uid)
    
    reference.observeSingleEvent(of: .value) { (snapshot) in
        DispatchQueue.main.async {
            guard let retrievedDictionary = snapshot.value as? [String:Any] else { return }
            let firstName = retrievedDictionary[Cloud.firstName.rawValue] as? String
            let lastName = retrievedDictionary[Cloud.lastName.rawValue] as? String
            let imageUrl = retrievedDictionary[Cloud.imageUrl.rawValue] as? String
            let handle = retrievedDictionary[Cloud.handle.rawValue] as? String
            let isActive = retrievedDictionary[Cloud.isActive.rawValue] as? Bool
            
            UIImageView().loadImagesUsingCache(url: imageUrl!, completion: { (image) in
                guard let img = image else {return}
                DispatchQueue.main.async {
                    completion(SearchContact(first: firstName!, last: lastName!,
                                             image: img, isActive: isActive!,
                                             handle: handle!, uid: uid))
                }
            })
        }
    }
}

func observeUserMessages() {
    let uid = Auth.auth().currentUser?.uid
    let reference = Database.database().reference().child("user-messages").child(uid!)
    
    reference.observe(.value) { (snapshot) in
        DispatchQueue.main.async {
            guard let allcontacts = snapshot.value as? [String:Any] else {return}
            
            for contact in allcontacts {
                let contactUid = contact.key
                guard let messages = contact.value as? [String:[String:Any]] else {return}
                
                searchRealmForUser(with: contactUid, completion: { (realmContact) in
                    if realmContact == nil {
                        // create user first if not available
                        searchForUser(with: contactUid, completion: { (searchResults) in
                            DispatchQueue.main.async {
                                addNewUserToRealm(contact: searchResults, with: searchResults.uid, completion: { (newRealmContact) in
                                    updateRealmMessages(of: newRealmContact, with: messages)
                                })
                            }
                        })
                    }
                    updateRealmMessages(of: realmContact!, with: messages)
                })
            }
        }
    }
}

func querySearch(with searchTerm: String, completion: @escaping ([String])->Void) {
    var retrievedUids: [String] = []
    let reference = Database.database().reference().child("search")
    
    reference.observeSingleEvent(of: .value) { (snapshot) in
        DispatchQueue.main.async {
            guard let data = snapshot.value as? [String:[String:String]] else { return }
            for single in data {
                if single.key.lowercased().contains(searchTerm.lowercased()) {
                    retrievedUids.append(single.value["uid"]!)
                }
            }
            completion(retrievedUids)
        }
    }
}

func uploadMessage(toid: String, text: String) {
    let myuid = (Auth.auth().currentUser?.uid)!
    
//    getLanguage(of: myuid!) { (language) in
//        DispatchQueue.main.async {
//            translateToEn(originalText: text, srclang: language, completion: { (translatedText) in
                let values : [String: Any] = [
                    "text": text,
                    "timeStamp": Int(Date().timeIntervalSince1970),
                    "toId": toid,
                    "fromId": myuid
                ]
                
                let reference = Database.database().reference().child("user-messages")
                let refSender = reference.child(myuid).child(toid).childByAutoId()
                let autoId = refSender.key
                let refReciever = reference.child(toid).child(myuid).child(autoId)

                refSender.updateChildValues(values)
                refReciever.updateChildValues(values)
//            })
//        }
//    }
}

func removeMessageFromFirebase(contactId: String, messageId: String) {
    let uid = Auth.auth().currentUser?.uid
    Database.database().reference().child("user-messages").child(uid!).child(contactId).child(messageId).removeValue()
}










