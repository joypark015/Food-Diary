//
//  SingleItemViewController.swift
//  Food Diary
//
//  Created by Park, Joy (MU-Student) on 5/8/19.
//  Copyright © 2019 Park. All rights reserved.
//

import UIKit

class SingleItemViewController: UIViewController {
    var dataSource = ["Breakfast", "Lunch", "Dinner", "Snack"]
    
    var existingFood: Food?
    
    @IBOutlet weak var nameTextField: UITextField!
    //@IBOutlet weak var mealLabel: UILabel!
    @IBOutlet weak var mealPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var servingTextField: UITextField!
    
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        nameTextField.delegate = self
        servingTextField.delegate = self
        
        nameTextField.text = existingFood?.name
        
        if let serving = existingFood?.serving {
            servingTextField.text = "\(serving)"
        }
        
        if let date = existingFood?.date {
            datePicker.date = date
        }
        
        mealPicker.dataSource = self
        mealPicker.delegate = self
        //mealLabel.text = dataSource[index]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
        
    @IBAction func saveFood(_ sender: Any) {
        let name = nameTextField.text
        let meal = dataSource[index]
        let date = datePicker.date
        let servingText = servingTextField.text ?? ""
        let serving = Double(servingText) ?? 0.0
        
        var food: Food?
        
        if let existingFood = existingFood {
            existingFood.name = name
            existingFood.meal = meal
            existingFood.date = date
            existingFood.serving = serving
            
            food = existingFood
        } else {
            food = Food(name: name, meal: meal, date: date, serving: serving)
        }
        
        if let food = food {
            do {
                let managedContext = food.managedObjectContext
                
                try managedContext?.save()
                
                self.navigationController?.popViewController(animated: true)
            } catch {
                print("context could not be saved")
            }
        }
    }
}
    
    extension SingleItemViewController: UITextFieldDelegate {
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    }

    extension SingleItemViewController: UIPickerViewDelegate, UIPickerViewDataSource {
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return dataSource.count
        }

//        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//            //mealLabel.text = dataSource[row]
//        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return dataSource[row]
        }
    }
