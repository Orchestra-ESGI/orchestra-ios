//
//  Slide.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 02/05/2021.
//

import UIKit

class Slide: UIView {

    
    @IBOutlet weak var imageBackground: UIView!
    @IBOutlet weak var slideImage: UIImageView!
    @IBOutlet weak var slideTitle: UILabel!
    @IBOutlet weak var slideDescription: UITextView!
    @IBOutlet weak var slideImageContainerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sliderImageHeightConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let imageContainerHeight =  (UIScreen.main.bounds.height / 2)
        commonInit()
        self.slideImageContainerHeightConstraint.constant = imageContainerHeight
        self.sliderImageHeightConstraint.constant = imageContainerHeight - 50
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    private func shapeImageBgView(){
        
        
    }
    
    func commonInit(){
        let viewFromXib  = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
    
}

extension UIView{
      var roundedImage: UIView {
        let offset: CGFloat = (self.frame.height * 0.5)
        let bounds: CGRect = self.bounds

        let rectBounds: CGRect = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width , height: bounds.size.height / 2)
        let rectPath: UIBezierPath = UIBezierPath(rect: rectBounds)
        let ovalBounds: CGRect = CGRect(x: bounds.origin.x - offset / 2, y: bounds.origin.y, width: bounds.size.width + offset , height: bounds.size.height)
        let ovalPath: UIBezierPath = UIBezierPath(ovalIn: ovalBounds)
        rectPath.append(ovalPath)

        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = rectPath.cgPath

        self.layer.mask = maskLayer
        return self
      }
    }
