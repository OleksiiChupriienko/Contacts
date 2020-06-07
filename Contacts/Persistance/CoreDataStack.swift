//
//  CoreDataStack.swift
//  Contacts
//
//  Created by Aleksei Chupriienko on 05.06.2020.
//  Copyright © 2020 Aleksei Chupriienko. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    //MARK: - Private Properties
    
    private let modelName: String
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores {
            (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    // MARK: - Public Properties
    
    public static let instance = CoreDataStack(modelName: "Contacts")
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    private init(modelName: String) {
        self.modelName = modelName
    }
    
    // MARK: - Public Methods
    
    func saveContext () {
        guard managedContext.hasChanges else { return }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
}

