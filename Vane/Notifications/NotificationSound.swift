//
//  NotificationSound.swift
//  Vane
//
//  Created by Andrey Antosha on 22/05/2020.
//  Copyright © 2020 Andrey Antosha. All rights reserved.
//

import Foundation
import UserNotifications

public enum NotificationSoundBundle: Int {
    case none
    case `default`

    public var soundsCount: Int {
        switch self {
        case .none:
            return 1
        case .default:
            return 0
        }
    }
}

public enum NotificationSound {
    case none
    case `default`
    case customTone

    public var title: String {
        return ""
    }

    public var fileName: String {
        return "custom_reminder_1"
    }

    var values: (bundle: Int, sound: Int) {
        return (0, 0)
    }

    var object: UNNotificationSound {
        let name = UNNotificationSoundName(rawValue: self.fileName + ".wav")
        return UNNotificationSound(named: name)
    }
}
