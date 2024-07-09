//
//  NewItemViewController.swift
//  GroceryList
//
//  Created by Кирилл Суворов on 08.07.2024.
//

import UIKit

class NewItemViewController: UITableViewController {
    
    var item: ItemModel?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemPrice: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.isEnabled = false
        
        itemName.addTarget(self, action: #selector(nameTFChanged), for: .editingChanged)
    }

    func saveItem(){
        item = ItemModel(name: itemName.text!, price: Double(itemPrice.text!))
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc private func nameTFChanged(){
        if itemName.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}
