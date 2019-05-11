//
//  Food+CoreDataProperties.swift
//  Food Diary
//
//  Created by Park, Joy (MU-Student) on 5/8/19.
//  Copyright © 2019 Park. All rights reserved.
//
//

import Foundation
import CoreData


extension Food {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Food> {
        return NSFetchRequest<Food>(entityName: "Food")
    }

    @NSManaged public var name: String?
    @NSManaged public var meal: String?
    @NSManaged public var rawDate: NSDate?
    @NSManaged public var serving: Double
}
