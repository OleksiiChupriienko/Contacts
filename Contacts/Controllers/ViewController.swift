//
//  ViewController.swift
//  Contacts
//
//  Created by Aleksei Chupriienko on 05.06.2020.
//  Copyright © 2020 Aleksei Chupriienko. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    // MARK: - Public Properties
    
    let coreDataStack = CoreDataStack.instance
    lazy var fetchedResultsController:
        NSFetchedResultsController<Contact> = {
            let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
            let firstNameSortDescriptor = NSSortDescriptor(key: "firstName", ascending: true)
            let lastNameSortDescriptor = NSSortDescriptor(key: "lastName", ascending: true)
            fetchRequest.sortDescriptors = [lastNameSortDescriptor, firstNameSortDescriptor]
            let fetchedResultsController = NSFetchedResultsController(
                fetchRequest: fetchRequest,
                managedObjectContext: coreDataStack.managedContext,
                sectionNameKeyPath: nil,
                cacheName: nil)
            return fetchedResultsController
    }()
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var contactsTableView: UITableView!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultsController.delegate = self
        contactsTableView.dataSource = self
        contactsTableView.delegate = self
        insertSampleData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try? fetchedResultsController.performFetch()
        contactsTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let detailsVC = segue.destination as? DetailsController, let contact = sender as? Contact {
            detailsVC.contact = contact
        }
    }
    
    //MARK: - Private Methods
    
    private func insertSampleData() {
        let request: NSFetchRequest<Contact> = Contact.fetchRequest()
        let count = try! coreDataStack.managedContext.count(for: request)
        if count > 0 {
            return
        } else {
            insertData()
        }
    }
    
    private func insertData() {
        let path = Bundle.main.path(forResource: "SampleData", ofType: "plist")
        let dataArray = NSArray(contentsOfFile: path!)!
        for dict in dataArray {
            let contact = Contact(context: coreDataStack.managedContext)
            let contactDict = dict as! [String: Any]
            contact.firstName = contactDict["firstName"] as? String
            contact.lastName = contactDict["lastName"] as? String
            contact.email = contactDict["email"] as? String
            let photoName = contactDict["photoString"] as! String
            contact.photoData = UIImage(named: photoName)?.pngData()
        }
        coreDataStack.saveContext()
    }
    
    
    // MARK: - IBActions
    
    @IBAction func reloadDataButtonAction(_ sender: UIBarButtonItem) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Contact.fetchRequest()
        let context = coreDataStack.managedContext
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            context.reset()
            try fetchedResultsController.performFetch()
        } catch {
            let updateError = error as NSError
            print("\(updateError), \(updateError.userInfo)")
        }
        insertData()
        contactsTableView.reloadData()
    }
    
}

    //MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contact = fetchedResultsController.object(at: indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactCell else {
            return UITableViewCell()
        }
        cell.nameLabel.text = (contact.firstName ?? "") + " " + (contact.lastName ?? "")
        cell.controller = self
        cell.tableView = contactsTableView
        cell.indexPath = indexPath
        cell.contact = contact
        return cell
    }
    
}

    //MARK: - FetchedResultsControllerDelegate

extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        contactsTableView.beginUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        contactsTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .delete {
            if let indexPath = indexPath {
                contactsTableView.deleteRows(at: [indexPath], with: .bottom)
            }
        }
    }
    
}

    //MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let contact = fetchedResultsController.object(at: indexPath)
        performSegue(withIdentifier: "ShowDetails", sender: contact)
        print("\(indexPath.row)")
    }
    
    // Alternative way to delete contacts without button on each cell, by swiping cell from right to left
    /*
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let contact = fetchedResultsController.object(at: indexPath)
            coreDataStack.managedContext.delete(contact)
            coreDataStack.saveContext()
        }
    }
     */
    
}
