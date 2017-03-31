//
//  ViewDidLoadState.swift
//  TPGHorizontalMenu
//
//  Created by David Livadaru on 15/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import UIKit

class ViewDidLoadState: ViewControllerState {
    override var validNextStates: [AnyClass] {
        return [ViewWillAppearState.self]
    }
}
