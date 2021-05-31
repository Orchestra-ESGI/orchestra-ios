//
//  SceneDetailViewController.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 17/04/2021.
//

import UIKit
import RxCocoa
import RxSwift
import Floaty

class SceneDetailViewController: UIViewController {

    // MARK: UI
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var actionsLabel: UILabel!
    @IBOutlet weak var actionsTableView: UITableView!
    
    var editSceneButton: UIBarButtonItem?
    
    // MARK: Utils
    let colorUtils = ColorUtils.shared
    let progressUtils = ProgressUtils.shared
    let localizeLabels = ScreensLabelLocalizableUtils.shared
    
    // MARK: Local data
    var sceneData: SceneDto?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
        self.setUpClickObserver()
        self.setUpTableView()
    }
    
    // MARK: UI setup
    private func setUpUI(){
        self.setUpTopBar()
        self.setUpLabels()
        self.setUpFAB()
        
        self.descriptionTextView.layer.borderWidth = 0.5
        self.descriptionTextView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.descriptionTextView.layer.cornerRadius = 8.0
    }
    
    private func setUpTopBar(){
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : self.colorUtils.hexStringToUIColor(hex: (self.sceneData?.backgroundColor)!)]

        self.navigationController?.navigationBar.barTintColor = self.colorUtils.hexStringToUIColor(hex: (self.sceneData?.backgroundColor)!)
        self.title = self.sceneData?.title
        
        //editSceneButton = UIBarButtonItem(title: "Éditer", style: .done, target: self, action: nil)
        if #available(iOS 14.0, *) {
            editSceneButton = UIBarButtonItem(systemItem: .edit)
        } else {
            // Fallback on earlier versions
            editSceneButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: nil)
        }
        editSceneButton?.tintColor = #colorLiteral(red: 2.387956192e-05, green: 0.5332912803, blue: 0.8063663244, alpha: 1)
        self.navigationItem.rightBarButtonItems = [editSceneButton!]
    }
    
    private func setUpFAB(){
        
        let floatingActionButton = Floaty()
        floatingActionButton.buttonImage = UIImage(systemName: "play.fill")
        floatingActionButton.size = CGFloat(60.0)
        floatingActionButton.plusColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        floatingActionButton.buttonColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        // These 2 lines trigger the handler of the first item without opening the floaty items menu
        floatingActionButton.handleFirstItemDirectly = true
        floatingActionButton.addItem(title: "") { (flb) in
            floatingActionButton.close()
            let alertTitle = self.localizeLabels.sceneInfoStartingSceneProgressAlertTitle
            self.progressUtils.displayIndeterminateProgeress(title: alertTitle, view: self.view)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.progressUtils.dismiss()
            }
        }
        
        self.view.addSubview(floatingActionButton)
    }
    
    
    // MARK: Setup Observers
    
    private func setUpClickObserver(){
        // Here set up click handling on UIButton
        _ = self.editSceneButton?
                .rx
                .tap.bind{
                print("Editing scene")
            }
    }
    
    private func setUpLabels(){
        self.descriptionTextView.text = self.sceneData?.sceneDescription
    }
    
    private func setUpTableView(){
        self.actionsTableView.delegate = self
        self.actionsTableView.dataSource = self
        self.actionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ACTION_CELL")
        self.actionsTableView.tableFooterView = UIView()
    }
    
}

extension SceneDetailViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sceneData?.actions.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ACTION_CELL")
        let currentAction = self.sceneData?.actions[indexPath.row]
        cell?.textLabel?.text = currentAction?.title
        
        return cell!
    }
    
    
}

extension SceneDetailViewController: UITableViewDelegate{
    
}
