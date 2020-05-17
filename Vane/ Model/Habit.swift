//
//  Habit.swift
//  Vane
//
//  Created by Andrey Antosha on 10/04/2020.
//  Copyright © 2020 Andrey Antosha. All rights reserved.
//

import Foundation
import CoreData

@objc(Habit)
class Habit : NSManagedObject {

}

extension Habit {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Habit> {
        return NSFetchRequest<Habit>(entityName: "Habit")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String
    @NSManaged public var icon: String
    @NSManaged public var isCompleted: Bool

}
