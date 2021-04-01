//
//  UsersViewModel.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 31/03/2021.
//

import Foundation
import RxSwift
import RxCocoa

class UsersViewModel{
    let userWs = UserServices()
    let disposeBag = DisposeBag()
    let progressUtils = ProgressUtils()
    let notificationLocalizable = NotificationLocalizableUtils.shared
    
    let currentUser = PublishSubject<UserDto>()
    
    func login(email: String, password: String) -> Observable<UserDto>{
        return userWs.login(email: email, password: password)
    }
    
    func responseHandle(status: StatusInsert) {
        self.progressUtils.dismiss()
        var redirect = false
        switch status {
            case .UNREACHABLE:
                NotificationsUtils.shared.showFloatingNotificationBanner(title: notificationLocalizable.unreachableNotificationTitle, subtitle: notificationLocalizable.unreachableNotificationSubtitle, position: .top, style: .danger)
                redirect = true
            case .OK:
                NotificationsUtils.shared.showFloatingNotificationBanner(title: notificationLocalizable.okNotificationTitle, subtitle: notificationLocalizable.okNotificationSubtitle, position: .top, style: .success)
                redirect = true
            case .KOAPI:
                NotificationsUtils.shared.showFloatingNotificationBanner(title: notificationLocalizable.koApiNotificationTitle, subtitle: notificationLocalizable.koApiNotificationSubtitle, position: .top, style: .danger)
                redirect = true
            case .KO:
                NotificationsUtils.shared.showFloatingNotificationBanner(title: notificationLocalizable.koNotificationTitle, subtitle: notificationLocalizable.koNotificationSubtitle, position: .top, style: .danger)
                redirect = false
        }
        if redirect {
            self.redirect()
        }
    }
    
    func redirect(){
    }
}

enum StatusInsert {
    case OK
    case KO
    case KOAPI
    case UNREACHABLE
}
