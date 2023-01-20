//
//  ViewController.swift
//  myCalculator
//
//  Created by Valentin Caure on 19/01/2023.
//

import UIKit

class ViewController: UIViewController {
    
    var memory = ""
    
    var number = "0"
    
    var old_number = ""
    
    var old_operator = ""
    
    var selected_operator = ""
    
    var choosen_operator = ""

    var is_displaying_a_result = false
    
    @IBOutlet var memory_label: UILabel!
    
    @IBOutlet var number_label: UILabel!
        
    @IBOutlet var reset_button: UIButton!

    @IBOutlet var operator_buttons: [UIButton]!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    fileprivate func updateUI() {
        memory_label.text = "\(memory)"
        memory_label.text! += (memory != "" && selected_operator != "") ? " \(selected_operator)" : ""
        memory_label.text! += (memory != "" && choosen_operator != "") ? " \(choosen_operator)" : ""
        if (is_displaying_a_result) {
            memory_label.text! = "\(memory) \(old_operator) \(old_number) ="
        }
        number_label.text = number
        if (number != "0") {
            reset_button.configuration!.title! = "C"
        } else {
            reset_button.configuration!.title! = "AC"
        }
        for button in operator_buttons {
            button.backgroundColor = .systemRed
            if (button.configuration!.title! == selected_operator) {
                button.backgroundColor = .systemOrange
            }
        }
    }
    
    @IBAction func onChangeSignButton(_ sender: UIButton) {
        if (number.first! == "-") {
            number.removeFirst()
        } else {
            number.insert("-", at: number.startIndex)
        }
        updateUI()
    }
    @IBAction func onPercentageButton(_ sender: UIButton) {
        let nb1 = Double(number.replacingOccurrences(of: ",", with: "."))!
        number = String(nb1 / 100)
        updateUI()
    }
    
    @IBAction func onOperationButtonPressed(_ sender: UIButton) {
        if (memory != "") {
            number = computeResult(memory, choosen_operator, number)
            choosen_operator = ""
        }
        selected_operator = sender.configuration!.title!
        memory = number
        number = "0"
        updateUI()
    }
    
    fileprivate func computeResult(_ a: String, _ op: String, _ b: String) -> String {
        let nb1 = Double(a.replacingOccurrences(of: ",", with: "."))!
        let nb2 = Double(b.replacingOccurrences(of: ",", with: "."))!
        var result = ""

        switch op {
        case "+":
            result = String(nb1 + nb2).replacingOccurrences(of: ".", with: ",")
            break
        case "-":
            result = String(nb1 - nb2).replacingOccurrences(of: ".", with: ",")
            break
        case "x":
            result = String(nb1 * nb2).replacingOccurrences(of: ".", with: ",")
            break
        case "/":
            result = String(nb1 / nb2).replacingOccurrences(of: ".", with: ",")
            break
        default:
            break
        }
        while ((result.last == "0" || result.last == ",") && result.contains(",")) {
            result.removeLast()
        }
        return result
    }
    
    @IBAction func onEqualButtonPressed(_ sender: UIButton) {
        var result = ""

        if (memory == "" && old_number == "") {
            return
        }
        if (old_number != "") {
            result = computeResult(number, old_operator, old_number)
            memory = number
        } else {
            result = computeResult(memory, choosen_operator, number)
            old_number = number
            old_operator = choosen_operator
            choosen_operator = ""
        }
        number = result
        is_displaying_a_result = true
        updateUI()
    }
    
    @IBAction func onResetButtonPressed(_ sender: UIButton) {
        if (number == "0" || is_displaying_a_result) {
            memory = ""
            selected_operator = ""
        }
        is_displaying_a_result = false
        number = "0"
        updateUI()
    }
    
    @IBAction func onNumberButtonPress(_ sender: UIButton) {
        if (is_displaying_a_result) {
            number = "0"
            memory = ""
        }
        is_displaying_a_result = false
        old_number = ""
        old_operator = ""
        if (selected_operator != "") {
            choosen_operator = selected_operator
            selected_operator = ""
        }
        if (number == "0" && sender.configuration!.title! != ",") {
            number = ""
        } else if (number == "-0" && sender.configuration!.title! != ",") {
            number = "-"
        }
        if (sender.configuration!.title! != "," || !number.contains(",")) {
            number += sender.configuration!.title!
        }
        updateUI()
    }
    
}

