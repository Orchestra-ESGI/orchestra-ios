//
//  MailComposer.swift
//  Orchestra
//
//  Created by Nassim Morouche on 27/06/2021.
//

import Foundation
import UIKit
import MessageUI

class MailComposer {
    
    static func setupMailController(mfMailVC: MFMailComposeViewController, subject: String) {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        let email = UserDefaults.standard.string(forKey: "email") ?? ""
        let screenSize = UIScreen.main.bounds.size
        let recipient = "orchestra.nrv.dev@gmail.com"

        let mailTemplate =
        """
            <span style='font - size : 1.1em '>%@</span><br>
            <br><br><br><br>
            <hr>
            <span style='color : grey; font - size : .8 '>
            Debug information:<br><br>
            Registered Email: %@<br>
            Build version: %@<br>
            Device model: %@<br>
            Screen size: %d * %d<br>
            OS version: %@<br>
            UI language: %@</span>
        """

        mfMailVC.setToRecipients([recipient])
        mfMailVC.setSubject(subject)
        mfMailVC.setMessageBody(String.init(format: mailTemplate, "", email, version,
                                            UIDevice.modelName, Int(screenSize.width), Int(screenSize.height),
                                            UIDevice.current.systemVersion, Locale.current.identifier), isHTML: true)
    }
}
