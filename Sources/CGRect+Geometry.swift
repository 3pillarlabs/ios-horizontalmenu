//
//  CGRect+Geometry.swift
//  TPGHorizontalMenu
//
//  Created by David Livadaru on 07/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import Foundation

extension CGRect {
    /// Computes the x offset for an index for a scrollable area with pagination.
    ///
    /// - Parameter index: page index.
    /// - Returns: x offset for page index.
    public func xAxisOffset(for index: Int) -> CGFloat {
        return width * CGFloat(index)
    }
    
    /// Convenience function to inset a rectangular area.
    ///
    /// - Parameter inset: the inset values.
    /// - Returns: A rectangle which has the requested changes.
    public func insetBy(_ inset: UIEdgeInsets) -> CGRect {
        let xInset = (inset.left + inset.right ) / 2
        let yInset = (inset.top + inset.bottom ) / 2
        
        return insetBy(dx: xInset, dy: yInset)
    }
}
