//
//  NotificationObject.swift
//  Vane
//
//  Created by Andrey Antosha on 22/05/2020.
//  Copyright © 2020 Andrey Antosha. All rights reserved.
//

import Foundation
import UserNotifications

public struct NotificationObject {
    public let identifier: String
    public let content: NotificationContent
    public let trigger: UNNotificationTrigger

    func asNotificationRequest() -> UNNotificationRequest {
        return UNNotificationRequest(identifier: identifier,
                                     content: content.asObject(),
                                     trigger: trigger)
    }

    static func makeMany(content: NotificationContent,
                         ids: [String],
                         triggers: [UNNotificationTrigger?]) -> [NotificationObject] {
        guard ids.count >= triggers.count else {
            assertionFailure("Wrong data")
            return []
        }

        var notifications = [NotificationObject]()

        for index in 0..<triggers.count {
            guard let trigger = triggers[index] else { continue }
            let newObject = NotificationObject(identifier: ids[index],
                                               content: content,
                                               trigger: trigger)
            notifications.append(newObject)
        }

        return notifications
    }

}
