//
//  NotificationsManager.swift
//  Vane
//
//  Created by Andrey Antosha on 22/05/2020.
//  Copyright © 2020 Andrey Antosha. All rights reserved.
//

import Foundation
import UserNotifications

public protocol NotificationsStorage {
    func addNotifications(notifications: [NotificationObject])
    func removeNotifications(ids: [String])
    func removeDeliveredNotifications(ids: [String])
}

public class NotificationManager: NSObject {

    public static var shared = NotificationManager(storage: UserNotificationStorage())

    private let storage: NotificationsStorage

    public init(storage: NotificationsStorage) {
        self.storage = storage
    }

    public func addCustomNotification(id: String, content: NotificationContent, date: Date) {
        let components = date.triggerComponents()
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let notification = NotificationObject(identifier: id, content: content, trigger: trigger)
        storage.removeNotifications(ids: [id])
        storage.addNotifications(notifications: [notification])
        print("Added notifications \(content.body) on \(DateFormatter.new(format: "y.MM.dd HH:mm:ss").string(from: date))")
    }

    public func removeCustomNotifications(ids: [String]) {
        storage.removeNotifications(ids: ids)
    }

}

extension Date {
    
    private static let gregorianCalendar = Calendar(identifier: .gregorian)
    
    public func triggerComponents() -> DateComponents {
        return Date.gregorianCalendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .timeZone], from: self)
    }
    
    public func generalComponents() -> DateComponents {
        let components = Date.gregorianCalendar.dateComponents(in: .current, from: self)

        var dateComponents = DateComponents()

        dateComponents.year = components.year
        dateComponents.weekday = components.weekday
        dateComponents.month = components.month
        dateComponents.day = components.day

        dateComponents.hour = components.hour
        dateComponents.minute = components.minute

        return dateComponents
    }
    
    public var startOfDay: Date {
        return Date.gregorianCalendar.startOfDay(for: self)
    }
}

public extension DateFormatter {

    static func new(format: String) -> DateFormatter {
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = format
//        newDateFormatter.locale = Locale(identifier: UserPreferences.shared.language)
        return newDateFormatter
    }
}
