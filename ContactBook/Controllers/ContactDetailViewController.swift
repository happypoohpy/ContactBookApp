//
//  ContactDetailViewController.swift
//  ContactBook
//
//  Created by Joy Marie Navales on 6/25/21.
//

import Foundation
import UIKit
import RealmSwift

class ContactDetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var labelMobile: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelCompany: UILabel!
    @IBOutlet weak var stackViewMobile: UIStackView!
    @IBOutlet weak var stackViewEmail: UIStackView!
    @IBOutlet weak var stackViewCompany: UIStackView!
    
    var contact : Contact?
    
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.largeTitleDisplayMode = .automatic
        
        setDisplay()
        observeContactListChanges()
        
        stackViewMobile.layer.cornerRadius = 7.0
        stackViewEmail.layer.cornerRadius = 7.0
        stackViewCompany.layer.cornerRadius = 7.0
    }
    
    func setDisplay() {
        guard let contact = self.contact else {
            return
        }
        
        let name = "\(contact.firstName) \(contact.lastName)"
        
        self.navigationItem.title = name.trim().isEmpty ? contact.mobileNumber : name
        self.labelMobile.text = contact.mobileNumber
        self.labelEmail.text = contact.emailAddress
        self.labelCompany.text = contact.company
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target = segue.destination as? AddEditContactViewController {
            target.contact = self.contact
            return
        }
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
                return
            case .error(_):
                return
            case .change(_, _):
                self?.setDisplay()
            }
        }
    }
    
    @IBAction func onTapDelete(_ sender: Any) {
        removeContact()
        dismissSelf()
    }
    
    func dismissSelf() {
        self.navigationController?.popViewController(animated: true)
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
