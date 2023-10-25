//
//  ViewController.swift
//  Example
//
//  Created by JH on 2023/10/25.
//

import Cocoa
import SystemHUD

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
        
        SystemHUD.shared.configuration.image = NSImage(named: "Build")
        SystemHUD.shared.configuration.title = "Build Succeeded"
        SystemHUD.shared.show(delay: 1.0)
    }
    
    @IBAction func showBuildFailed(_ sender: Any) {
        SystemHUD.shared.configuration.image = NSImage(named: "Build")
        SystemHUD.shared.configuration.title = "Build Failed"
        SystemHUD.shared.show(delay: 1.0)
    }
}

