//
//  UIEdgeInsets+Geometry.swift
//  TPGHorizontalMenu
//
//  Created by David Livadaru on 07/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
    /// Computes the nevagation insets by applying - to each component.
    ///
    /// - Parameter value: insets.
    /// - Returns: changed insets.
    public static prefix func -(value: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(top: -value.top, left: -value.left, bottom: -value.bottom, right: -value.right)
    }
}
