//
//  HabitEntity+CoreDataProperties.swift
//  Vane
//
//  Created by Andrew on 16/05/2020.
//  Copyright © 2020 Andrey Antosha. All rights reserved.
//
//

import Foundation
import CoreData


extension HabitEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HabitEntity> {
        return NSFetchRequest<HabitEntity>(entityName: "HabitEntity")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String

}
