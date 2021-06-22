//
//  NotificationUtils.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 01/04/2021.
//


import NotificationBannerSwift

class NotificationsUtils {
    
    static let shared = NotificationsUtils()
    
    let notificationLocalizatiton = NotificationLocalizableUtils.shared
    
    let notificationBannerQueue = NotificationBannerQueue()
    var banner: BaseNotificationBanner!
    let DURATION: Double = 0.2 //For fast banners

    
    func showBasicBanner(title: String, subtitle: String, position: BannerPosition, style: BannerStyle) {
        banner = setImageViewToBanner(type: "Simple", title: title, subtitle: subtitle, style: style)
        banner.onTap = {
            self.banner.dismiss()
        }
        banner.onSwipeUp = {
            self.banner.dismiss()
        }
        banner.duration = DURATION
        banner.show(bannerPosition: position)
    }
    
    func showFloatingNotificationBanner(title: String, subtitle: String, position: BannerPosition, style: BannerStyle) {
        banner = setImageViewToBanner(type: "Floating", title: title, subtitle: subtitle, style: style)
        banner.onTap = {
            self.banner.dismiss()
        }
        banner.onSwipeUp = {
            self.banner.dismiss()
        }
        showBanners([(banner as? FloatingNotificationBanner)!], position: position)
    }
    
    func showGrowingNotificationBanner(title: String, subtitle: String, position: BannerPosition, style: BannerStyle) {
        banner = setImageViewToBanner(type: "Growing", title: title, subtitle: subtitle, style: style)
        banner.onTap = {
            self.banner.dismiss()
        }
        banner.onSwipeUp = {
            self.banner.dismiss()
        }
        banner.duration = DURATION
        banner.show(bannerPosition: position)
    }
    
    func showStatusBarNotificationBanner(title: String, style: BannerStyle, disable: Bool = false) {
        banner = StatusBarNotificationBanner(title: title, style: style)
        banner.onTap = {
            self.banner.dismiss()
        }
        if disable {
            disableAutoDismiss()
        }
        banner.duration = DURATION
        banner.show()
    }
    
    func showBannerWithCustomView(view: UIView) {
        banner = NotificationBanner(customView: view)
        banner.onTap = {
            self.banner.dismiss()
        }
        banner.duration = DURATION
        banner.show()
    }
    
    func showBanners(_ banners: [FloatingNotificationBanner], position: BannerPosition, duration: Double = 1.5) {
        _ = banners.map { b in
            b.duration = duration
            b.show(bannerPosition: position,
                   queue: self.notificationBannerQueue, cornerRadius: 8.0,
                   shadowColor: UIColor(red: 0.431, green: 0.459, blue: 0.494, alpha: 1),
                   shadowBlurRadius: 16,
                   shadowEdgeInsets: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
            )
        }
    }
    
    func disableAutoDismiss() {
        banner.autoDismiss = false
    }

    //by default banner is dismissed after 5s
    func dismiss() {
        banner.dismiss()
    }
    
    func showBadCredentialsNotification(){
        showFloatingNotificationBanner(title: self.notificationLocalizatiton.loginCredentialsWrongNotificationTitle, subtitle: self.notificationLocalizatiton.loginCredentialsWrongNotificationSubtitle, position: .top, style: .danger)
    }
    
    func handleErrorResponseNotification(_ error: ServerError){
        var notificationTitle = ""
        var notificationSubtitle = ""
        var notificationStyle: BannerStyle = .danger
        
        switch error{
        case .BadRequest:
            notificationTitle = self.notificationLocalizatiton.badRequestCallNotificationTitle
            notificationSubtitle = self.notificationLocalizatiton.badRequestCallNotificationSubitle
        case .Unauthorized:
            notificationTitle = self.notificationLocalizatiton.unauthorizedCallNotificationTitle
            notificationSubtitle = self.notificationLocalizatiton.unauthorizedCallNotificationSubitle
        case .UnkownEndpoint:
            notificationTitle = self.notificationLocalizatiton.unknownEndpointCallNotificationTitle
            notificationSubtitle = self.notificationLocalizatiton.unknownEndpointCallNotificationSubitle
        case .ServerError:
            notificationTitle = self.notificationLocalizatiton.serverErrorCallNotificationTitle
            notificationSubtitle = self.notificationLocalizatiton.serverErrorCallNotificationSubitle
        case .Forbidden:
            notificationTitle = self.notificationLocalizatiton.forbiddenCallNotificationTitle
            notificationSubtitle = self.notificationLocalizatiton.forbiddenCallNotificationSubitle
        case .Conflict:
            notificationTitle = self.notificationLocalizatiton.conflictEndpointCallNotificationTitle
            notificationSubtitle = self.notificationLocalizatiton.conflictEndpointCallNotificationSubitle
            notificationStyle = .warning
        }
        showFloatingNotificationBanner(title: notificationTitle,
                                       subtitle: notificationSubtitle,
                                       position: .top,
                                       style: notificationStyle)
    }
    
    func setImageViewToBanner(type: String, title: String, subtitle: String, style: BannerStyle) -> BaseNotificationBanner{
        var notificationSideViewImage: UIImageView?
        switch style {
            case .danger:
                notificationSideViewImage = UIImageView(image: #imageLiteral(resourceName: "cancel"))
                break
            case .info:
                notificationSideViewImage = UIImageView(image: #imageLiteral(resourceName: "info"))
                break
            case .customView:
                notificationSideViewImage = UIImageView(image: #imageLiteral(resourceName: "success"))
                break
            case .success:
                notificationSideViewImage = UIImageView(image: #imageLiteral(resourceName: "check"))
                break
            case .warning:
                notificationSideViewImage = UIImageView(image: #imageLiteral(resourceName: "warning"))
                break
        }
        
        switch type {
        case "Floating":
            return FloatingNotificationBanner(title: title, subtitle: subtitle,
                                                  leftView: notificationSideViewImage, style: style)
        case "Simple":
            return NotificationBanner(title: title, subtitle: subtitle,
                                      leftView: notificationSideViewImage, style: style)
        case "Growing":
            return GrowingNotificationBanner(title: title, subtitle: subtitle,
                                             leftView: notificationSideViewImage, style: style)
        default:
            return FloatingNotificationBanner(title: title, subtitle: subtitle,
                                                  leftView: notificationSideViewImage, style: style)
        }
    }
}
