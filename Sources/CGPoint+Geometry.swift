//
//  CGPoint+Geometry.swift
//  TPGHorizontalMenu
//
//  Created by David Livadaru on 07/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import Foundation

extension CGPoint: BasicArithmetic {
    /// Adds 2 points.
    ///
    /// - Parameters:
    ///   - lhs: left hand side point.
    ///   - rhs: right hand side point.
    /// - Returns: result point.
    public static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    /// Substracts 2 points.
    ///
    /// - Parameters:
    ///   - lhs: left hand side point.
    ///   - rhs: right hand side point.
    /// - Returns: result point.
    public static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    /// Multiplies a point with a floating-point number.
    ///
    /// - Parameters:
    ///   - lhs: the point.
    ///   - rhs: the floaing-point number.
    /// - Returns: result point.
    public static func *(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
    }
    
    /// Divides a point with a floating-point number.
    ///
    /// - Parameters:
    ///   - lhs: the point.
    ///   - rhs: the floaing-point number.
    /// - Returns: result point.
    public static func /(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x / rhs, y: lhs.y / rhs)
    }
}
