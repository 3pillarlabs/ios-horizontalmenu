//
//  ViewWillDisappearState.swift
//  TPGHorizontalMenu
//
//  Created by David Livadaru on 15/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import UIKit
import GameplayKit

class ViewWillDisappearState: ViewControllerState {
    override var validNextStates: [AnyClass] {
        return [DisappearanceProgressState.self, ViewDidDisappearState.self, ViewWillAppearState.self]
    }
    
    override func didEnter(from previousState: GKState?) {
        viewController.viewWillDisappear(false)
    }
}
