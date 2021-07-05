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
        pc.currentPageIndicatorTintColor = .red
        return pc
    }()
    
    private let scrollView = UIScrollView()
    private var slides: [UIView] = []
    private let floatingActionButton = Floaty()
    
    // MARK: - Utils
    let labelLocalization = ScreensLabelLocalizableUtils.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        pageControl.addTarget(self,
                              action: #selector(self.pageControlDidChanged(_:)),
                              for: .valueChanged)
        self.slides = createSlides()
        scrollView.backgroundColor = .black
        view.addSubview(pageControl)
        view.addSubview(scrollView)
        view.bringSubviewToFront(pageControl)
        self.configureScrollView()
        self.setUpFAB()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc private func pageControlDidChanged(_ sender: UIPageControl){
        let current = sender.currentPage
        scrollView.setContentOffset(CGPoint(x: CGFloat(current) * view.frame.size.width, y: 0), animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pageControl.frame = CGRect(x: 10, y: view.frame.size.height - 100, width: view.frame.size.width - 20, height: 70)
        
        if scrollView.subviews.count == 2{
            configureScrollView()
        }
    }
    
    func createSlides() -> [UIView] {
        // Create sldies for the pager
        let slide1 = Slide(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        slide1.slideImage.image = UIImage(named: "simplicite")
        slide1.slideTitle.text = self.labelLocalization.pageSlide1TitleLabelText //"Simplicité"
        slide1.slideDescription.text = self.labelLocalization.pagerSlide1LabelText
        
        let slide2 = Slide(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        slide2.slideImage.image = UIImage(named: "connected-house")
        slide2.slideTitle.text = self.labelLocalization.pageSlide2TitleLabelText //"Efficacité"
        slide2.slideDescription.text = self.labelLocalization.pagerSlide2LabelText
        
        let slide3 = Slide(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        slide3.slideImage.image = UIImage(named: "hub-mess")
        slide3.slideTitle.text = self.labelLocalization.pageSlide3TitleLabelText // "Clarté"
        slide3.slideDescription.text = self.labelLocalization.pagerSlide3LabelText
        
        let slide4 = Slide(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        slide4.slideImage.image = UIImage(named: "hand-phone")
        slide4.slideTitle.text = self.labelLocalization.pageSlide4TitleLabelText //"Synchronisation"
        slide4.slideDescription.text = self.labelLocalization.pagerSlide4LabelText
        
        let slide5 = Slide(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        slide5.slideImage.image = UIImage(named: "lets-go")
        slide5.slideTitle.text = self.labelLocalization.pageSlide5TitleLabelText //"C'est parti !"
        slide5.slideDescription.text = self.labelLocalization.pagerSlide5LabelText
        
        return [slide1, slide2, slide3, slide4, slide5]
    }
    
    private func configureScrollView(){
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        scrollView.contentSize = CGSize(width: view.frame.size.width * 5, height: 100)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        for x in 0..<self.slides.count {
            let page = UIView(frame: CGRect(x: CGFloat(x) * view.frame.size.width, y: 0, width: view.frame.size.width, height: view.frame.size.height))
            //page.backgroundColor = self.slidesColor[x]
            page.addSubview(self.slides[x])
            scrollView.addSubview(page)
        }
    }
    
    private func setUpFAB(){
        floatingActionButton.buttonImage = UIImage(systemName: "chevron.right")
        floatingActionButton.size = CGFloat(60.0)
        floatingActionButton.plusColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        floatingActionButton.buttonColor = .red
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
        if(scrollView.frame.size.width > 0){
            pageControl.currentPage = Int(floorf((Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width))))
            if pageControl.currentPage == self.slides.count - 1 {
                self.floatingActionButton.isHidden = false
            }
        }
    }
}
