//
//  Storage.swift
//  Vane
//
//  Created by Andrey Antosha on 17/05/2020.
//  Copyright © 2020 Andrey Antosha. All rights reserved.
//

import Foundation
import RealmSwift

final class Storage {
    
    public static let `default` =  Storage()
    
    private lazy var realm: Realm! = {
        let config = Realm.Configuration()
        return try! Realm(configuration: config)
    }()
    
    private init() {}
    
    public func fetchAllHabits() -> [Habit] {
        let habits = realm.objects(Habit.self)
        return Array(habits).compactMap({ Habit(value: $0) })
    }
    
    public func saveHabit(habit: Habit) {
        try! realm.write {
            realm.add(habit, update: .modified)
        }
    }
    
    public func removeHabit(habit: Habit) {
        guard let realm = self.realm else { return }
        let objects = realm.objects(Habit.self)
        guard let objectToDelete = objects.filter("id = '\(habit.id)'").first else { return }
        try! realm.write {
            realm.delete(objectToDelete)
        }
    }
}
