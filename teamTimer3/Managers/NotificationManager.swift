//
//  Notification.swift
//  teamTimer3
//
//  Created by Игорь Корабельников on 05.04.2020.
//  Copyright © 2020 Игорь Корабельников. All rights reserved.
//

import UIKit

class NotificationManager {
    
   func scheduleNotifications(inSeconds seconds : Date) {
       let date = seconds
       let notificationContent = UNMutableNotificationContent()
       notificationContent.body = "Ваш чай готов, доставайте пакетик!"
       notificationContent.sound = UNNotificationSound.default
       let calendar = Calendar.current
       let components = calendar.dateComponents([.month,.day,.hour,.minute,.second], from: date)
       let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
       let request = UNNotificationRequest(identifier: "YourTeaIsReady", content: notificationContent, trigger: trigger)
       let center = UNUserNotificationCenter.current()
       center.add(request, withCompletionHandler: nil)
   }
}
