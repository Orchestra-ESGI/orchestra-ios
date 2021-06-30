//
//  MenuTableViewController.swift
//  Orchestra
//
//  Created by Nassim Morouche on 27/06/2021.
//

import Foundation
import UIKit
import StoreKit
import MessageUI
import RxSwift
import FontAwesome_swift

private enum MenuActions {
    case none
    case about, rate, contact
    case libs, cgu, privacy
    case share, signout, delete
}

private enum MenuDataKeys: String {
    case title, action, isVisible
    case spaces, prefix, style
}

class MenuTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    let reusableCellName = "MenuCell"
    private var data: [[[MenuDataKeys: Any]]]?
    var headerView: UIView?
    var emailLabel = UILabel()
    
    let progressUtils = ProgressUtils.shared
    let notificationUtils = NotificationsUtils.shared
    
    // - MARK: Services
    let userVM = UsersViewModel()
    let disposeBag = DisposeBag()
    
    let screenLocalize = ScreensLabelLocalizableUtils.shared
    
    init() {
        super.init(style: .grouped)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDataSource()
        initNavigation()
        initTableView()
        initHeader()
        initFooter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailLabel.text = UserDefaults.standard.object(forKey: "email") as? String ?? ""
    }
    
    func initNavigation() {
        self.navigationItem.title = self.screenLocalize.settingsTitle
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
    }
    
    func initTableView() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.reusableCellName)
        self.tableView.separatorStyle = .singleLine
        self.tableView.backgroundColor = ColorUtils.ORCHESTRA_BLUE_COLOR
        self.tableView.showsVerticalScrollIndicator = false
    }
    
    func initDataSource() {
        // array of sections
        //      each section is an array of rows
        //          each row is a dictionary.
        //
        // if not specified .isVisible == true
        //
        self.data = [
            [
                [.title: self.screenLocalize.settingsRateUs, .action: MenuActions.rate, .prefix: FontAwesome.star, .style: FontAwesomeStyle.solid],
                [.title: self.screenLocalize.settingsShare, .action: MenuActions.share, .prefix: FontAwesome.share, .style: FontAwesomeStyle.solid]
            ],
            [
                [ .title: self.screenLocalize.settingsAbout, .action: MenuActions.about, .prefix: FontAwesome.users, .style: FontAwesomeStyle.solid],
                [ .title: self.screenLocalize.settingsContact, .action: MenuActions.contact, .prefix: FontAwesome.envelope, .style: FontAwesomeStyle.solid]
            ],
            [
                [ .title: self.screenLocalize.settingsLibraries, .action: MenuActions.libs, .prefix: FontAwesome.book, .style: FontAwesomeStyle.solid]
            ],
            [
                [ .title: self.screenLocalize.settingsPrivacy, .action: MenuActions.privacy, .prefix: FontAwesome.userShield, .style: FontAwesomeStyle.solid],
                [ .title: self.screenLocalize.settingsCgu, .action: MenuActions.cgu, .prefix: FontAwesome.fileContract, .style: FontAwesomeStyle.solid]
            ],
            [
                [ .title: self.screenLocalize.settingsSignout, .action: MenuActions.signout, .prefix: FontAwesome.signOutAlt, .style: FontAwesomeStyle.solid],
                [ .title: self.screenLocalize.settingsDeleteAccount, .action: MenuActions.delete, .prefix: FontAwesome.trash, .style: FontAwesomeStyle.solid]
            ]
        ]
    }
    
    func rateApp() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()

        } else if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "appId") {
                UIApplication.shared.openURL(url)
        }
    }
    
    func shareApp() {
        let firstActivityItem = self.screenLocalize.settingsShareTitle
        let secondActivityItem : NSURL = NSURL(string: "https://www.orchestra-app.com/")!
        
        let image : UIImage = UIImage(named: "app-icon-480")!
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem, image], applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        activityViewController.activityItemsConfiguration = [
            UIActivity.ActivityType.message
        ] as? UIActivityItemsConfigurationReading
        
        activityViewController.excludedActivityTypes = [
            .postToWeibo,
            .print,
            .assignToContact,
            .saveToCameraRoll,
            .addToReadingList,
            .postToFlickr,
            .postToVimeo,
            .postToTencentWeibo,
            .postToFacebook
        ]
        
        activityViewController.isModalInPresentation = true
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func contact() {
        if MFMailComposeViewController.canSendMail() {
            let mailController = MFMailComposeViewController()
            mailController.mailComposeDelegate = self
            
            MailComposer.setupMailController(
                mfMailVC: mailController,
                subject: self.screenLocalize.mailSettingsSubject
            )

            present(mailController, animated: true, completion: nil)
        }
        else {
            // Email is not configured
            let alert = UIAlertController(
                title: nil,
                message: self.screenLocalize.mailErrorConfiguration,
                preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction.init(title: self.screenLocalize.objectInfoOkButtonLabelText,
                                               style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func createWebViewVC(pageTitle: String, url: String) -> GenericWebViewController {
        let webViewVC = GenericWebViewController(pageTitle: pageTitle, url: url)
        return webViewVC
    }
    
    func signoutPopup() {
        let alertController = UIAlertController(
            title: nil,
            message: self.screenLocalize.settingsAlertSignoutMessage,
            preferredStyle: .alert)
        
        let signoutAction = UIAlertAction(title: self.screenLocalize.settingsAlertSignoutActionTitle,
                                          style: .default) { _ in
            self.signout()
        }
        
        let cancelAction = UIAlertAction(title: self.screenLocalize.settingsAlertCancelTitle,
                                         style: .cancel, handler: nil)
        
        alertController.addAction(signoutAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func signout() {
        UserDefaults.standard.removeObject(forKey: "bearer-token")
        UserDefaults.standard.removeObject(forKey: "email")
        
        let appWindow = UIApplication.shared.windows[0]
        appWindow.rootViewController?.removeFromParent()
        appWindow.rootViewController = UINavigationController(rootViewController: LoginViewController())
        
        let options: UIView.AnimationOptions = .transitionCrossDissolve

        let duration: TimeInterval = 0.4

        UIView.transition(with: appWindow,
                          duration: duration,
                          options: options, animations: {}, completion: nil)
    }
    
    func deleteAccountPopup() {
        //delete account
        let alertController = UIAlertController(
            title: nil,
            message: self.screenLocalize.settingsAlertDeleteMessage,
            preferredStyle: .alert)
        
        let deleteAccountAction = UIAlertAction(title: self.screenLocalize.settingsAlertDeleteActionTitle
                                                , style: .destructive) { _ in
            self.progressUtils.displayV2(view: self.view, title: "", modeView: .MRActivityIndicatorView)
            self.deleteAccount()
        }
        
        let cancelAction = UIAlertAction(title: self.screenLocalize.settingsAlertCancelTitle, style: .cancel, handler: nil)
        
        alertController.addAction(deleteAccountAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func deleteAccount() {
        let userMail = UserDefaults.standard.object(forKey: "email") as? String ?? ""
        _ = self.userVM
            .deleteAccount(email: userMail)
            .subscribe { (ex) in
                self.progressUtils.dismiss()
                self.signout()
            } onError: { (err) in
                self.notificationUtils.handleErrorResponseNotification(err as! ServerError)
                self.progressUtils.dismiss()
            }
            .disposed(by: self.disposeBag)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.data?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data?[section].count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let isVisible = self.data?[indexPath.section][indexPath.row][MenuDataKeys.isVisible] as? Bool, !isVisible {
            return 0
        }
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: self.reusableCellName) as UITableViewCell? ?? UITableViewCell()
        let rowData: [MenuDataKeys: Any]? = self.data?[indexPath.section][indexPath.row]
        let text = rowData?[MenuDataKeys.title] as? String ?? ""
        
        cell.textLabel?.font = Font.Regular(17)
        
        if let prefix = rowData?[MenuDataKeys.prefix] as? FontAwesome,
           let style = rowData?[MenuDataKeys.style] as? FontAwesomeStyle {
            let size = CGSize(width: 20.0, height: 20.0)
            cell.imageView?.image = UIImage.fontAwesomeIcon(name: prefix, style: style, textColor: .white, size: size)
        }
        cell.textLabel?.text = text
        
        if rowData?[MenuDataKeys.action] as! MenuActions == .delete {
            cell.textLabel?.textColor = ColorUtils.ORCHESTRA_RED_COLOR
        } else {
            cell.textLabel?.textColor = .white
        }

        cell.accessoryType = .disclosureIndicator
        cell.clipsToBounds = true

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var vc: UIViewController?
        let rowData: [MenuDataKeys: Any]? = self.data?[indexPath.section][indexPath.row]
        let title = rowData?[MenuDataKeys.title] as? String ?? ""
        let action = rowData?[MenuDataKeys.action] as? MenuActions ?? .none
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch(action) {
        case .rate:
            self.rateApp()
            break
        case .share:
            self.shareApp()
            break
        case .about:
            vc = createWebViewVC(pageTitle: title, url: "https://www.google.com")
            break
        case .contact:
            self.contact()
            break
        case .libs:
            vc = nil
            break
        case .privacy:
            vc = createWebViewVC(pageTitle: title, url: "https://www.google.com")
            break
        case .cgu:
            vc = createWebViewVC(pageTitle: title, url: "https://www.google.com")
            break
        case .signout:
            self.signoutPopup()
            break
        case .delete:
            self.deleteAccountPopup()
            break
        default:
            vc = nil
        }

        if let nextScreen = vc {
            self.navigationController?.pushViewController(nextScreen, animated: true)
        }
    }
    
    // MARK: - Header related
    func initHeader() {
        let headerBaseView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.contentSize.width, height: 160))
        headerBaseView.clipsToBounds = true
        self.tableView.tableHeaderView = headerBaseView

        headerView = UIView(frame: CGRect.zero)
        guard let headerView = self.headerView else { return }
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addBottomSeparator(color: .lightGray)
        headerBaseView.addSubview(headerView)
        
        headerView.topAnchor.constraint(equalTo: headerBaseView.topAnchor).isActive = true
        headerView.leftAnchor.constraint(equalTo: headerBaseView.leftAnchor).isActive = true
        headerView.rightAnchor.constraint(equalTo: headerBaseView.rightAnchor).isActive = true
        headerView.bottomAnchor.constraint(equalTo: headerBaseView.bottomAnchor).isActive = true
        

        self.initHeaderSubviews()
    }
    
    func initHeaderSubviews() {
        guard let headerView = self.headerView else { return }

        // app icon with circle border
        let imageView = UIImageView(image: UIImage(named: "app-icon-orchestra"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(imageView)

        // email label
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.textColor = .white
        emailLabel.textAlignment = .center
        emailLabel.font = Font.Regular(17)
        emailLabel.text = UserDefaults.standard.object(forKey: "email") as? String ?? ""
        headerView.addSubview(emailLabel)
        
        imageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: -10).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: emailLabel.topAnchor, constant: 40).isActive = true
        
        emailLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor).isActive = true
        emailLabel.rightAnchor.constraint(equalTo: headerView.rightAnchor).isActive = true
        emailLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    // MARK: - Footer related
    func initFooter() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 50))

        // app version
        let versionLabel = UILabel()
        versionLabel.textAlignment = .center
        versionLabel.font = Font.Regular(17)
        versionLabel.textColor = .white
        if let versionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] {
            versionLabel.text = "v \(versionString)"
        }
        
        footerView.addSubview(versionLabel)
        
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        versionLabel.leftAnchor.constraint(equalTo: footerView.leftAnchor).isActive = true
        versionLabel.rightAnchor.constraint(equalTo: footerView.rightAnchor).isActive = true
        versionLabel.bottomAnchor.constraint(equalTo: footerView.bottomAnchor).isActive = true
        
        self.tableView.tableFooterView = footerView
    }
}
