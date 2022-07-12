//
//  Contact.swift
//  Contacts
//
//  Created by Zenya Kirilov on 1.06.22.
//

import Foundation
import Metal

protocol ContactProtocol {
    // nane
    var title: String { get set }
    // phone number
    var phone: String { get set }
}

protocol ContactStorageProtocol {
    // download contact list
    func load() -> [ContactProtocol]
    // update contact list
    func save(contacts: [ContactProtocol])
}

struct Contact: ContactProtocol {
    var title: String
    var phone: String
}

class ContactStorage: ContactStorageProtocol {
    // reference on storage
    private var storage = UserDefaults.standard
    // key for saving storage
    private var storageKey = "contacts"
    
    // enum with keys for recording in User Defaults
    private enum ContactKey: String {
        case title
        case phone
    }
    
    func load() -> [ContactProtocol] {
        var resultContacts: [ContactProtocol] = []
        let contactsFromStorage = storage.array(forKey: storageKey) as? [[String: String]] ?? []
        for contact in contactsFromStorage {
            guard let title = contact[ContactKey.title.rawValue],
                  let phone = contact[ContactKey.phone.rawValue] else {
                continue
            }
            resultContacts.append(Contact(title: title, phone: phone))
        }
        return resultContacts
    }
    
    func save(contacts: [ContactProtocol]) {
        var arrayForStorage: [[String: String]] = []
        contacts.forEach { contact in
            var newElementForStorage: Dictionary<String, String> = [:]
            newElementForStorage[ContactKey.title.rawValue] = contact.title
            newElementForStorage[ContactKey.phone.rawValue] = contact.phone
            arrayForStorage.append(newElementForStorage)
        }
        storage.set(arrayForStorage, forKey: storageKey)
    }
}



