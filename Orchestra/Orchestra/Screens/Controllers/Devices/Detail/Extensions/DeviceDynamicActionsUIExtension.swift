//
//  DeviceDynamicActionsUIExtension.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 05/06/2021.
//

import Foundation
import UIKit
import ColorSlider

extension DeviceInfoViewController{
    
    func addDynamicComponents(x: CGFloat, y: CGFloat){
        let brightness = self.deviceData?.actions?.brightness
        let color =  self.deviceData?.actions?.brightness
        let colorTemp = self.deviceData?.actions?.brightness
        
        if( brightness == nil && color == nil && colorTemp == nil){
            self.insertNoActionAvailableComponent()
        }else{
            if brightness != nil{
                // add brightness component
                self.insertSlierComponent(forType: .BrightnessSlider, xPos: x, yPos: y)
            }
            if color != nil{
                // add color component
                self.insertColorComponent(yPos: CGFloat(100))
            }
            if colorTemp != nil{
                // add colorTemp component
                self.insertSlierComponent(forType: .ColorTempSlider, xPos: x, yPos: y)
            }
        }
    }
    
    func insertSlierComponent(forType sliderType: SliderType, xPos: CGFloat, yPos: CGFloat){
        self.dynamicViewContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let containerWidth = UIScreen.main.bounds.width
        let brightnessLabelHeight = CGFloat(20)
        let sliderIconsHeight = CGFloat(30)
        let brightnessSliderWidth = CGFloat(containerWidth - (2 * sliderIconsHeight))
        let brightnessSliderHeight = CGFloat(20)
        let minValSliderIcon = sliderType == .BrightnessSlider ? "sun.min" : "thermometer.sun.fill"
        let maxValSliderIcon = sliderType == .ColorTempSlider ? "thermometer.snowflake" : "sun.max.fill"
        
        
        var iconsColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        // Add label on top of the slider
        let sliderLabel = UILabel()
        // MARK: - TODO Text color not adapting to dark mode
        sliderLabel.text = (sliderType == .BrightnessSlider) ?  "Luminosité" : "Température"
        sliderLabel.textColor = #colorLiteral(red: 0.0923493728, green: 0.1022289321, blue: 0.1063905284, alpha: 1)
        sliderLabel.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        sliderLabel.numberOfLines = 4
        sliderLabel.textAlignment = .left
        sliderLabel.frame = CGRect(x: xPos,
                                       y: yPos,
                                       width: brightnessSliderWidth,
                                       height: brightnessLabelHeight)
        if self.traitCollection.userInterfaceStyle == .dark {
            sliderLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            iconsColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }else{
            sliderLabel.textColor = .black
            iconsColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
        // Container with the slider and 2 icons
        let sliderWithImageContainer = UIView()
        sliderWithImageContainer.frame = CGRect(x: 0,
                                                y: yPos + brightnessLabelHeight + 10,
                                                width: containerWidth,
                                                height: brightnessSliderHeight + 10)
        // Icon at the left of the slider
        let leftSliderImage = UIImageView()
        leftSliderImage.frame = CGRect(x: 5,
                                       y: 5,
                                      width: sliderIconsHeight - 10,
                                      height: sliderIconsHeight - 10)
        leftSliderImage.tintColor = iconsColor
        leftSliderImage.image = UIImage(systemName: minValSliderIcon)
        sliderWithImageContainer.addSubview(leftSliderImage)
        
        // Icon at the right of the slider
        let rightSliderView = UIImageView()
        rightSliderView.frame = CGRect(x: brightnessSliderWidth + 30, y: 0,
                                      width: sliderIconsHeight ,
                                      height: sliderIconsHeight )
        rightSliderView.tintColor = iconsColor
        rightSliderView.image = UIImage(systemName: maxValSliderIcon)
        sliderWithImageContainer.addSubview(rightSliderView)
        
        let slider = UISlider()
        slider.tintColor = sliderType == .BrightnessSlider ?   #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1) : #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        slider.frame = CGRect(x: sliderIconsHeight,
                                        y: 5,
                                        width: brightnessSliderWidth,
                                        height: brightnessSliderHeight)
        switch sliderType {
        case .BrightnessSlider:
            slider.tag = 0
            if self.deviceData?.actions?.brightness == nil ||
                self.deviceData?.actions?.brightness?.minVal == nil ||
                self.deviceData?.actions?.brightness?.maxVal == nil {
                return
            }
            slider.minimumValue = Float((self.deviceData?.actions?.brightness?.minVal)!)
            slider.maximumValue = Float((deviceData?.actions?.brightness?.maxVal)!)
            slider.value = Float((deviceData?.actions?.brightness?.currentState)!)
        case .ColorTempSlider:
            slider.tag = 1
            if self.deviceData?.actions?.colorTemp == nil ||
                self.deviceData?.actions?.colorTemp?.minVal == nil ||
                self.deviceData?.actions?.colorTemp?.maxVal == nil {
                return
            }
            slider.minimumValue = Float((self.deviceData?.actions?.colorTemp?.minVal)!)
            slider.maximumValue = Float((deviceData?.actions?.colorTemp?.maxVal)!)
            slider.value = Float((deviceData?.actions?.colorTemp?.currentState)!)
        }
        slider.addTarget(self, action: #selector(self.sliderDidChange(_:)), for: .valueChanged)
        sliderWithImageContainer.addSubview(slider)
        
        self.dynamicViewContainer.addSubview(sliderLabel)
        self.dynamicViewContainer.addSubview(sliderWithImageContainer)
    }
    
    
     func insertColorComponent(yPos: CGFloat){
        let containerWidth = UIScreen.main.bounds.width
        
        let xPos = CGFloat(15)
        
        let colorSliderWidth = CGFloat(containerWidth - (2 * xPos))
        let colorSliderHeight = CGFloat(20)
        
        
        self.dynamicViewContainer.translatesAutoresizingMaskIntoConstraints = false
        let actionLabel = UILabel()
        actionLabel.text = "Couleur"
        actionLabel.textColor = #colorLiteral(red: 0.0923493728, green: 0.1022289321, blue: 0.1063905284, alpha: 1)
        actionLabel.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        if self.traitCollection.userInterfaceStyle == .dark {
            actionLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }else{
            actionLabel.textColor = .black
        }
        actionLabel.numberOfLines = 4
        actionLabel.textAlignment = .left
        actionLabel.frame = CGRect(x: xPos,
                                 y: yPos,
                                 width: containerWidth - (2 * xPos),
                                 height: 25)
        
        let colorSlider = ColorSlider(orientation: .horizontal, previewSide: .top)
        colorSlider.frame = CGRect(x: xPos,
                                   y: actionLabel.frame.origin.y + actionLabel.frame.height + 30,
                                    width: colorSliderWidth,
                                    height: colorSliderHeight)
        
        colorSlider.addTarget(self, action: #selector(changedColor(_:)), for: .valueChanged)

        self.dynamicViewContainer.addSubview(actionLabel)
        self.dynamicViewContainer.addSubview(colorSlider)
    }
    
    func insertNoActionAvailableComponent(){
        let containerWidth = UIScreen.main.bounds.width
        let containerHeight = CGFloat(150)
        
        let viewHeight = CGFloat(100)
        let leftViewSpace = CGFloat(20)
        let topViewSpace = (containerHeight - viewHeight) / 2
        
        self.dynamicViewContainer.translatesAutoresizingMaskIntoConstraints = false
        let noActionLabel = UILabel()
        noActionLabel.text = "Aucune action n'est possible sur cet objet, vous pouvez cependant l'utiliser pour créer des scènes"
        noActionLabel.textColor = #colorLiteral(red: 0.0923493728, green: 0.1022289321, blue: 0.1063905284, alpha: 1)
        noActionLabel.font = UIFont(name: "Avenir-Medium", size: 20)
        noActionLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        noActionLabel.numberOfLines = 4
        noActionLabel.textAlignment = .center
        noActionLabel.frame = CGRect(x: leftViewSpace,
                         y: topViewSpace,
                         width: containerWidth - (2 * leftViewSpace),
                         height: viewHeight)
        
        self.dynamicViewContainer.addSubview(noActionLabel)
    }
}
