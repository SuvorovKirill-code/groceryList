//
//  ViewController.swift
//  GroceryList
//
//  Created by Кирилл Суворов on 08.07.2024.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var calculatorTextField = "0"
    
    @IBOutlet weak var tableView: UITableView!
    var items = [ItemModel]()
    
    @IBOutlet weak var amountLabel: UILabel!
    
    func amountCount() -> Double {
        var amount:Double = 0
        for item in 0..<items.count {
            amount += items[item].price ?? 0
        }
        return amount
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountLabel.text = "Amount: \(amountCount())$"
    }
    
    // MARK: Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomTableViewCell
        cell.itemLabel.text = items[indexPath.row].name
        cell.priceLabel.text = "\(items[indexPath.row].price ?? 0) $"
        return cell
    }
    
    //MARK: Setup Transitions
    @IBAction func unwindSegueFromNewItemVC(_ segue: UIStoryboardSegue){
        guard let newItemVC = segue.source as? NewItemViewController else { return }
        newItemVC.saveItem()
        items.append(newItemVC.item!)
        tableView.reloadData()
        amountLabel.text = "Amount: \(amountCount())$"
    }
    
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

