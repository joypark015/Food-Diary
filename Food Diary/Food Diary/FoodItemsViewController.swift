//
//  FoodItemsViewController.swift
//  Food Diary
//
//  Created by Park, Joy (MU-Student) on 5/8/19.
//  Copyright © 2019 Park. All rights reserved.
//

import UIKit
import CoreData

class FoodItemsViewController: UIViewController {
    
    @IBOutlet weak var foodsTableView: UITableView!
    
    let dateFormatter = DateFormatter()
    
    var foods = [Food]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodsTableView.dataSource = self
        foodsTableView.delegate = self

        dateFormatter.timeStyle = .long
        dateFormatter.dateStyle = .long
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Food> = Food.fetchRequest()
        
        do {
            foods = try managedContext.fetch(fetchRequest)
            
            foodsTableView.reloadData()
        } catch {
            print("fetch could not be performed")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addNewFood(_ sender: Any) {
        performSegue(withIdentifier: "showFood", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? SingleItemViewController,
            let selectedRow = self.foodsTableView.indexPathForSelectedRow?.row else {
                return
        }
        
        destination.existingFood = foods[selectedRow]
    }
    
    func deleteFood(at indexPath: IndexPath) {
        let food = foods[indexPath.row]
        
        if let managedContext = food.managedObjectContext {
            managedContext.delete(food)
            
            do {
                try managedContext.save()
                
                self.foods.remove(at: indexPath.row)
                
                foodsTableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                print("delete failed")
                
                foodsTableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
}

extension FoodItemsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = foodsTableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath)
        let food = foods[indexPath.row]
        
        cell.textLabel?.text = food.name
        
        if let date = food.date {
            cell.detailTextLabel?.text = dateFormatter.string(from: date)
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteFood(at: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showFood", sender: self)
    }
}
