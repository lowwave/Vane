//
//  Habit.swift
//  Vane
//
//  Created by Andrey Antosha on 10/04/2020.
//  Copyright © 2020 Andrey Antosha. All rights reserved.
//

import Foundation
import RealmSwift

class Habit: Object {
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var title: String!
    @objc dynamic var icon: String!
    @objc dynamic var isComplete: Bool = false
    @objc dynamic var colorIndex: Int = 0
    
    let reminderTime = RealmOptional<Double>()
    var weekdays = List<Int>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}


class CompletedHabit : Object {
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var day: String!
    @objc dynamic var habitId: String!
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
