//
//  UIControlState+Hashable.swift
//  TPGHorizontalMenu
//
//  Created by David Livadaru on 17/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import Foundation

extension UIControl.State: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}
