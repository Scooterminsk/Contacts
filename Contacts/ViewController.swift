//
//  ViewController.swift
//  Contacts
//
//  Created by Zenya Kirilov on 31.05.22.
//

import UIKit

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "MyCell") {
            print("Используем старую ячейку для строки с индексом \(indexPath.row)")
            cell = reuseCell
        } else {
            print("Создаем новую ячейку для строки с индексом \(indexPath.row)")
            cell = UITableViewCell(style: .default, reuseIdentifier: "MyCell")
        }
        configure(cell: &cell, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func configure(cell: inout UITableViewCell, for indexPath: IndexPath) {
        var configuration = cell.defaultContentConfiguration()
        // contact name
        configuration.text = contacts[indexPath.row].title
        // contact phone number
        configuration.secondaryText = contacts[indexPath.row].phone
        cell.contentConfiguration = configuration
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // delete action
        let actionDelete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            // deleting a contact
            self.contacts.remove(at: indexPath.row)
            // configurate table view again
            tableView.reloadData()
        }
        // creating an instance, that describes available actions
        let actions = UISwipeActionsConfiguration(actions: [actionDelete])
        return actions
    }
}

class ViewController: UIViewController {

    
    private var contacts = [ContactProtocol]() {
        didSet {
            contacts.sort { $0.title < $1.title }
            // saving contacts to storage
            storage.save(contacts: contacts)
        }
    }
    
    var storage: ContactStorageProtocol!
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storage = ContactStorage()
        loadContacts()
    }
    
    @IBAction func showNewContactAlert() {
        // creation of Alert Controller
        let alertController = UIAlertController(title: "Create new contact", message: "Insert name and phone number", preferredStyle: .alert)
        
        // add the first text field in the Alert Controller
        alertController.addTextField { textField in
            textField.placeholder = "Name"
        }
        
        // add the seecond text field in the Alert Controller
        alertController.addTextField { textField in
            textField.placeholder = "Phone number"
        }
        
        // create buttons
        // button of the contact creation
        let createButton = UIAlertAction(title: "Create", style: .default) { _ in
            guard let contactName = alertController.textFields?[0].text, let contactPhone = alertController.textFields?[1].text else {
                return
            }
            // create new contact
            let contact = Contact(title: contactName, phone: contactPhone)
            self.contacts.append(contact)
            self.tableView.reloadData()
        }
        
        // cancel button
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // add buttons to the Alert Controller
        alertController.addAction(cancelButton)
        alertController.addAction(createButton)
        
        // present the Alert Controller
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    private func loadContacts() {
        contacts = storage.load()
    }


}

