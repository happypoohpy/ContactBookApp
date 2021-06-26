//
//  ViewController.swift
//  ContactBook
//
//  Created by Joy Marie Navales on 6/23/21.
//

import UIKit

class ContactListViewController: UIViewController, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource, AddEditContactDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var contacts : [Contact] = [Contact]()
    
    let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Contacts"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = self.searchController
        
        self.navigationItem.backButtonTitle = ""
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        print(text)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactTableViewCell", for: indexPath) as! ContactTableViewCell
        
        let contact = contacts[indexPath.row]
        let name = "\(contact.firstName) \(contact.lastName)"
        
        cell.setup(name: name, mobileNumber: contact.mobileNumber)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showContactDetails", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            self.contacts.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .top)
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target = segue.destination as? ContactDetailViewController {
            guard let selectedPath = self.tableView.indexPathForSelectedRow else {
                return
            }
            target.contact = self.contacts[selectedPath.row]
            return
        }
        if let target = segue.destination as? AddEditContactViewController {
            target.delegate = self
            return
        }
    }
    
    func contactAdded(newContact: Contact) {
        self.contacts.append(newContact)
        self.tableView.reloadData()
    }
}

