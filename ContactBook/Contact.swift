//
//  Contact.swift
//  ContactBook
//
//  Created by Joy Marie Navales on 6/25/21.
//

import Foundation
import RealmSwift

class Contact : Object {
    @objc dynamic var _id = ObjectId.generate()
    @objc dynamic var firstName : String = ""
    @objc dynamic var lastName : String = ""
    @objc dynamic var mobileNumber : String = ""
    @objc dynamic var emailAddress : String = ""
    @objc dynamic var company : String = ""
    
    convenience init(firstName : String,
         lastName : String,
         mobileNumber : String,
         emailAddress : String,
         company : String) {
        self.init()
        
        self.firstName = firstName
        self.lastName = lastName
        self.mobileNumber = mobileNumber
        self.emailAddress = emailAddress
        self.company = company
    }
    
    override class func primaryKey() -> String? {
        return "_id"
    }
}
