//
//  ContactsKit.swift
//  MBFoundation
//
//  Created by rensihao on 2021/2/6.
//
//  Note20220314: 大部分未在宿主使用，使用前先测试

import Foundation
import Contacts

@objc
/// Define some basic system address book capability protocols based on 'Contacts'.
public protocol MBContactable {

    /// The current application's access status to the system address book.
    static var authorizationStatus: CNAuthorizationStatus { get }

    /// Whether the current application allows access to the system address book.
    //  Note20220314: 在宿主使用
    static var isAuthorized: Bool { get }

    /// Fetch the system address book contact data.
    static func fetchContacts() -> [CNContact]?

    /// Fetch the system address book contact data.
    /// Only applicable to iOS10 and above.
    /// - Parameter sortOrder: Sort order for contacts.
    @available(iOS 10.0, *)
    static func fetchContacts(_ sortOrder: CNContactSortOrder) -> [CNContact]?

    /// Format an array of 'CNContact' object into an array of
    ///   ''' {"name": "xxx", "telephone": "xxx"} ''' object.
    /// - Parameter contacts: Array of 'CNContact' object.
    static func formatContacts(_ contacts: [CNContact]) -> [[String: String]]?
}

@objc
public class MBContacts: NSObject, MBContactable {

    public static var authorizationStatus: CNAuthorizationStatus {
        CNContactStore.authorizationStatus(for: .contacts)
    }

    public static var isAuthorized: Bool {
        authorizationStatus == CNAuthorizationStatus.authorized
    }

    public static func fetchContacts() -> [CNContact]? {
        guard isAuthorized else {
            return nil
        }

        let contactStore = CNContactStore()
        var contacts: [CNContact] = [CNContact]()
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])

        do {
            try contactStore.enumerateContacts(with: request, usingBlock: { (contact, _) in
                contacts.append(contact)
            })
            return contacts
        } catch let error as NSError {
            debugPrint(error)
            return nil
        }
    }

    @available(iOS 10.0, *)
    public static func fetchContacts(_ sortOrder: CNContactSortOrder = .none) -> [CNContact]? {
        guard isAuthorized else {
            return nil
        }

        let contactStore = CNContactStore()
        var contacts: [CNContact] = [CNContact]()
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        request.sortOrder = sortOrder

        do {
            try contactStore.enumerateContacts(with: request, usingBlock: { (contact, _) in
                contacts.append(contact)
            })
            return contacts
        } catch let error as NSError {
            debugPrint(error)
            return nil
        }
    }

    public static func formatContacts(_ contacts: [CNContact]) -> [[String: String]]? {
        guard !contacts.isEmpty else {
            return nil
        }

        var contactInfoArray = [[String: String]()]

        for contact in contacts {
            let name = "\(contact.familyName)" + "\(contact.givenName)"
            var telephone = ""

            for phoneNumber in contact.phoneNumbers {
                let phoneNumberString = phoneNumber.value.stringValue
                    .components(separatedBy: CharacterSet.decimalDigits.inverted)
                    .joined(separator: "")
                let isValidNumber = NSPredicate(format: "SELE MATCHES ^1\\d{10}$")
                    .evaluate(with: phoneNumberString)
                if isValidNumber {
                    telephone = phoneNumberString
                    break
                }
            }
            contactInfoArray.append(["name": name, "telephone": telephone])
        }

        return contactInfoArray
    }

}
