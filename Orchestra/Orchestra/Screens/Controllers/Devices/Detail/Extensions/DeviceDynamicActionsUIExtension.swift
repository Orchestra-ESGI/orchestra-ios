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
    
    func addDynamicComponents(){
        let brightness = self.deviceData?.actions?.brightness
        let color =  self.deviceData?.actions?.color
        let colorTemp = self.deviceData?.actions?.colorTemp
        let state = self.deviceData?.actions?.state
        let deviceType = self.deviceData?.type
        
        var lastElementInsertedYpos = CGFloat(0)
        if(deviceType == .Occupancy || deviceType == .Contact || deviceType == .StatelessProgrammableSwitch){
            self.insertNoActionContainer(xPos: 0, yPos: lastElementInsertedYpos)
            lastElementInsertedYpos += 120
        }else if(self.deviceData?.type == .Unknown){
            self.insertContactUsButton(xPos: 0, yPos: lastElementInsertedYpos)
            lastElementInsertedYpos += 120
        }else{
            if ( brightness != nil || color != nil || colorTemp != nil) {
                if brightness != nil{
                    self.insertOnOffContainer(xPos: 0, yPos: lastElementInsertedYpos)
                    lastElementInsertedYpos += 100
                    self.insertBrightnessContainer(xPos: 0, yPos: lastElementInsertedYpos)
                    lastElementInsertedYpos += 100
                }
                if( color != nil && colorTemp != nil){
                    // show segmentedView controller
                    self.insertColorAndTempContainer(mainSlider: 0, xPos: 0, yPos: lastElementInsertedYpos)
                    lastElementInsertedYpos += 130
                }
            } else if(state != nil){
                self.insertOnOffContainer(xPos: 0, yPos: lastElementInsertedYpos)
                lastElementInsertedYpos += 100
            }else{
                self.insertNoActionContainer(xPos: 0, yPos: lastElementInsertedYpos)
                lastElementInsertedYpos += 120
            }
        }
        self.dynamicContainerHeight.constant = lastElementInsertedYpos
    }
    
    
    func insertBrightnessContainer(xPos: CGFloat, yPos: CGFloat){
        let containerWidth = UIScreen.main.bounds.width
        let brightNessContainerView = UIView(frame: CGRect(x: xPos,
                                                           y: yPos,
                                                           width: containerWidth,
                                                           height: 100))
        
        self.dynamicViewContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let brightnessLabelWidth = containerWidth
        let brightnessLabelHeight = CGFloat(20)
        let sliderIconsHeight = CGFloat(30)
        let brightnessSliderWidth = CGFloat(containerWidth - (2 * sliderIconsHeight))
        let brightnessSliderHeight = CGFloat(20)
        
        
        var iconsColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        // Add label on top of the slider
        let sliderLabel = UILabel()
        // MARK: - TODO Text color not adapting to dark mode
        let brightnessActionLabel = self.labelLocalization.deviceActionBrightnessActionName
        sliderLabel.text = brightnessActionLabel
        
        sliderLabel.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        sliderLabel.numberOfLines = 4
        sliderLabel.textAlignment = .left
        sliderLabel.frame = CGRect(x: 15,
                                       y: 15,
                                       width: brightnessLabelWidth,
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
                                                y: 15 + brightnessLabelHeight + 10,
                                                width: containerWidth,
                                                height: brightnessSliderHeight + 10)
        // Icon at the left of the slider
        let leftSliderImage = UIImageView()
        leftSliderImage.frame = CGRect(x: 5,
                                       y: 5,
                                      width: sliderIconsHeight - 10,
                                      height: sliderIconsHeight - 10)
        leftSliderImage.tintColor = iconsColor
        leftSliderImage.image = UIImage(systemName: "sun.min")
        sliderWithImageContainer.addSubview(leftSliderImage)
        
        // Icon at the right of the slider
        let rightSliderView = UIImageView()
        rightSliderView.frame = CGRect(x: brightnessSliderWidth + 30,
                                       y: 0,
                                      width: sliderIconsHeight ,
                                      height: sliderIconsHeight)
        rightSliderView.tintColor = iconsColor
        rightSliderView.image = UIImage(systemName: "sun.max.fill")
        sliderWithImageContainer.addSubview(rightSliderView)
        
        let slider = UISlider()
        slider.isContinuous = false
        slider.tintColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        slider.frame = CGRect(x: sliderIconsHeight,
                              y: 5,
                              width: brightnessSliderWidth,
                              height: brightnessSliderHeight)

        slider.tag = 0
        if self.deviceData?.actions?.brightness == nil ||
            self.deviceData?.actions?.brightness?.minVal == nil ||
            self.deviceData?.actions?.brightness?.maxVal == nil {
            return
        }
        
        slider.minimumValue = Float((self.deviceData?.actions?.brightness?.minVal)!)
        slider.maximumValue = Float((deviceData?.actions?.brightness?.maxVal)!)
        slider.value = Float(deviceData?.actions?.brightness?.currentState ?? Int(slider.maximumValue) / 2)
        
        slider.addTarget(self, action: #selector(self.sliderDidChange(_:)), for: .valueChanged)

        sliderWithImageContainer.addSubview(slider)

        brightNessContainerView.addSubview(sliderLabel)
        brightNessContainerView.addSubview(sliderWithImageContainer)
        

        self.dynamicViewContainer.addSubview(brightNessContainerView)
    }
    
    
    func insertColorAndTempContainer(mainSlider: Int, xPos: CGFloat, yPos: CGFloat){
        let containerWidth = UIScreen.main.bounds.width
        let colorAndtempContainerView = UIView(frame: CGRect(x: xPos,
                                                             y: yPos,
                                                             width: containerWidth,
                                                             height: 130))
        
        let xPos = CGFloat(15)
        
        let colorSliderWidth = CGFloat(containerWidth - (2 * xPos))
        let colorSliderHeight = CGFloat(20)
        
        
        self.dynamicViewContainer.translatesAutoresizingMaskIntoConstraints = false
        let temperatureActionLabel = self.labelLocalization.deviceActionTemperatureActionName
        let colorActionLabel = self.labelLocalization.deviceActionColorActionName
        
        let segmentedView = UISegmentedControl(frame:
                                                CGRect(x: (CGFloat(UIScreen.main.bounds.width) - 200) / 2,
                                                       y: 0 ,
                                                       width: 200,
                                                       height: 25))
        segmentedView.insertSegment(withTitle: colorActionLabel, at: 0, animated: true)
        segmentedView.insertSegment(withTitle: temperatureActionLabel, at: 1, animated: true)
        segmentedView.selectedSegmentIndex = 0
        segmentedView.addTarget(self,
                                action: #selector(segmentedControlValueChanged(_:)),
                                for: .valueChanged)
        colorAndtempContainerView.addSubview(segmentedView)
        
        self.dynamicColorContainerLabel = UILabel()
        dynamicColorContainerLabel!.text = colorActionLabel
        dynamicColorContainerLabel!.textColor = #colorLiteral(red: 0.0923493728, green: 0.1022289321, blue: 0.1063905284, alpha: 1)
        dynamicColorContainerLabel!.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        dynamicColorContainerLabel!.numberOfLines = 1
        dynamicColorContainerLabel!.textAlignment = .left
        dynamicColorContainerLabel!.frame = CGRect(x: 15,
                                 y: 25 + segmentedView.frame.height + segmentedView.frame.origin.y,
                                 width: containerWidth,
                                 height: 25)
        self.dynamicColorContainerLabel!.isHidden = false
        
        self.dynamicTemperatureContainerLabel = UILabel()
        self.dynamicTemperatureContainerLabel!.text = temperatureActionLabel
        self.dynamicTemperatureContainerLabel!.textColor = #colorLiteral(red: 0.0923493728, green: 0.1022289321, blue: 0.1063905284, alpha: 1)
        self.dynamicTemperatureContainerLabel!.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        self.dynamicTemperatureContainerLabel!.numberOfLines = 1
        self.dynamicTemperatureContainerLabel!.textAlignment = .left
        self.dynamicTemperatureContainerLabel!.frame = CGRect(x: 15,
                                 y: 25 + segmentedView.frame.height + segmentedView.frame.origin.y,
                                 width: containerWidth,
                                 height: 25)
        self.dynamicTemperatureContainerLabel!.isHidden = true
        
        if self.traitCollection.userInterfaceStyle == .dark {
            dynamicColorContainerLabel!.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.dynamicTemperatureContainerLabel!.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }else{
            dynamicColorContainerLabel!.textColor = .black
            self.dynamicTemperatureContainerLabel!.textColor = .black
        }

        self.dynamicColorContainerSlider = ColorSlider(orientation: .horizontal, previewSide: .top)
        self.dynamicColorContainerSlider!.addTarget(self,
                                                    action: #selector(changedColor(_:event:)),
                                                    for: .allTouchEvents)
        self.dynamicColorContainerSlider!.frame = CGRect(x: 15,
                                   y: dynamicColorContainerLabel!.frame.height + dynamicColorContainerLabel!.frame.origin.y + 15,
                                    width: colorSliderWidth,
                                    height: colorSliderHeight)
        self.dynamicColorContainerSlider!.isHidden = false
        self.dynamicColorContainerSlider!.isEnabled = true
        
        self.dynamicTemperatureContainerSlider = UISlider()
        self.dynamicTemperatureContainerSlider!.tintColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        self.dynamicTemperatureContainerSlider!.isContinuous = false
        self.dynamicTemperatureContainerSlider!.frame = CGRect(x: 15,
                                         y: self.dynamicTemperatureContainerLabel!.frame.height + self.dynamicTemperatureContainerLabel!.frame.origin.y + 15,
                                          width: colorSliderWidth,
                                          height: colorSliderHeight)
        if self.deviceData?.actions?.colorTemp == nil ||
            self.deviceData?.actions?.colorTemp?.minVal == nil ||
            self.deviceData?.actions?.colorTemp?.maxVal == nil {
            return
        }
        self.dynamicTemperatureContainerSlider!.minimumValue = Float((deviceData?.actions?.colorTemp?.minVal)!)
        self.dynamicTemperatureContainerSlider!.maximumValue = Float((deviceData?.actions?.colorTemp?.maxVal)!)
        self.dynamicTemperatureContainerSlider!.value = Float(deviceData?.actions?.colorTemp?.currentState ?? Int(self.dynamicTemperatureContainerSlider!.maximumValue / 2))
        
        self.dynamicTemperatureContainerSlider!.isHidden = true
        //self.dynamicTemperatureContainerSlider!.isEnabled = true
        self.dynamicTemperatureContainerSlider!.tag = 1
        self.dynamicTemperatureContainerSlider!.addTarget(self, action: #selector(sliderDidChange(_:)), for: .valueChanged)

        colorAndtempContainerView.addSubview(dynamicColorContainerLabel!)
        colorAndtempContainerView.addSubview(self.dynamicTemperatureContainerLabel!)
        colorAndtempContainerView.addSubview(self.dynamicColorContainerSlider!)
        colorAndtempContainerView.addSubview(self.dynamicTemperatureContainerSlider!)
        
        self.dynamicViewContainer.addSubview(colorAndtempContainerView)
    }
    
    func insertContactUsButton(xPos: CGFloat, yPos: CGFloat){
        self.dynamicViewContainer.translatesAutoresizingMaskIntoConstraints = false
        let containerWidth = UIScreen.main.bounds.width
        
        let deviceNotSupportedLabel = UILabel()
        deviceNotSupportedLabel.text = self.labelLocalization.unknownDeviceLabel
        deviceNotSupportedLabel.textColor = #colorLiteral(red: 0.0923493728, green: 0.1022289321, blue: 0.1063905284, alpha: 1)
        deviceNotSupportedLabel.font = Font.Regular(20.0)
        deviceNotSupportedLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        deviceNotSupportedLabel.numberOfLines = 4
        deviceNotSupportedLabel.textAlignment = .center
        deviceNotSupportedLabel.frame = CGRect(x: xPos + 20, y: yPos, width: containerWidth - 40, height: 50)
        
        let contactUsButton = UIButton()
        contactUsButton.backgroundColor = .systemBlue
        contactUsButton.setTitle(self.labelLocalization.unknownDeviceButtonTitle, for: .normal)
        contactUsButton.setTitleColor(.white, for: .normal)
        contactUsButton.titleLabel?.font = Font.Bold(20.0)
        contactUsButton.layer.cornerRadius = 12.0
        contactUsButton.frame = CGRect(x: xPos + 60,
                                       y: yPos + deviceNotSupportedLabel.frame.height + 15,
                                       width: containerWidth - 120, height: 50)
        contactUsButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        contactUsButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
        contactUsButton.tintColor = .white
        contactUsButton.addTarget(self, action: #selector(self.sendEmailRequest), for: .touchUpInside)
        
        
        self.dynamicViewContainer.addSubview(deviceNotSupportedLabel)
        self.dynamicViewContainer.addSubview(contactUsButton)
    }
    
    func insertNoActionContainer(xPos: CGFloat, yPos: CGFloat){
        self.dynamicViewContainer.translatesAutoresizingMaskIntoConstraints = false
        let containerWidth = UIScreen.main.bounds.width
        let noActionLabel = UILabel()
        noActionLabel.text = self.labelLocalization.deviceActionNoActionName//"Aucune action n'est possible sur cet objet, vous pouvez cependant l'utiliser pour créer des scènes"
        noActionLabel.textColor = #colorLiteral(red: 0.0923493728, green: 0.1022289321, blue: 0.1063905284, alpha: 1)
        noActionLabel.font = UIFont(name: "Avenir-Medium", size: 20)
        noActionLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        noActionLabel.numberOfLines = 4
        noActionLabel.textAlignment = .center
        noActionLabel.frame = CGRect(x: xPos,
                         y: yPos,
                         width: containerWidth,
                         height: 100)
        
        self.dynamicViewContainer.addSubview(noActionLabel)
    }
    
    func insertOnOffContainer(xPos: CGFloat, yPos: CGFloat){
        self.dynamicViewContainer.translatesAutoresizingMaskIntoConstraints = false
        let containerWidth = UIScreen.main.bounds.width
        
        let onOffViewHeight = CGFloat(75)
        let onOffViewWidth = CGFloat(300)
        let onOffContainerHeight = CGFloat(100)
        let onOffViewContainer = UIView(frame: CGRect(x: xPos,
                                                      y: yPos,
                                                      width: containerWidth,
                                                      height: onOffContainerHeight))
        
        let segmentedView = UISegmentedControl(frame:
                                                CGRect(x: (containerWidth - onOffViewWidth) / 2,
                                                       y: (onOffContainerHeight - onOffViewHeight) / 2,
                                                       width: onOffViewWidth,
                                                       height: onOffViewHeight))
        let onActionTitle = self.labelLocalization.deviceActionOnActionName
        let offActionTitle = self.labelLocalization.deviceActionOffActionName
        segmentedView.insertSegment(withTitle: onActionTitle.capitalized, at: 0, animated: true)
        segmentedView.insertSegment(withTitle: offActionTitle.capitalized, at: 1, animated: true)
        
        segmentedView.addTarget(self,
                                action: #selector(onOnffToggled(_:)),
                                for: .valueChanged)
        if(self.deviceData?.actions?.state == "on"){
            segmentedView.selectedSegmentIndex = 0
        }else{
            segmentedView.selectedSegmentIndex = 1
        }
        
        onOffViewContainer.addSubview(segmentedView)
        
        self.dynamicViewContainer.addSubview(onOffViewContainer)
    }
    
}
