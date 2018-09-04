//
//  Message.swift
//  Tell
//
//  Created by Lloyd Dapaah on 7/17/18.
//  Copyright © 2018 Lloyd Dapaah. All rights reserved.
//

import Foundation
import RealmSwift

class Message: Object {
    @objc dynamic var toId: String? = nil
    @objc dynamic var fromId: String? = nil
    var timeStamp = RealmOptional<Int>()
    @objc dynamic var text: String? = nil
    @objc dynamic var translatedText: String? = nil
    @objc dynamic var targetLanguage: String? = nil
    @objc dynamic var isRecent: Bool = false
    
    var parentCategory = LinkingObjects(fromType: Contact.self, property: "messages")
}
