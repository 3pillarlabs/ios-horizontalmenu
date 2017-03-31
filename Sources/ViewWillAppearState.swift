//
//  ViewWillAppearState.swift
//  TPGHorizontalMenu
//
//  Created by David Livadaru on 15/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import UIKit
import GameplayKit

class ViewWillAppearState: ViewControllerState {
    override var validNextStates: [AnyClass] {
        return [AppearanceProgressState.self, ViewDidAppearState.self, ViewWillDisappearState.self,]
    }
    
    override func didEnter(from previousState: GKState?) {
        viewController.viewWillAppear(false)
    }
}
