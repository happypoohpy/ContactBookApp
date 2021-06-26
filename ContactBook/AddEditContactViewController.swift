//
//  AddEditContactViewController.swift
//  ContactBook
//
//  Created by Joy Marie Navales on 6/25/21.
//

import Foundation
import UIKit
import RealmSwift

class AddEditContactViewController: UIViewController {
    
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldMobileNumber: UITextField!
    @IBOutlet weak var textFieldEmailAddress: UITextField!
    @IBOutlet weak var textFieldCompany: UITextField!
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func onTapDone(_ sender: Any) {
        let firstName = self.textFieldFirstName.text ?? ""
        let lastName = self.textFieldLastName.text ?? ""
        let mobileNumber = self.textFieldMobileNumber.text ?? ""
        let emailAddress = self.textFieldEmailAddress.text ?? ""
        let company = self.textFieldCompany.text ?? ""
        
        let contact = Contact.init(firstName: firstName, lastName: lastName, mobileNumber: mobileNumber, emailAddress: emailAddress, company: company)
        
        if !addToRealm(contact: contact) {
            return
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func addToRealm(contact: Contact) -> Bool {
        let realm = try! Realm()
        
        do {
            try realm.write {
                realm.add(contact)
            }
            return true
        } catch let error as NSError {
            print("adding to realm error \(error.localizedDescription)")
        }
        return false
    }
}
