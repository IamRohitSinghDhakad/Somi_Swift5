//
//  PhoneContacts.swift
//  Bang
//
//  Created by RohitSingh-MacMINI on 20/05/19.
//  Copyright © 2019 mindiii. All rights reserved.
//

import UIKit
import Foundation
import ContactsUI

class PhoneContacts {    
    class func getContacts(filter: ContactsFilter = .none) -> [CNContact] { //  ContactsFilter is Enum find it below
        
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactThumbnailImageDataKey] as [Any]
        
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            debugPrint("Error Fetching Contact")
            //Debug.Log(message: "Error fetching containers") // you can use print()
        }
        
        var results: [CNContact] = []
        
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
            } catch {
                debugPrint("Error Fetching Contact")
                //Debug.Log(message: "Error fetching containers")
            }
        }
        return results
    }
    
}
