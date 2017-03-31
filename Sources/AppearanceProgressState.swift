//
//  AppearanceProgressState.swift
//  TPGHorizontalMenu
//
//  Created by David Livadaru on 15/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import UIKit
import GameplayKit

class AppearanceProgressState: ViewControllerState {
    override var validNextStates: [AnyClass] {
        return [AppearanceProgressState.self, ViewDidAppearState.self, ViewWillDisappearState.self]
    }
    
    // MARK: - Internal interface
    
    func update(progress: CGFloat) {
        if let menuChild = viewController as? HorizontalMenuChild {
            menuChild.appearanceProgress?(progress: progress)
        }
    }
}
