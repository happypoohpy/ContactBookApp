//
//  ContactDetailViewController.swift
//  ContactBook
//
//  Created by Joy Marie Navales on 6/25/21.
//

import Foundation
import UIKit

class ContactDetailViewController: UIViewController, AddEditContactDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var labelMobile: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelCompany: UILabel!
    
    var contact : Contact?
    var row : Int?
    var delegate: AddEditContactDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.largeTitleDisplayMode = .automatic
        
        setDisplay()
    }
    
    func setDisplay() {
        guard let contact = self.contact else {
            return
        }
        self.navigationItem.title = "\(contact.firstName) \(contact.lastName)"
        self.labelMobile.text = contact.mobileNumber
        self.labelEmail.text = contact.emailAddress
        self.labelCompany.text = contact.company
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target = segue.destination as? AddEditContactViewController {
            target.contact = self.contact
            target.row = self.row
            target.delegate = self
            return
        }
    }
    
    func contactAdded(newContact: Contact) {
        self.delegate?.contactAdded(newContact: newContact)
    }
    
    func contactModified(contact: Contact, row: Int) {
        self.contact = contact
        setDisplay()
        self.delegate?.contactModified(contact: contact, row: row)
    }
}
