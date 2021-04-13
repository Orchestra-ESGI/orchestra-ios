//
//  ObjectInfoViewController.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 07/04/2021.
//

import UIKit
import RxCocoa
import RxSwift

class ObjectInfoViewController: UIViewController {
    
    // MARK: - UI
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var onOffButton: UIButton!
    @IBOutlet weak var caracteristicsTableView: UITableView!
    
    
    // MARK: - Local data
    var objectData: ObjectDto?
    var disposeBag = DisposeBag()
    let favClicStream = PublishSubject<String>()
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<HeaderItem, ListItem>!
    var objectInfoKeyValue: [String: String] = [:]
    var objectInfoNames: [String] = []
    
    var favButton: UIBarButtonItem?
    var okButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpUI()
        self.setUpData()
        self.setUpClickObservers()
    }

    private func setUpUI(){
        let isObjectFavourite = self.objectData?.isFav
        let favIcon = isObjectFavourite ?? false ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        
        okButton = UIBarButtonItem(title: "OK", style: .plain, target: self, action: nil)
        favButton = UIBarButtonItem(image: favIcon, style: .plain, target: self, action: nil)
        
        self.navigationItem.rightBarButtonItems = [okButton!, favButton!]
        guard let objectName = self.objectData?.name else {
            return
        }
        
        self.navigationItem.title = objectName
        
        self.caracteristicsTableView.delegate = self
        self.caracteristicsTableView.dataSource = self
        self.caracteristicsTableView.layer.masksToBounds = true
        self.caracteristicsTableView.register(UINib(nibName: "ObjectInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "CHAR_CELL")
        self.caracteristicsTableView.tableFooterView = UIView()
        
        self.onOffButton.layer.cornerRadius = 8.0
        self.tableViewContainer.layer.cornerRadius = 12.0
        self.tableViewContainer.layer.masksToBounds = true

    }
    
    private func setUpData(){
        self.objectInfoNames = ["Fabricant", "Série", "Modèle", "Version", "Disponibilite"]
        
        self.objectInfoKeyValue["Fabricant"] = self.objectData?.manufacturer
        self.objectInfoKeyValue["Série"] = self.objectData?.serialNumber
        self.objectInfoKeyValue["Modèle"] = self.objectData?.model
        self.objectInfoKeyValue["Version"] = self.objectData?.version
        self.objectInfoKeyValue["Disponibilite"] = "Disponible"
    }
    
    private func setUpClickObservers(){
        self.onOffButton
            .rx
            .tap.bind{
                guard let isOn = self.objectData?.isOn else{
                    return
                }
                self.onOffButton.backgroundColor = isOn ? #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1) : #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
                self.objectData?.isOn = !isOn
            }.disposed(by: self.disposeBag)
        
        self.favButton?
            .rx
            .tap.bind{
                guard let isFav = self.objectData?.isFav else{
                    return
                }
                
                let isFavIcon = !isFav ?
                    UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
                self.favButton?.image = isFavIcon
                self.favClicStream.onNext(self.objectData?._id ?? "")
            }.disposed(by: self.disposeBag)
        
        self.okButton?
            .rx
            .tap.bind{
                self.dismiss(animated: true, completion: nil)
        }.disposed(by: self.disposeBag)

    }
    
}


extension ObjectInfoViewController: UITableViewDelegate{
    
}

extension ObjectInfoViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CHAR_CELL") as? ObjectInfoTableViewCell
        let objectCurrentInfo = self.objectInfoNames[indexPath.row]
        
        cell?.objectInfoName.text = objectCurrentInfo
        cell?.objectInfoValue?.text = self.objectInfoKeyValue[objectCurrentInfo]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if (cell.responds(to: #selector(getter: UIView.tintColor))){
            if tableView == self.caracteristicsTableView {
                let cornerRadius: CGFloat = 12.0
                cell.backgroundColor = .darkGray
                let layer: CAShapeLayer = CAShapeLayer()
                let path: CGMutablePath = CGMutablePath()
                let bounds: CGRect = cell.bounds
                bounds.insetBy(dx: 25.0, dy: 0.0)
                var addLine: Bool = false

                if indexPath.row == 0 && indexPath.row == ( tableView.numberOfRows(inSection: indexPath.section) - 1) {
                    path.addRoundedRect(in: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)

                } else if indexPath.row == 0 {
                    path.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
                    path.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.minY), tangent2End: CGPoint(x: bounds.midX, y: bounds.minY), radius: cornerRadius)
                    path.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.minY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
                    path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))

                } else if indexPath.row == (tableView.numberOfRows(inSection: indexPath.section) - 1) {
                    path.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
                    path.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.midX, y: bounds.maxY), radius: cornerRadius)
                    path.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
                    path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))

                } else {
                    path.addRect(bounds)
                    addLine = true
                }

                layer.path = path
                layer.fillColor = UIColor.white.withAlphaComponent(0.8).cgColor

                if addLine {
                    let lineLayer: CALayer = CALayer()
                    let lineHeight: CGFloat = 1.0 / UIScreen.main.scale
                    lineLayer.frame = CGRect(x: bounds.minX + 10.0, y: bounds.size.height - lineHeight, width: bounds.size.width, height: lineHeight)
                    lineLayer.backgroundColor = tableView.separatorColor?.cgColor
                    layer.addSublayer(lineLayer)
                }

                let testView: UIView = UIView(frame: bounds)
                testView.layer.insertSublayer(layer, at: 0)
                testView.backgroundColor = .clear
                cell.backgroundView = testView
            }
        }
    }
    
}
