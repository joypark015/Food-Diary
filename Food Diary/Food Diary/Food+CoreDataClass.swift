//
//  Food+CoreDataClass.swift
//  Food Diary
//
//  Created by Park, Joy (MU-Student) on 5/8/19.
//  Copyright © 2019 Park. All rights reserved.
//
//

import UIKit
import CoreData

@objc(Food)
public class Food: NSManagedObject {
    var date: Date? {
        get {
            return rawDate as Date?
        } set {
            rawDate = newValue as NSDate?
        }
    }
    
    convenience init?(name: String?, meal: String?, date: Date?, serving: Double) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {
            return nil
        }
        
        self.init(entity: Food.entity(), insertInto: managedContext)
        
        self.name = name
        self.meal = meal
        self.date = date
        self.serving = serving
    }
}
