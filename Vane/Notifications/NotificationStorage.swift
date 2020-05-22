//
//  NotificationStorage.swift
//  Vane
//
//  Created by Andrey Antosha on 22/05/2020.
//  Copyright © 2020 Andrey Antosha. All rights reserved.
//

import Foundation
import UserNotifications

class UserNotificationStorage: NotificationsStorage {

    func addNotifications(notifications: [NotificationObject]) {
        let center = UNUserNotificationCenter.current()
        notifications.forEach {
            center.add($0.asNotificationRequest()) { (error : Error?) in
                if let error = error {
                    print("Failed to create notification. Error: \(error.localizedDescription)")
                }
            }
        }
    }

    func removeNotifications(ids: [String]) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ids)
    }

    func removeDeliveredNotifications(ids: [String]) {
        let center = UNUserNotificationCenter.current()
        center.removeDeliveredNotifications(withIdentifiers: ids)
    }
}
