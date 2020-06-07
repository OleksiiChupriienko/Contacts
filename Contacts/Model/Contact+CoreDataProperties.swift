//
//  Contact+CoreDataProperties.swift
//  Contacts
//
//  Created by Aleksei Chupriienko on 05.06.2020.
//  Copyright © 2020 Aleksei Chupriienko. All rights reserved.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var email: String?
    @NSManaged public var photoData: Data?

}
