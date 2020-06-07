//
//  ContactCell.swift
//  Contacts
//
//  Created by Aleksei Chupriienko on 05.06.2020.
//  Copyright © 2020 Aleksei Chupriienko. All rights reserved.
//

import UIKit
import CoreData

class ContactCell: UITableViewCell {
    
    
    // MARK: - Public Properties
    
    var controller: UIViewController!
    var tableView: UITableView!
    var indexPath: IndexPath!
    var contact: Contact!
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    // MARK: - IBActions
    
    @IBAction func deleteButton(_ sender: Any) {
        let alertVC = UIAlertController(title: "Do you want to delete this contact?", message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (UIAlertAction) in
            CoreDataStack.instance.managedContext.delete(self.contact)
            CoreDataStack.instance.saveContext()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(deleteAction)
        alertVC.addAction(cancelAction)
        controller.present(alertVC, animated: true, completion: nil)
    }
    
}
