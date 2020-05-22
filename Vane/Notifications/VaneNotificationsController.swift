//
//  VaneNotificationsController.swift
//  Vane
//
//  Created by Andrey Antosha on 22/05/2020.
//  Copyright © 2020 Andrey Antosha. All rights reserved.
//

import Foundation

class VaneNotificationsController {

    static let instance = VaneNotificationsController()
    
    private let numberOfDays = 7

    private init() { }

    func scheduleNotifications(for habit: Habit) {
        deleteNotifications(for: habit)
        
        guard let time = habit.reminderTime.value else { return }
        
        for offset in 0...numberOfDays {
            let date = Date().addingTimeInterval(3600 * 24 * Double(offset))
            
            if habit.weekdays.contains(date.generalComponents().weekday ?? -1) {
                let reminderDate = date.startOfDay.addingTimeInterval(time)
                
                let content = NotificationContent(title: "Habit Reminder",
                                                  body: habit.title,
                                                  sound: .default)
                NotificationManager.shared.addCustomNotification(id: habit.id + "_\(offset)", content: content, date: reminderDate)
            }
        }
    }
    
    func deleteNotifications(for habit: Habit) {
        var idsToRemove = [String]()
        
        for index in 0...numberOfDays {
            idsToRemove.append(habit.id + "_\(index)")
        }

        NotificationManager.shared.removeCustomNotifications(ids: idsToRemove)
    }
}
