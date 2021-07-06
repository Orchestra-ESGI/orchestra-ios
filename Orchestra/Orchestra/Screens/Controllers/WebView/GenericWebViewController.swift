//
//  GenericWebViewController.swift
//  Orchestra
//
//  Created by Nassim Morouche on 28/06/2021.
//

import Foundation
import WebKit
import UIKit

class GenericWebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    var webView: WKWebView!
    var url: String = ""
    var pageTitle: String = ""
    
    @objc
    convenience init(pageTitle: String, url: String) {
        self.init()
        self.url = url
        self.pageTitle = pageTitle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initNavigation()
        self.loadWebView()
    }
    
    func initNavigation() {
        self.navigationItem.title = pageTitle
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
    }
    
    func loadWebView() {
        self.webView = WKWebView()
        self.webView.navigationDelegate = self
        
        let url = URL(string: self.url)!
        self.webView.load(URLRequest(url: url))
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.webView)
        
        self.webView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.webView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.webView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}
