//
//  SearchController.swift
//  Tell
//
//  Created by Lloyd Dapaah on 7/11/18.
//  Copyright © 2018 Lloyd Dapaah. All rights reserved.
//

import UIKit

class SearchContact {
    var firstName: String
    var lastName: String
    var profilePicture: UIImage = #imageLiteral(resourceName: "default_profile")
    var isActive: Bool
    var handle: String
    var uid: String
    
    init(first: String, last: String, image: UIImage, isActive: Bool, handle: String, uid: String) {
        firstName = first
        lastName = last
        profilePicture = image
        self.isActive = isActive
        self.handle = handle
        self.uid = uid
    }
}

class SearchController: SearchView, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    var results: [SearchContact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.separatorStyle = .none
        searchTableView.register(ContactCell.self, forCellReuseIdentifier: "contactCell")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let query = searchBar.text ?? ""
        
        guard !query.isEmpty else { return }
        results.removeAll()
        searchTableView.reloadData()
        searchBar.text = ""
        var currentRow: Int = 0
        querySearch(with: query) { (uids) in
            DispatchQueue.main.async {
                for uid in uids {
                    searchForUser(with: uid, completion: { (contact) in
                        self.results.append(contact)
                        self.searchTableView.insertRows(at: [IndexPath(item: currentRow, section: 0)], with: .automatic)
                        currentRow += 1
                    })
                }
            }
            searchBar.resignFirstResponder()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedContact = results[indexPath.row]
        addNewUserToRealm(contact: selectedContact, with: selectedContact.uid) { (contact) in
            let title = (contact.handle?.first)! == "@" ? contact.handle : "@" + contact.handle!
            let newComposeView = ComposeController()
            newComposeView.navigationItem.title = title
            newComposeView.contact = contact
            self.present(UINavigationController(rootViewController: newComposeView), animated: true, completion: nil)
        }
        searchTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = results[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactCell
        
        cell.profileImageView.image = item.profilePicture
        cell.usernameLabel.text = item.firstName.capitalized + " " + item.lastName.capitalized
        if item.handle.first != "@" { cell.handleLabel.text = "@" + item.handle }
        else { cell.handleLabel.text = item.handle }
        if item.isActive { cell.lastTextLabel.text = "Online" }
        else { cell.lastTextLabel.text = "Offline" }
        cell.dateLabel.isHidden = true
        
        return cell
    }
}
