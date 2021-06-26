//
//  ContactDetailViewController.swift
//  ContactBook
//
//  Created by Joy Marie Navales on 6/25/21.
//

import Foundation
import UIKit

class ContactDetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var labelMobile: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelCompany: UILabel!
    
    var contact : Contact?
    
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
}
