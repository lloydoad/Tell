//
//  Contacts.swift
//  Tell
//
//  Created by Lloyd Dapaah on 7/17/18.
//  Copyright © 2018 Lloyd Dapaah. All rights reserved.
//

import UIKit
import RealmSwift

class Contact: Object {
    @objc dynamic var uid: String? = nil
    @objc dynamic var firstName: String? = nil
    @objc dynamic var lastName: String? = nil
    @objc dynamic var handle: String? = nil
    @objc dynamic var image: Data? = nil
    @objc dynamic var isBlocked: Bool = false
    let messages = List<Message>()
}
