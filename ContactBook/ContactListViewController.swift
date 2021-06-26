//
//  ViewController.swift
//  ContactBook
//
//  Created by Joy Marie Navales on 6/23/21.
//

import UIKit
import RealmSwift

class ContactListViewController: UIViewController, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var contacts : Results<Contact>?
    
    let searchController = UISearchController()
    
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Contacts"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = self.searchController
        
        self.navigationItem.backButtonTitle = ""
        
        let realm = try! Realm()
        
        self.contacts = realm.objects(Contact.self)
        
        self.observeContactListChanges()
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        print(text)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contacts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactTableViewCell", for: indexPath) as! ContactTableViewCell
        
        if let contacts = self.contacts {
            let contact = contacts[indexPath.row]
            let name = "\(contact.firstName) \(contact.lastName)"
            
            cell.setup(name: name, mobileNumber: contact.mobileNumber)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showContactDetails", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            removeContact(row: indexPath.row)
            return
        }
    }
    
    func removeContact(row: Int) {
        guard let contacts = self.contacts else {
            return
        }
        let realm = try! Realm()
        
        do {
            try realm.write {
                realm.delete(contacts[row])
            }
        } catch let error as NSError {
            print("adding to realm error \(error.localizedDescription)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target = segue.destination as? ContactDetailViewController {
            guard let selectedPath = self.tableView.indexPathForSelectedRow else {
                return
            }
            guard let contacts = self.contacts else {
                return
            }
            target.contact = contacts[selectedPath.row]
            return
        }
    }
    
    func observeContactListChanges() {
        let realm = try! Realm()
        let results = realm.objects(Contact.self)
        // Observe collection notifications. Keep a strong
        // reference to the notification token or the
        // observation will stop.
        notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                tableView.performBatchUpdates({
                    // Always apply updates in the following order: deletions, insertions, then modifications.
                    // Handling insertions before deletions may result in unexpected behavior.
                    tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                         with: .automatic)
                    tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                         with: .automatic)
                    tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                         with: .automatic)
                }, completion: { finished in
                    // ...
                })
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }
    
    func contactModified(contact: Contact, row : Int) {
//        self.contacts[row] = contact
        self.tableView.reloadData()
    }
}

