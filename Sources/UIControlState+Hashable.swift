//
//  UIControlState+Hashable.swift
//  TPGHorizontalMenu
//
//  Created by David Livadaru on 17/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import Foundation

extension UIControlState: Hashable {
    /// Compute hash value.
    public var hashValue: Int {
        return Int(rawValue) * 1024
    }
}
