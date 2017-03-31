//
//  ViewDidDisappearState.swift
//  TPGHorizontalMenu
//
//  Created by David Livadaru on 15/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import UIKit
import GameplayKit

class ViewDidDisappearState: ViewControllerState {
    override var validNextStates: [AnyClass] {
        return [ViewDidLoadState.self]
    }
    
    override func didEnter(from previousState: GKState?) {
        viewController.viewDidDisappear(false)
    }
}
