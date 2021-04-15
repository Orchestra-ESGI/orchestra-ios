//
//  SceneViewController.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 07/04/2021.
//

import UIKit
import RxCocoa
import RxSwift

class SceneViewController: UIViewController, UITextFieldDelegate {

    // MARK: - UI
    @IBOutlet weak var sceneNameLabel: UILabel!
    @IBOutlet weak var sceneNameTf: UITextField!
    @IBOutlet weak var sceneBackgroundColorLabel: UILabel!
    @IBOutlet weak var shuffleColorsButton: UIButton!
    @IBOutlet weak var backgroudColorsCollectionView: UICollectionView!
    
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var sceneDescriptionLabel: UILabel!
    @IBOutlet weak var sceneDescriptionTf: UITextField!
    @IBOutlet weak var addActionButton: UIButton!
    @IBOutlet weak var actionsTableView: UITableView!
    
    var addSceneAppbarButon: UIBarButtonItem?
    
    // MARK: Utils
    let localizeUtils = ScreensLabelLocalizableUtils()
    let notificationUtils = NotificationsUtils.shared
    let progressUtils = ProgressUtils.shared
    let notificationLocalize = NotificationLocalizableUtils.shared
    
    // MARK: Service
    let sceneWS = FakeSceneDataService.shared
    
    // MARK: - Local data
    var dataDelegate: SendBackDataProtocol?
    var isUpdating: Bool = false
    var sceneToEdit: SceneDto?
    var sceneColors: [UIColor] = []
    var sceneActions: [ActionSceneDto] = []
    var selectedColor = 0
    let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
        self.setUpData()
        self.setColorsCollectionView()
        self.setActionsTableView()
        self.generatesBackGroundColor()
        self.clickObservers()
        self.observStreamsEvent()
    }
    
    
    // MARK: Controller Setup
    
    private func setUpData(){
        self.sceneNameLabel.text = self.localizeUtils.sceneFormNameLabel
        self.sceneBackgroundColorLabel.text = self.localizeUtils.sceneFormBackgroundColorLabel
        self.sceneDescriptionLabel.text = self.localizeUtils.sceneFormDescriptionLabel
        self.addActionButton.setTitle(self.localizeUtils.addActionButtonnText, for: .normal)
        self.sceneDescriptionTf.placeholder = self.localizeUtils.sceneFormDescriptionTf
        self.sceneNameTf.placeholder = self.localizeUtils.sceneFormNameTf
        
        self.sceneNameTf.delegate = self
        self.sceneDescriptionTf.delegate = self
    }
    
    private func setUpUI(){
        let newSceneTitle = self.localizeUtils.newSceneVcTitle
        let updateSceneTitle = self.localizeUtils.updateSceneVcTitle
        self.title = self.isUpdating ? updateSceneTitle : newSceneTitle
        
        addSceneAppbarButon = UIBarButtonItem(image: UIImage(systemName: "paperplane.fill"), style: .done, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = addSceneAppbarButon
        
        self.viewContainer.frame.size.height = self.view.frame.height + 40
    }
    
    private func setColorsCollectionView(){
        self.backgroudColorsCollectionView.delegate = self
        self.backgroudColorsCollectionView.dataSource = self
        self.backgroudColorsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "COLOR_CELL")
    }
    
    private func setActionsTableView(){
        self.actionsTableView.delegate = self
        self.actionsTableView.dataSource = self
        self.actionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ACTION_CELL")
        
        self.actionsTableView.tableFooterView = UIView()
    }
    
    @IBAction func shuffleColors(_ sender: Any) {
        self.sceneColors.removeAll()
        self.generatesBackGroundColor()
        self.backgroudColorsCollectionView.reloadData()
    }
    
    
    // MARK: Observers Setup
    
    private func observStreamsEvent(){
        
    }
    
    private func clickObservers(){
        _ = self.addSceneAppbarButon?
            .rx
            .tap
            .bind{
                self.addSceneAppbarButon?.isEnabled = false
                self.progressUtils.displayV2(view: self.view, title: self.notificationLocalize.undeterminedProgressViewTitle, modeView: .MRActivityIndicatorView)
                let actions = [
                    ActionSceneDto(JSON: ["title": "Allumer les lampes"])!,
                    ActionSceneDto(JSON: ["title": "Allumer les lampes"])!,
                    ActionSceneDto(JSON: ["title": "Allumer les lampes"])!,
                    ActionSceneDto(JSON: ["title": "Allumer les lampes"])!,
                    ActionSceneDto(JSON: ["title": "Allumer les lampes"])!
                ]
                let sceneName = self.sceneNameTf.text!
                let sceneDescription = self.sceneDescriptionTf.text!
                let sceneBackGroundColor = self.sceneColors[self.selectedColor].description
                
                
                self.sceneWS
                    .createNewScene(name: sceneName,
                                    description: sceneDescription,
                                    color: sceneBackGroundColor, actions: actions)
                    .subscribe { (createdScene) in
                        self.dataDelegate?.saveScene(scene: createdScene)
                        self.progressUtils.dismiss()
                        self.navigationController?.popViewController(animated: true)
                    } onError: { (err) in
                        self.notificationUtils
                            .showFloatingNotificationBanner(
                                title: self.notificationLocalize.loginCredentialsWrongNotificationTitle,
                                subtitle: self.notificationLocalize.loginCredentialsWrongNotificationSubtitle,
                                position: .top, style: .warning)
                    }.disposed(by: self.disposebag)

        }
    }
    
    
    // MARK: Local functions
    
    private func generatesBackGroundColor(){
        var colorsSize = 5
        if(self.sceneToEdit != nil){
            //self.sceneColors.append((sceneToEdit?.backgroundColor)!)
        }else{
            colorsSize = 6
        }
        for _ in 0..<colorsSize{
            self.sceneColors
                .append(UIColor(red: .random(in: 0.2...1),
                                green: .random(in: 0.2...1),
                                blue: .random(in: 0.2...1),
                                alpha: 1.0)
                )
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}


protocol SendBackDataProtocol {
    func saveScene(scene: SceneDto)
    func updateScene(scene: SceneDto)
}
