//
//  ProgressUtils.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 01/04/2021.
//

import Foundation
import MRProgress

enum EnumModeView{
    case MRActivityIndicatorView
    case MRCircularProgressView
    case UIProgressView
    case UIActivityIndicatorView
    case MRCheckmarkIconView
    case MRCrossIconView
    case None
}

class ProgressUtils {
    
    static var sharred = ProgressUtils()
    
    var overlay: MRProgressOverlayView!
    var mode: EnumModeView.Type!
    
    func displayIndeterminateProgeress(title: String, view: UIView) {
        overlay = MRProgressOverlayView.showOverlayAdded(to: view, title: title, mode: .indeterminate, animated: true)
    }
    
    func displayCheckMark(title: String, view: UIView) {
        overlay = MRProgressOverlayView.showOverlayAdded(to: view, title: title, mode: MRProgressOverlayViewMode.checkmark, animated: true)
    }
    
    func dismiss() {
        self.overlay?.dismiss(true)
    }
    
    func displayV2(view:UIView, title: String, modeView: EnumModeView, pro: Float = 1.0){
        overlay.titleLabelText = title
        switch modeView {
            case .UIProgressView:
                overlay.mode = MRProgressOverlayViewMode.determinateHorizontalBar
                let progress = UIProgressView()
                progress.progressViewStyle = UIProgressView.Style.default
                progress.progress = pro
                overlay.modeView = progress
            
            case .UIActivityIndicatorView:
                overlay.mode = MRProgressOverlayViewMode.indeterminateSmall
                let progress = UIActivityIndicatorView()
                progress.style = UIActivityIndicatorView.Style.gray
                overlay.modeView = progress
            
            case .MRCrossIconView:
                MRProgressOverlayView.showOverlayAdded(to: view, title: title, mode: MRProgressOverlayViewMode.cross, animated: true);
                return
            
            case .MRCheckmarkIconView:
                MRProgressOverlayView.showOverlayAdded(to: view, title: title, mode: MRProgressOverlayViewMode.checkmark, animated: true);
                return
            
            case .MRCircularProgressView:
                overlay.mode = MRProgressOverlayViewMode.determinateCircular
                let progress = MRCircularProgressView()
                progress.animationDuration = 0.3
                progress.mayStop = true
                progress.progress = pro
                overlay.modeView = progress
                break;
            
            case .MRActivityIndicatorView:
                break
            
            case .None:
                break
        }
        
        view.addSubview(overlay)
        overlay.show(true)
    }
    
}
