//
//  Slide.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 02/05/2021.
//

import UIKit
import Lottie

class Slide: UIView {

    
    @IBOutlet weak var imageBackground: UIView!
    @IBOutlet weak var slideTitle: UILabel!
    @IBOutlet weak var slideDescription: UITextView!
    @IBOutlet weak var slideImageContainerHeightConstraint: NSLayoutConstraint!
    
    private var animationView: AnimationView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let imageContainerHeight =  (UIScreen.main.bounds.height / 2)
        commonInit()
        self.slideImageContainerHeightConstraint.constant = imageContainerHeight
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    func fillLottieAnimation(lottieFileName: String){
        animationView = .init(name: lottieFileName)
        animationView!.frame = self.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 1.5
        animationView?.translatesAutoresizingMaskIntoConstraints = false
        imageBackground.addSubview(animationView!)
        
        
        animationView?.leftAnchor.constraint(equalTo: imageBackground.leftAnchor).isActive = true
        animationView?.rightAnchor.constraint(equalTo: imageBackground.rightAnchor).isActive = true
        animationView?.topAnchor.constraint(equalTo: imageBackground.topAnchor).isActive = true
        animationView?.bottomAnchor.constraint(equalTo: imageBackground.bottomAnchor).isActive = true
        
        animationView!.play()
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
