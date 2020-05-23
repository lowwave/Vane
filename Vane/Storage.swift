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
    
    public func fetchCompletedHabitsByDate(date: String) -> [CompletedHabit] {
        // day in format dd.MM.yyyy
        let objects = realm.objects(CompletedHabit.self).filter("day = '\(date)'")
        return Array(objects).compactMap({ CompletedHabit(value: $0) })
    }
    
    
    public func saveCompletedHabit(completedHabit: CompletedHabit) {
        try! realm.write {
            realm.add(completedHabit, update: .modified)
        }
    }
    
    public func removeCompletedHabitByHabitId(habitId: String) {
        guard let realm = self.realm else { return }
        let objects = realm.objects(CompletedHabit.self)
        guard let objectToDelete = objects.filter("habitId = '\(habitId)'").first else { return }
        try! realm.write {
            realm.delete(objectToDelete)
        }
    }
}
