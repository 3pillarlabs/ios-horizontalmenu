//
//  DisappearanceProgressState.swift
//  TPGHorizontalMenu
//
//  Created by David Livadaru on 15/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import UIKit
import GameplayKit

class DisappearanceProgressState: ViewControllerState {
    override var validNextStates: [AnyClass] {
        return [DisappearanceProgressState.self, ViewDidDisappearState.self, ViewWillAppearState.self]
    }
    
    // MARK: - Internal interface
    
    func update(progress: CGFloat) {
        if let menuChild = viewController as? HorizontalMenuChild {
            menuChild.disappearanceProgress?(progress: progress)
        }
    }
}
