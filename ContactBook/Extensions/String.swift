//
//  String.swift
//  ContactBook
//
//  Created by Joy Marie Navales on 7/26/21.
//

import Foundation

extension String {
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
