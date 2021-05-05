//
//  Slide.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 02/05/2021.
//

import UIKit

@IBDesignable class Slide: UIView {

    @IBOutlet weak var slideImage: UIImageView!
    @IBOutlet weak var slideTitle: UILabel!
    @IBOutlet weak var slideDescription: UITextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    func commonInit(){
        let viewFromXib  = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
    
}
