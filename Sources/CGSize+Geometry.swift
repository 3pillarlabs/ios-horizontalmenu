//
//  CGSize+Geometry.swift
//  TPGHorizontalMenu
//
//  Created by David Livadaru on 07/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import Foundation

extension CGSize {
    /// Changes the size with provided insets.
    /// 
    /// If insets.left + insets.right > 0, the width will decrease
    /// If insets.left + insets.right < 0, the width will increase
    ///
    ///
    /// If insets.top + insets.bottom > 0, the height will decrease
    /// If insets.top + insets.bottom < 0, the height will increase
    ///
    /// - Parameter insets: the insets used for change.
    /// - Returns: inseted size.
    public func insetBy(_ insets: UIEdgeInsets) -> CGSize {
        return CGSize(width: width - (insets.left + insets.right),
                      height: height - (insets.top + insets.bottom))
    }
}
