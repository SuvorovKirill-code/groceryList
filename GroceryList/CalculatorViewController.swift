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
            let result = evaluateExpression(text ?? "0")
            totalLabel.text = "Total: \(result)"
        }
    }
    
    @IBOutlet weak var typingField: UITextView!
    @IBOutlet weak var totalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        text = typingField.text
        
    }
    
    // MARK: Buttons
    
    @IBAction func digitsAction(_ sender: UIButton) {
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
        text = typingField.text
        let expression = text!
        let result = evaluateExpression(expression)
            totalLabel.text = "Total: \(result)"
    }
    
    func evaluateExpression(_ expression: String) -> Double {
        
        // Удаляем пробелы из строки
        var sanitizedExpression = expression.replacingOccurrences(of: " ", with: "")
        
        if sanitizedExpression.isEmpty {
            typingField.text = "0"
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
        
        // Разбиваем строку на числа и операторы
        var components = [String]()
        var currentNumber = ""
        for char in sanitizedExpression {
            if char.isNumber || char == "." {
                currentNumber.append(char)
            } else {
                if !currentNumber.isEmpty {
                    guard let num = Double(currentNumber) else { return 0.0}
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
        
        // Выполняем операции умножения и деления сначала
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
        
        // Выполняем операции сложения и вычитания
        
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
        
        if let finalResult = Double(components.first!) {
            return finalResult
        } else {
            return 0.0
        }
    }
}
