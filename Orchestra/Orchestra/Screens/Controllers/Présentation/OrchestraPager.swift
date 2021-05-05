//
//  OrchestraPager.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 01/05/2021.
//

import Foundation
import UIKit
import CHIPageControl
import Floaty

class OrchestraPager: UIViewController {
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = 5
        pc.currentPageIndicatorTintColor = .purple
        return pc
    }()
    
    private let scrollView = UIScrollView()
    private var slides: [UIView] = []
    private let floatingActionButton = Floaty()
    
    // MARK: - Utils
    let screenLabelLocalizeUtils = ScreensLabelLocalizableUtils()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.slides = createSlides()
        scrollView.delegate = self
        pageControl.addTarget(self,
                              action: #selector(self.pageControlDidChanged(_:)),
                              for: .valueChanged)
        scrollView.backgroundColor = .black
        view.addSubview(pageControl)
        view.addSubview(scrollView)
        view.bringSubviewToFront(pageControl)
        self.setUpFAB()
    }
    
    
    
    @objc private func pageControlDidChanged(_ sender: UIPageControl){
        let current = sender.currentPage
        scrollView.setContentOffset(CGPoint(x: CGFloat(current) * view.frame.size.width, y: 0), animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pageControl.frame = CGRect(x: 10, y: view.frame.size.height - 100, width: view.frame.size.width - 20, height: 70)
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        
        if scrollView.subviews.count == 2{
            configureScrollView()
        }
    }
    
    func createSlides() -> [UIView] {
        // Create sldies for the pager
        let slide1 = Slide(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        slide1.slideImage.image = UIImage(named: "couple-couch-slide-1")
        slide1.slideTitle.text = self.screenLabelLocalizeUtils.pageSlide1TitleLabelText //"Simplicité"
        slide1.slideDescription.text = self.screenLabelLocalizeUtils.pagerSlide1LabelText
        
        let slide2 = Slide(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        slide2.slideImage.image = UIImage(named: "couple-couch-slide-1")
        slide2.slideTitle.text = self.screenLabelLocalizeUtils.pageSlide2TitleLabelText //"Efficacité"
        slide2.slideDescription.text = self.screenLabelLocalizeUtils.pagerSlide2LabelText
        
        let slide3 = Slide(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        slide3.slideImage.image = UIImage(named: "couple-couch-slide-1")
        slide3.slideTitle.text = self.screenLabelLocalizeUtils.pageSlide3TitleLabelText // "Clarté"
        slide3.slideDescription.text = self.screenLabelLocalizeUtils.pagerSlide3LabelText
        
        let slide4 = Slide(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        slide4.slideImage.image = UIImage(named: "couple-couch-slide-1")
        slide4.slideTitle.text = self.screenLabelLocalizeUtils.pageSlide4TitleLabelText //"Synchronisation"
        slide4.slideDescription.text = self.screenLabelLocalizeUtils.pagerSlide4LabelText
        
        let slide5 = Slide(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        slide5.slideImage.image = UIImage(named: "couple-couch-slide-1")
        slide5.slideTitle.text = self.screenLabelLocalizeUtils.pageSlide5TitleLabelText //"C'est parti !"
        slide5.slideDescription.text = self.screenLabelLocalizeUtils.pagerSlide5LabelText
        
        return [slide1, slide2, slide3, slide4, slide5]
    }
    
    private func configureScrollView(){
        scrollView.contentSize = CGSize(width: view.frame.size.width * 5, height: scrollView.frame.size.height
        )
        scrollView.isPagingEnabled = true
        
        for x in 0..<self.slides.count {
            let page = UIView(frame: CGRect(x: CGFloat(x) * view.frame.size.width, y: 0, width: view.frame.size.width, height: view.frame.size.height))
            //page.backgroundColor = self.slidesColor[x]
            page.addSubview(self.slides[x])
            scrollView.addSubview(page)
        }
    }
    
    private func setUpFAB(){
        floatingActionButton.buttonImage = UIImage(systemName: "arrow.forward")
        floatingActionButton.size = CGFloat(60.0)
        floatingActionButton.plusColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        floatingActionButton.buttonColor = .purple
        // These 2 lines trigger the handler of the first item without opening the floaty items menu
        floatingActionButton.handleFirstItemDirectly = true
        floatingActionButton.addItem(title: "") { (flb) in
            self.floatingActionButton.close()
            let appWindow = UIApplication.shared.windows[0]
            appWindow.rootViewController?.removeFromParent()
            appWindow.rootViewController = UINavigationController(rootViewController: LoginViewController())
            
            let options: UIView.AnimationOptions = .transitionCrossDissolve

            let duration: TimeInterval = 0.4

            UIView.transition(with: appWindow,
                              duration: duration,
                              options: options, animations: {}, completion: nil)
        }
        
        if(self.pageControl.currentPage != self.slides.count){
            self.floatingActionButton.isHidden = true
        }
        
        self.view.addSubview(floatingActionButton)
    }
    
}

extension OrchestraPager: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(floorf((Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width))))
        if pageControl.currentPage == self.slides.count - 1 {
            self.floatingActionButton.isHidden = false
        }
    }
}
