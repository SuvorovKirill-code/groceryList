//
//  ViewController.swift
//  GroceryList
//
//  Created by Кирилл Суворов on 08.07.2024.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var calculatorTextField = "0"
    var items: Results<Item>!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var amountLabel: UILabel!
    
    func amountCount() -> Double {
        var amount:Double = 0
        for item in 0..<items.count {
            amount += items[item].price
        }
        return amount
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = realm.objects(Item.self)
        amountLabel.text = "Amount: \(amountCount())$"
    }
    
    // MARK: Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomTableViewCell
        cell.itemLabel.text = items[indexPath.row].name
        cell.priceLabel.text = "\(items[indexPath.row].price) $"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CustomTableViewCell {
            
            // Check and set the attributed text for itemLabel
            if let itemLabel = cell.itemLabel, let nameText = itemLabel.text {
                let attributeNameString: NSMutableAttributedString
                if let attributedNameText = itemLabel.attributedText,
                   attributedNameText.attribute(.strikethroughStyle, at: 0, effectiveRange: nil) != nil {
                    // Убираем перечеркивание
                    attributeNameString = NSMutableAttributedString(string: nameText)
                } else {
                    // Добавляем перечеркивание
                    attributeNameString = NSMutableAttributedString(string: nameText)
                    attributeNameString.addAttribute(.strikethroughStyle,
                                                     value: NSUnderlineStyle.single.rawValue,
                                                     range: NSMakeRange(0, attributeNameString.length))
                }
                itemLabel.attributedText = attributeNameString
            }

            // Check and set attributed text for priceLabel
            if let priceLabel = cell.priceLabel, let priceText = priceLabel.text {
                let attributePriceString: NSMutableAttributedString
                if let attributedPriceText = priceLabel.attributedText,
                   attributedPriceText.attribute(.strikethroughStyle, at: 0, effectiveRange: nil) != nil {
                    // Убираем перечеркивание
                    attributePriceString = NSMutableAttributedString(string: priceText)
                } else {
                    // Добавляем перечеркивание
                    attributePriceString = NSMutableAttributedString(string: priceText)
                    attributePriceString.addAttribute(.strikethroughStyle,
                                                      value: NSUnderlineStyle.single.rawValue,
                                                      range: NSMakeRange(0, attributePriceString.length))
                }
                priceLabel.attributedText = attributePriceString
            }
        }

        // Deselecting a cell after pressing
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let item = items[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completionHandler) in
            StorageManager.deleteObject(item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.amountLabel.text = "Amount: \(self.amountCount())$"
            completionHandler(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    @IBAction func addButtonAction(_ sender: UIBarButtonItem) {
        showAlert()
    }
    
    func showAlert() {
        
        let item = Item()
        
        let alertController = UIAlertController(title: "Add new item", message: "Type item name and price", preferredStyle: .alert)
        
        alertController.addTextField { nameTF in
            nameTF.placeholder = "Name"
        }
        
        alertController.addTextField { priceTF in
            priceTF.placeholder = "Price"
            priceTF.keyboardType = .decimalPad
        }
        
        let alertAddAction = UIAlertAction(title: "Add", style: .default) { _ in
            let name = alertController.textFields![0].text
            item.name = name == "" ? "Nothing" : name!
            let price = alertController.textFields![1].text
            item.price = Double(price ?? "0") ?? 0
            StorageManager.saveObject(item)
            self.tableView.reloadData()
            self.amountLabel.text = "Amount: \(self.amountCount())$"
        }
        let alertCancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(alertAddAction)
        alertController.addAction(alertCancelAction)
        
        present(alertController, animated: true)
        
    }
    
    //MARK: Setup Transitions
    
    @IBAction func unwindSegueFromCalculatorVC(_ segue: UIStoryboardSegue){
        guard let calculatorVC = segue.source as? CalculatorViewController else { return }
        calculatorTextField = calculatorVC.typingField.text
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "calculator" {
            let calculatorVC = segue.destination as! CalculatorViewController
            calculatorVC.text = calculatorTextField
        }
    }
}

