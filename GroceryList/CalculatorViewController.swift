//
//  CalculatorViewController.swift
//  GroceryList
//
//  Created by Кирилл Суворов on 09.07.2024.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    var text: String? {
        didSet {
            let components = getComponents(text ?? "0")
            let result = String(format: "%.2f", evaluateExpression(components))
            totalLabel?.text = "Total: \(result)"
        }
    }
    
    @IBOutlet weak var typingField: UITextView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet var buttons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typingField.text = text
        for button in buttons {
            button.layer.cornerRadius = 20
        }
        let components = getComponents(text ?? "0")
        let result = String(format: "%.2f", evaluateExpression(components))
        totalLabel?.text = "Total: \(result)"
    }
    
    // MARK: Buttons
    
    @IBAction func digitsAction(_ sender: UIButton) {
        if typingField.text == "0"{
            typingField.text = ""
        }
        text = typingField.text
        typingField.text = text! + String(sender.tag)
        text = typingField.text
        
    }
    
    @IBAction func pointButton(_ sender: UIButton) {
        guard let typedText = typingField.text, !typedText.isEmpty else { return }
        if typedText.last!.isNumber {
            typingField.text = typingField.text + "."
        }
    }
    @IBAction func allClearAction(_ sender: UIButton) {
        typingField.text = ""
        totalLabel.text = "Total: "
    }
    
    @IBAction func clearAction(_ sender: UIButton) {
        var components = getComponents(typingField.text)
        components = components.dropLast()
        components = components.dropLast()
        let string = components.joined(separator: "")
        typingField.text = string
        text = typingField.text
    }
    
    @IBAction func percentButton(_ sender: UIButton) {
        var components = getComponents(typingField.text)
        var last = Double(components.last ?? "0") ?? 0
        last = last/100
        components = components.dropLast()
        components.append(String(last))
        let string = components.joined(separator: "")
        typingField.text = string
        text = typingField.text
    }
    
    @IBAction func plusAction(_ sender: UIButton) {
        guard let typedText = typingField.text, !typedText.isEmpty else { return }
        if typedText.last!.isNumber {
            typingField.text = typingField.text + "+"
        }
        
    }
    
    @IBAction func minusAction(_ sender: UIButton) {
        guard let typedText = typingField.text, !typedText.isEmpty else { return }
        if typedText.last!.isNumber {
            typingField.text = typingField.text + "-"
        }
    }
    
    @IBAction func multiplyAction(_ sender: UIButton) {
        guard let typedText = typingField.text, !typedText.isEmpty else { return }
        if typedText.last!.isNumber {
            typingField.text = typingField.text + "*"
        }
    }
    
    @IBAction func divideAction(_ sender: UIButton) {
        guard let typedText = typingField.text, !typedText.isEmpty else { return }
        if typedText.last!.isNumber {
            typingField.text = typingField.text + "/"
        }
    }
    
    @IBAction func totalButton(_ sender: UIButton) {
        let components = getComponents(text ?? "0")
        let result = String(format: "%.2f", evaluateExpression(components))
        totalLabel?.text = "Total: \(result)"
    }
    
    func getComponents(_ expression: String) -> [String] {
        
        // Remove spaces from the string
        var sanitizedExpression = expression.replacingOccurrences(of: " ", with: "")
        
        if sanitizedExpression.isEmpty {
            typingField?.text = "0"
            sanitizedExpression = "0"
        }
        
        if !sanitizedExpression.first!.isNumber {
            sanitizedExpression.removeFirst()
            sanitizedExpression = "0"
            typingField.text = sanitizedExpression
        }
        
        if !sanitizedExpression.last!.isNumber {
            sanitizedExpression.removeLast()
        }
        
        // Split the string into numbers and operators
        var components = [String]()
        var currentNumber = ""
        for char in sanitizedExpression {
            if char.isNumber || char == "." {
                currentNumber.append(char)
            } else {
                if !currentNumber.isEmpty {
                    guard let num = Double(currentNumber) else { return ["0"] }
                    components.append(String(num))
                    currentNumber = ""
                }
                components.append(String(char))
            }
        }
        
        if !currentNumber.isEmpty {
            components.append(currentNumber)
        } else {
            components.append("0")
        }
        
        return components
    }
    
    func evaluateExpression(_ array: [String]) -> Double {
        
        var components = array
        
        // Perform multiplication and division operations first
        var index = 0
        while index < components.count {
            if components[index] == "*" || components[index] == "/" {
                guard let left = Double(components[index - 1]), let right = Double(components[index + 1]) else {return 0}
                
                let result: Double
                if components[index] == "*" {
                    result = left * right
                } else {
                    result = left / right
                }
                components[index - 1] = String(result)
                components.remove(at: index)
                components.remove(at: index)
                index -= 1
            }
            index += 1
        }
        
        // Perform addition and subtraction operations
        
        index = 0
        while index < components.count {
            if components[index] == "+" || components[index] == "-" {
                guard let left = Double(components[index - 1]), let right = Double(components[index + 1]) else {return 0}
                
                let result: Double
                if components[index] == "+" {
                    result = left + right
                } else {
                    result = left - right
                }
                components[index - 1] = String(result)
                components.remove(at: index)
                components.remove(at: index)
                index -= 1
            }
            index += 1
        }
        
        if let finalResult = Double(components.first ?? "0") {
            return finalResult
        } else {
            return 0.0
        }
    }
}
