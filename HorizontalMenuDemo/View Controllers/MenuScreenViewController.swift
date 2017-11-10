//
//  MenuScreenViewController.swift
//  HorizontalMenuDemo
//
//  Created by David Livadaru on 14/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import UIKit
import TPGHorizontalMenu

class MenuScreenViewController: UIViewController, HorizontalMenuChild {
    @IBOutlet weak var textLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("\(#function) - text: '\(textLabel.text ?? "unknown")'")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("\(#function) - text: '\(textLabel.text ?? "unknown")'")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("\(#function) - text: '\(textLabel.text ?? "unknown")'")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("\(#function) - text: '\(textLabel.text ?? "unknown")'")
    }
    
    // MARK: HorizontalMenuChild
    
    func appearanceProgress(progress: CGFloat) {
        print("\(#function) (\(progress))- text: '\(textLabel.text ?? "unknown")'")
    }
    
    func disappearanceProgress(progress: CGFloat) {
        print("\(#function) (\(progress))- text: '\(textLabel.text ?? "unknown")'")
    }
}
