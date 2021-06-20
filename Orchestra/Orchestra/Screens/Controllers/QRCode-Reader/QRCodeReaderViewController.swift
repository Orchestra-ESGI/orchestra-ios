//
//  QRCodeReaderViewController.swift
//  Orchestra
//
//  Created by Nassim Morouche on 20/06/2021.
//

import AVFoundation
import UIKit
import SPPermissions

class QRCodeReaderViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession!
    
    private let labelLocalize = ScreensLabelLocalizableUtils.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        

        if (SPPermission.camera.isDenied) {
            let alert = UIAlertController(title: self.labelLocalize.permissionsCameraErrorAlertTitle, message: self.labelLocalize.permissionsCameraErrorAlertDescription, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { action in
                self.navigationController?.popViewController(animated: true)
                if let bundleIdentifier = Bundle.main.bundleIdentifier, let appSettings = URL(string: UIApplication.openSettingsURLString + bundleIdentifier) {
                    if UIApplication.shared.canOpenURL(appSettings) {
                        UIApplication.shared.open(appSettings)
                    }
                }
            })
            alert.addAction(defaultAction)

            self.present(alert, animated: true)
        }
        
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        let qrCodeOverlayPreviewLayer = QRCodeReaderOverlay(session: captureSession)
        qrCodeOverlayPreviewLayer.frame = self.view.bounds
        qrCodeOverlayPreviewLayer.maskSize = CGSize(width: 300, height: 300)
        qrCodeOverlayPreviewLayer.lineWidth = 8.0
        qrCodeOverlayPreviewLayer.lineColor = ColorUtils.ORCHESTRA_RED_COLOR
        qrCodeOverlayPreviewLayer.cornerLength = 30
        qrCodeOverlayPreviewLayer.backgroundColor = ColorUtils.ORCHESTRA_BLUE_COLOR.withAlphaComponent(0.4).cgColor
        qrCodeOverlayPreviewLayer.videoGravity = .resizeAspectFill
        metadataOutput.rectOfInterest = qrCodeOverlayPreviewLayer.rectOfInterest
        self.view.layer.addSublayer(qrCodeOverlayPreviewLayer)
        
        captureSession.startRunning()
    }

    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
    }

    func found(code: String) {
        let data = Data(code.utf8)

        do {
            // make sure this JSON is in the format we expect
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                // try to read out a string array
                guard let page = json["page"] as? String,
                      let key = json["key"] as? String else { return }
                if key != "orchestra" {
                    return
                }
                switch page {
                case "signup":
                    self.navigationController?.pushViewController(SignupViewController(), animated: true)
                    break
                default:
                    break
                }
            }
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

}
