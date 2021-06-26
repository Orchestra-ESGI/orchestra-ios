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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        self.imageBackground = self.imageBackground.roundedImage
//        NSLayoutConstraint.activate([
//            // OK
//            self.imageBackground.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 3)
//        ])
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
        let maskLayer = CAShapeLayer(layer: self.layer)
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x:0, y:0))
        bezierPath.addLine(to: CGPoint(x:self.bounds.size.width, y:0))
        bezierPath.addLine(to: CGPoint(x:self.bounds.size.width,
                                       y:self.bounds.size.height - (self.bounds.size.height * 0.36)))
        bezierPath.addQuadCurve(to: CGPoint(x:0, y: self.bounds.size.height - (self.bounds.size.height * 0.3)),
                                controlPoint: CGPoint(x:self.bounds.size.width/2, y:self.bounds.size.height))
        bezierPath.addLine(to: CGPoint(x:0, y:0))
        bezierPath.close()
        
        /*
        arrowPath.move(to: CGPoint(x:0, y:0))
        arrowPath.addLine(to: CGPoint(x:givenView.bounds.size.width, y:0))
        arrowPath.addLine(to: CGPoint(x:givenView.bounds.size.width, y:givenView.bounds.size.height - (givenView.bounds.size.height*curvedPercent)))
        arrowPath.addQuadCurve(to: CGPoint(x:0, y:givenView.bounds.size.height - (givenView.bounds.size.height*curvedPercent)),
                               controlPoint: CGPoint(x:givenView.bounds.size.width/2, y:givenView.bounds.size.height))
        arrowPath.addLine(to: CGPoint(x:0, y:0))
        arrowPath.close()
        */

        maskLayer.path = bezierPath.cgPath
        maskLayer.frame = self.bounds
        maskLayer.masksToBounds = true
        self.layer.mask = maskLayer
        return self
      }
    }
