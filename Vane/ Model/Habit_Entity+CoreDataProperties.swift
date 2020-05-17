//
//  Habit_Entity+CoreDataProperties.swift
//  Vane
//
//  Created by Andrew on 17/05/2020.
//  Copyright © 2020 Andrey Antosha. All rights reserved.
//
//

import Foundation
import CoreData


extension Habit_Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Habit_Entity> {
        return NSFetchRequest<Habit_Entity>(entityName: "Habit_Entity")
    }

    @NSManaged public var title: String?

}
