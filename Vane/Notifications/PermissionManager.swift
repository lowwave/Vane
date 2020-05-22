//
//  PermissionManager.swift
//  Vane
//
//  Created by Andrey Antosha on 22/05/2020.
//  Copyright © 2020 Andrey Antosha. All rights reserved.
//

import Foundation
import UserNotifications
import UserNotificationsUI

public typealias PermissionRequestCompletion = (Bool) -> Void
public typealias PermissionStatusCompletion = (PermissionStatus) -> Void

public enum PermissionType: String {
    case notifications
}

public enum PermissionStatus: String {
    case granted
    case denied
    case undetermined

    @available(iOS 10.0, *)
    static func parse(_ status: UNAuthorizationStatus) -> PermissionStatus {
        switch status {
        case .authorized, .provisional:
            return .granted
        case .denied:
            return .denied
        default:
            return .undetermined
        }
    }
}

public class PermissionManager {

    public static func check(_ type: PermissionType, completion: @escaping PermissionRequestCompletion) {
        permissionStatus(type) { status in
            completion(status == .granted)
        }
    }

    public static func permissionStatus(_ type: PermissionType, completion: @escaping PermissionStatusCompletion) {
        switch type {
        case .notifications:
            if #available(iOS 10.0, *) {
                UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                    let status = PermissionStatus.parse(settings.authorizationStatus)
                    completion(status)
                }
            } else {
                // Fallback on earlier versions
                let notificationType = UIApplication.shared.currentUserNotificationSettings?.types
                if notificationType == [] {
                    completion(.undetermined)
                } else {
                    completion(.granted)
                }
            }
        }

    }

    public static func request(_ type: PermissionType, completion: @escaping PermissionRequestCompletion) {
        switch type {
        case .notifications:
            if #available(iOS 10.0, *) {
                let current = UNUserNotificationCenter.current()
                current.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                    completion(granted)
                }
            } else {
                let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
                UIApplication.shared.registerUserNotificationSettings(settings)
                UIApplication.shared.registerForRemoteNotifications()
                completion(true)
            }
        }
    }

}
