//
//  ContactViewCell.swift
//  ContactBook
//
//  Created by Joy Marie Navales on 6/27/21.
//

import Foundation
import UIKit

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelMobileNumber: UILabel!
    
    func setup(name: String, mobileNumber: String) {
        self.labelName.text = name
        self.labelMobileNumber.text = mobileNumber
    }
}
