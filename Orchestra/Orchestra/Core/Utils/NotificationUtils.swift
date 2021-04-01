//
//  NotificationUtils.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 01/04/2021.
//


import NotificationBannerSwift

class NotificationsUtils {
    
    static let shared = NotificationsUtils()
        
    let notificationBannerQueue = NotificationBannerQueue()
    var banner: BaseNotificationBanner!
    let DURATION: Double = 0.2 //For fast banners
    
    func showBasicBanner(title: String, subtitle: String, position: BannerPosition, style: BannerStyle) {
        banner = NotificationBanner(title: title, subtitle: subtitle, style: style)
        banner.onTap = {
            self.banner.dismiss()
        }
        banner.duration = DURATION
        banner.show(bannerPosition: position)
    }
    
    func showFloatingNotificationBanner(title: String, subtitle: String, position: BannerPosition, style: BannerStyle) {
        banner = FloatGrowingNotificationBanner(title: title, subtitle: subtitle, style: style)
        banner.onTap = {
            self.banner.dismiss()
        }
        showBanners([(banner as? FloatGrowingNotificationBanner)!], position: position)
    }
    
    func showGrowingNotificationBanner(title: String, subtitle: String, position: BannerPosition, style: BannerStyle) {
        banner = GrowingNotificationBanner(title: title, subtitle: subtitle, style: style)
        banner.onTap = {
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
    
    func showBanners(_ banners: [FloatGrowingNotificationBanner], position: BannerPosition, duration: Double = 0.5) {
        _ = banners.map { b in
            b.duration = duration
            b.show(bannerPosition: position,
                queue: self.notificationBannerQueue,
                cornerRadius: 8,
                shadowColor: UIColor(red: 0.431, green: 0.459, blue: 0.494, alpha: 1),
                shadowBlurRadius: 16,
                shadowEdgeInsets: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8))
        }
    }
    
    func disableAutoDismiss() {
        banner.autoDismiss = false
    }

    //by default banner is dismissed after 5s
    func dismiss() {
        banner.dismiss()
    }
}
