//
//  ViewControllerState.swift
//  TPGHorizontalMenu
//
//  Created by David Livadaru on 15/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import UIKit
import GameplayKit

/// State subclass which are reponsible of calling view life cycle functions without causing unbalance.
/// For exmaple: from after viewDidLoad, viewDidAppear: cannot be called before viewWillAppear:.
class ViewControllerState: GKState {
    let viewController: UIViewController
    
    var validNextStates: [AnyClass] {
        return []
    }
    
    init(viewController: UIViewController) {
        self.viewController = viewController
        
        super.init()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return validNextStates.index(where: { $0 == stateClass }) != nil
    }
}
