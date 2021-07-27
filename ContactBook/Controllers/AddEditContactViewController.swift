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
    @IBOutlet weak var buttonDelete: UIButton!
    
    @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
    
    var contact: Contact?
    
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
     
        if let contact = self.contact {
            self.navigationItem.title = "Edit Contact"
            self.textFieldFirstName.text = contact.firstName
            self.textFieldLastName.text = contact.lastName
            self.textFieldMobileNumber.text = contact.mobileNumber
            self.textFieldEmailAddress.text = contact.emailAddress
            self.textFieldCompany.text = contact.company
        } else {
            self.buttonDelete.isHidden = true
        }
        observeContactListChanges()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func observeContactListChanges() {
        guard let contact = self.contact else {
            return
        }
        
        let realm = try! Realm()
        let results = realm.object(ofType: Contact.self, forPrimaryKey: contact._id)
        // Observe collection notifications. Keep a strong
        // reference to the notification token or the
        // observation will stop.
        notificationToken = results?.observe { [weak self] (change: ObjectChange) in
            switch change {
            case .deleted:
                self?.performSegue(withIdentifier: "unwindToContactList", sender: self)
                return
            case .error(_):
                return
            case .change(_, _):
                return
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
         print("keyboardWillShow")
        if let info = notification.userInfo {
            let rect: CGRect = info["UIKeyboardFrameBeginUserInfoKey"] as! CGRect
            
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
                self.textFieldBottomConstraint.constant = rect.height + 20
            })
        }
    }
    
    @IBAction func onTapDelete(_ sender: Any) {
        removeContact()
    }
    
    @IBAction func onTapDone(_ sender: Any) {
        let firstName = self.textFieldFirstName.text?.trim() ?? ""
        let lastName = self.textFieldLastName.text?.trim() ?? ""
        let mobileNumber = self.textFieldMobileNumber.text?.trim() ?? ""
        let emailAddress = self.textFieldEmailAddress.text?.trim() ?? ""
        let company = self.textFieldCompany.text?.trim() ?? ""
        
        guard validateContactDetails(firstName: firstName,
                                     lastName: lastName,
                                     mobileNumber: mobileNumber,
                                     emailAddress: emailAddress,
                                     company: company) else {
            dismissSelf()
            return
        }
        
        let newContact = Contact.init(firstName: firstName, lastName: lastName, mobileNumber: mobileNumber, emailAddress: emailAddress, company: company)
        
        if self.contact != nil {
            if !editContact(contact: newContact) {
               return
            }
        } else if !addToRealm(contact: newContact) {
            return
        }
        dismissSelf()
    }
    
    func dismissSelf() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func validateContactDetails(firstName: String,
                                lastName: String,
                                mobileNumber: String,
                                emailAddress: String,
                                company: String) -> Bool {
        
        return !firstName.isEmpty ||
            !lastName.isEmpty ||
            !mobileNumber.isEmpty ||
            !emailAddress.isEmpty ||
            !company.isEmpty
    }
    
    func addToRealm(contact: Contact) -> Bool {
        let realm = try! Realm()
        
        do {
            try realm.write {
                realm.create(Contact.self, value: contact, update: .modified)
            }
            return true
        } catch let error as NSError {
            print("adding to realm error \(error.localizedDescription)")
        }
        return false
    }
    
    func editContact(contact: Contact) -> Bool {
        let realm = try! Realm()
        
        do {
            try realm.write {
                self.contact?.firstName = contact.firstName
                self.contact?.lastName = contact.lastName
                self.contact?.mobileNumber = contact.mobileNumber
                self.contact?.emailAddress = contact.emailAddress
                self.contact?.company = contact.company
            }
            return true
        } catch let error as NSError {
            print("adding to realm error \(error.localizedDescription)")
        }
        return false
    }
    
    func removeContact() {
        guard let contact = self.contact else {
            return
        }
        let realm = try! Realm()
        
        do {
            try realm.write {
                realm.delete(contact)
            }
        } catch let error as NSError {
            print("adding to realm error \(error.localizedDescription)")
        }
    }
}
