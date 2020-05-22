//
//  NotificationContent.swift
//  Vane
//
//  Created by Andrey Antosha on 22/05/2020.
//  Copyright © 2020 Andrey Antosha. All rights reserved.
//

import Foundation
import UserNotifications

public struct NotificationContent {

    public let title: String
    public let body: String
    public let sound: NotificationSound
    public let info: [String: Any]
    public let threadID: String?

    public init(title: String, body: String, sound: NotificationSound, info: [String: Any], threadID: String?) {
        self.title = title
        self.body = body
        self.sound = sound
        self.info = info
        self.threadID = threadID
    }

    public init(title: String, body: String, sound: NotificationSound) {
        self.title = title
        self.body = body
        self.sound = sound
        self.info = [:]
        self.threadID = nil
    }

    func asObject() -> UNNotificationContent {
        let content = UNMutableNotificationContent()

        content.title = title
        content.body = body
        content.sound = sound.object
        content.userInfo = info

        if let threadID = threadID {
            content.threadIdentifier = threadID
        }

        return content
    }

}
