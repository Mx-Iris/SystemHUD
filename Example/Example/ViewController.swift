//
//  ViewController.swift
//  Example
//
//  Created by JH on 2023/10/25.
//

import Cocoa
import SystemHUD
import SFSymbol

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func showBuildSuccessed(_ sender: Any) {
//        SystemHUD.shared.configuration = SystemHUD.shared.configuration.with {
//            $0.image = SFSymbol(name: .checkmarkCircle).pointSize(80, weight: .regular).nsImage
//            $0.title = "Load Successed"
//            $0.imageSpacing = 20
//        }
        SystemHUD.default.configuration.image = NSImage(named: "Build")
        SystemHUD.default.configuration.title = "Build Succeeded"
        SystemHUD.default.configuration.offset = .init(x: 0, y: 5)
        SystemHUD.default.show(delay: 1.0)
    }
    
    @IBAction func showBuildFailed(_ sender: Any) {
        SystemHUD.default.configuration.image = NSImage(named: "Build")
        SystemHUD.default.configuration.title = "Build Failed"
        SystemHUD.default.show(delay: 1.0)
    }
}

extension SystemHUD.Configuration: Then {}
