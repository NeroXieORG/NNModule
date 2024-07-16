//
//  ModuleNotificationSerice.swift
//  ModuleManager
//
//  Created by NeroXie on 2020/12/30.
//

import Foundation

/// Notification Service
@objc public protocol ModuleNotificationService: ModuleFunctionalService {
    
    /// Adds an entry to the notification center to receive notifications that passed to the provided block.
    /// - Parameters:
    ///   - name: The name of the notification to register for delivery to the observer block.
    ///   - isSticky: The tag of receiving sticky notification. When true, the block will be executed first if there is a sticky notification matches.
    ///   - object: The object that sends notifications to the observer block.
    ///   - queue: The operation queue where the block runs.
    ///   - block: The block that executes when receiving a notification.
    /// - Returns: An opaque object to act as the observer.
    func addObserver(forName name: NSNotification.Name?, isSticky: Bool, object: Any?, queue: OperationQueue?, using block: @escaping (Notification) -> Void) -> NotificationObserver
    
    func addObserver(forName name: NSNotification.Name?, using block: @escaping (Notification) -> Void) -> NotificationObserver
    
    func addObserver(forName name: NSNotification.Name?, isSticky: Bool, using block: @escaping (Notification) -> Void) -> NotificationObserver
    
    /// Creates a notification with a given name, sitcky tag, sender, and information and posts it to the notification center.
    /// - Parameters:
    ///   - name: The name of the notification.
    ///   - isSticky: The tag of saving sticky notification. When true, it will save the notification as the latest sticky notification.
    ///   - object: The object posting the notification.
    ///   - userInfo: A user info dictionary with optional information about the notification.
    func postNotification(for name: Notification.Name, isSticky: Bool, object: Any?, userInfo: [AnyHashable : Any]?)
    
    func postNotification(for name: Notification.Name)
    
    func postNotification(for name: Notification.Name, isSticky: Bool)
    
    /// Removes the sticky notification.
    /// - Parameter name: The name of the notification.
    func removeStickyNotification(for name: Notification.Name)
}



