//
//  ViewController.swift
//  myCalculator
//
//  Created by Valentin Caure on 19/01/2023.
//

import UIKit

class ViewController: UIViewController {
    
    let origin_number_label_size = 70
    
    let origin_memory_label_size = 40
    
    var memory = ""
    
    var number = "0"
    
    var old_number = ""
    
    var old_operator = ""
    
    var selected_operator = ""
    
    var choosen_operator = ""

    var is_displaying_a_result = false
    
    @IBOutlet var top_view: UIView!

    @IBOutlet var memory_label: UILabel!
    
    @IBOutlet var number_label: UILabel!
        
    @IBOutlet var reset_button: UIButton!

    @IBOutlet var operator_buttons: [UIButton]!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    fileprivate func separateNumbers(_ str: String) -> String {
        var is_neg = false
        var editable_str = str
        var dest_str = ""

        if (str.first == "-") {
            is_neg = true
            editable_str.removeFirst()
        }
        for (i, nbr) in editable_str.reversed().enumerated() {
            if ((i) % 3 == 0) {
                dest_str = "\(nbr) \(dest_str)"
            } else {
                dest_str = "\(nbr)\(dest_str)"
            }
        }
        if (is_neg) {
            dest_str = "-\(dest_str)"
        }
        return dest_str
    }
    
    fileprivate func fitLabelInView(label: UILabel, view: UIView) {
        label.sizeToFit()
        while label.frame.width > view.frame.width - 20 {
            label.font = label.font.withSize(label.font.pointSize - 5)
            label.sizeToFit()
        }
    }

    fileprivate func updateUI() {
        number_label.font = number_label.font.withSize(CGFloat(origin_number_label_size))
        memory_label.font = number_label.font.withSize(CGFloat(origin_memory_label_size))
        memory_label.text = "\(separateNumbers(memory))"
        memory_label.text! += (memory != "" && selected_operator != "") ? " \(selected_operator)" : ""
        memory_label.text! += (memory != "" && choosen_operator != "") ? " \(choosen_operator)" : ""
        if (is_displaying_a_result) {
            memory_label.text! = "\(separateNumbers(memory)) \(old_operator) \(separateNumbers(old_number)) ="
        }
        number_label.text = separateNumbers(number)
        fitLabelInView(label: memory_label, view: top_view)
        fitLabelInView(label: number_label, view: top_view)
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
        if (a == "Error" || b == "Error") {
            return "Error"
        }
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
            if (nb2 == 0) {
                result = "Error"
            } else {
                result = String(nb1 / nb2).replacingOccurrences(of: ".", with: ",")
            }
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
    @IBAction func onLeftSwipe(_ sender: UIPanGestureRecognizer) {
        if (sender.velocity(in: top_view).x < -25 && sender.state == .ended) {
            number.removeLast()
            if (number == "") {
                number = "0"
            }
            updateUI()
        }
    }
    
}

