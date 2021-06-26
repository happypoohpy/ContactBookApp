//
//  AddEditContactViewController.swift
//  ContactBook
//
//  Created by Joy Marie Navales on 6/25/21.
//

import Foundation
import UIKit

protocol AddEditContactDelegate {
    func contactAdded(newContact: Contact)
    func contactModified(contact: Contact, row: Int)
}

class AddEditContactViewController: UIViewController {
    
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldMobileNumber: UITextField!
    @IBOutlet weak var textFieldEmailAddress: UITextField!
    @IBOutlet weak var textFieldCompany: UITextField!
    
    var delegate: AddEditContactDelegate?
    
    var contact : Contact?
    var row : Int?
    
    override func viewDidLoad() {
     
        if let contact = self.contact {
            self.navigationItem.title = "Edit Contact"
            self.textFieldFirstName.text = contact.firstName
            self.textFieldLastName.text = contact.lastName
            self.textFieldMobileNumber.text = contact.mobileNumber
            self.textFieldEmailAddress.text = contact.emailAddress
            self.textFieldCompany.text = contact.company
        }
    }
    
    @IBAction func onTapDone(_ sender: Any) {
        let firstName = self.textFieldFirstName.text ?? ""
        let lastName = self.textFieldLastName.text ?? ""
        let mobileNumber = self.textFieldMobileNumber.text ?? ""
        let emailAddress = self.textFieldEmailAddress.text ?? ""
        let company = self.textFieldCompany.text ?? ""
        
        let contact = Contact.init(firstName: firstName, lastName: lastName, mobileNumber: mobileNumber, emailAddress: emailAddress, company: company)
        
        if self.contact != nil {
            self.editContact(contact: contact)
        } else {
            self.addContact(contact: contact)
        }
         
        self.navigationController?.popViewController(animated: true)
    }
    
    func addContact(contact: Contact) {
        self.delegate?.contactAdded(newContact: contact)
    }
    
    func editContact(contact: Contact) {
        guard let row = self.row else {
            return
        }
        self.contact = contact
        self.delegate?.contactModified(contact: contact, row: row)
    }
}
