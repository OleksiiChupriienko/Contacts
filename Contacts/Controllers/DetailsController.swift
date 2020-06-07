//
//  DetailsController.swift
//  Contacts
//
//  Created by Aleksei Chupriienko on 06.06.2020.
//  Copyright © 2020 Aleksei Chupriienko. All rights reserved.
//

import UIKit

class DetailsController: UITableViewController {
    
    // MARK: - Public Properties
    
    var backButton: UIBarButtonItem!
    var saveButton: UIBarButtonItem!
    var cancelButton: UIBarButtonItem!
    var contact: Contact?
    var firstName: String {
        get {
            nameTextField.text ?? "undefined"
        }
        set {
            nameTextField.text = newValue
        }
    }
    var lastName: String {
        get {
            lastNameTextField.text ?? ""
        }
        set {
            lastNameTextField.text = newValue
        }
    }
    var email: String {
        get {
            emailTextField.text ?? ""
        }
        set {
            emailTextField.text = newValue
        }
    }

    //MARK: - IBOutlets
    
    @IBOutlet weak var contactPhoto: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButtons()
        setUpView()
    }
    
    //MARK: - Private Methods
    
    private func setUpView() {
        guard let photoData = contact?.photoData else {
            return
        }
        contactPhoto.image = UIImage(data: photoData)
        contactPhoto.layer.cornerRadius = contactPhoto.bounds.width / 2
        nameTextField.text = contact?.firstName
        lastNameTextField.text = contact?.lastName
        emailTextField.text = contact?.email
        tableView.tableFooterView = UIView()
    }
    
    private func setUpButtons() {
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        self.backButton = navigationItem.leftBarButtonItem
        self.cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
    }
    
    @objc private func save() {
        contact?.setValue(firstName, forKey: "firstName")
        contact?.setValue(lastName, forKey: "lastName")
        contact?.setValue(email, forKey: "email")
        CoreDataStack.instance.saveContext()
        self.setEditing(false, animated: true)
        tableView.reloadData()
    }
    
    @objc private func cancel() {
        self.setEditing(false, animated: true)
        nameTextField.text = contact?.firstName
        lastNameTextField.text = contact?.lastName
        emailTextField.text = contact?.email
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return false
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .none
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        nameTextField.isEnabled = editing ? true : false
        if nameTextField.isEnabled {
            nameTextField.becomeFirstResponder()
        }
        lastNameTextField.isEnabled = editing ? true : false
        emailTextField.isEnabled = editing ? true : false
        self.navigationItem.leftBarButtonItem = editing ? cancelButton : backButton
        self.navigationItem.rightBarButtonItem = editing ? saveButton : editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        false
    }
    
}


