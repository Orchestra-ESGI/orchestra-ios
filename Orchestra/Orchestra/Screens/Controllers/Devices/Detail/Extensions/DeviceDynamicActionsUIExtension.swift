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
        
        var lastElementInsertedYpos = CGFloat(0)

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
                lastElementInsertedYpos += 100
            }
        } else if(state != nil){
            self.insertOnOffContainer(xPos: 0, yPos: lastElementInsertedYpos)
            lastElementInsertedYpos += 100
        }else{
            self.insertNoActionContainer(xPos: 0, yPos: lastElementInsertedYpos)
            lastElementInsertedYpos += 120
        }
        
        NSLayoutConstraint.activate([
            // OK
            self.dynamicViewContainer.heightAnchor.constraint(equalToConstant: lastElementInsertedYpos)
        ])
    }
    
    
    // OK
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
        sliderLabel.text = "Luminosité"
        
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
        slider.value = Float((deviceData?.actions?.brightness?.currentState)!)
        
        slider.addTarget(self, action: #selector(self.sliderDidChange(_:)), for: .valueChanged)

        sliderWithImageContainer.addSubview(slider)

        brightNessContainerView.addSubview(sliderLabel)
        brightNessContainerView.addSubview(sliderWithImageContainer)
        

        self.dynamicViewContainer.addSubview(brightNessContainerView)
    }
    
    // OK
    func insertColorAndTempContainer(mainSlider: Int, xPos: CGFloat, yPos: CGFloat){
        let containerWidth = UIScreen.main.bounds.width
        let colorAndtempContainerView = UIView(frame: CGRect(x: xPos,
                                                             y: yPos,
                                                             width: containerWidth,
                                                             height: 100))
        
        let xPos = CGFloat(15)
        
        let colorSliderWidth = CGFloat(containerWidth - (2 * xPos))
        let colorSliderHeight = CGFloat(20)
        
        
        self.dynamicViewContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let segmentedView = UISegmentedControl(frame:
                                                CGRect(x: (CGFloat(UIScreen.main.bounds.width) - 200) / 2,
                                                       y: 0 ,
                                                       width: 200,
                                                       height: 25))
        segmentedView.insertSegment(withTitle: "Couleur", at: 0, animated: true)
        segmentedView.insertSegment(withTitle: "Température", at: 1, animated: true)
        segmentedView.selectedSegmentIndex = 0
        segmentedView.addTarget(self,
                                action: #selector(segmentedControlValueChanged(_:)),
                                for: .valueChanged)
        colorAndtempContainerView.addSubview(segmentedView)
        
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
        actionLabel.frame = CGRect(x: 15,
                                 y: segmentedView.frame.height + segmentedView.frame.origin.y,
                                 width: containerWidth,
                                 height: 25)
        
        let colorSlider = ColorSlider(orientation: .horizontal, previewSide: .top)
        colorSlider.frame = CGRect(x: 15,
                                   y: actionLabel.frame.height + actionLabel.frame.origin.y + 15,
                                    width: colorSliderWidth,
                                    height: colorSliderHeight)
        
        colorSlider.addTarget(self, action: #selector(changedColor(_:)), for: .valueChanged)

        colorAndtempContainerView.addSubview(actionLabel)
        colorAndtempContainerView.addSubview(colorSlider)
        
        self.dynamicViewContainer.addSubview(colorAndtempContainerView)
    }
    
    // OK
    func insertNoActionContainer(xPos: CGFloat, yPos: CGFloat){
        self.dynamicViewContainer.translatesAutoresizingMaskIntoConstraints = false
        let containerWidth = UIScreen.main.bounds.width
        let noActionLabel = UILabel()
        noActionLabel.text = "Aucune action n'est possible sur cet objet, vous pouvez cependant l'utiliser pour créer des scènes"
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
        segmentedView.insertSegment(withTitle: "ON", at: 0, animated: true)
        segmentedView.insertSegment(withTitle: "OFF", at: 1, animated: true)
        
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
