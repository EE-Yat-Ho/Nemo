//
//  TableViewCell.swift
//  Nemo
//
//  Created by 박영호 on 2020/11/20.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit
import UserNotifications
import Then

class NotificationManager {
    static let shared = NotificationManager()
    
    /// 알람 허락받기
    func getAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert], completionHandler: {didAllow,Error in
            if didAllow {
                UserDefaults.standard.setValue(true, forKey: "notiAuth")
            } else {
                UserDefaults.standard.setValue(false, forKey: "notiAuth")
            }
        })
    }
    
    func setNotiTime(hour: Int, minite: Int){
        UserDefaults.standard.setValue(hour, forKey: "notiHour")
        UserDefaults.standard.setValue(minite, forKey: "notiMinite")
    }
    
    let content = UNMutableNotificationContent().then {
        $0.body = "네모가 시험치기를 기다리고있어요."
    }

    //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
    var dateComponents = DateComponents()
    
    func synchNotiAuth() {
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { settings in
            switch settings.alertSetting {
            case .enabled:
                UserDefaults.standard.setValue(true, forKey: "notiAuth")
            default:
                UserDefaults.standard.setValue(false, forKey: "notiAuth")
            }
        })
    }
    
    func setNotification() {
        dateComponents.hour = UserDefaults.standard.integer(forKey: "notiHour")
        dateComponents.minute = UserDefaults.standard.integer(forKey: "notiMinite")
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "ComeBack!", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request,withCompletionHandler: nil)
    }
    
    func removeNotification(identifiers: [String]) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}
