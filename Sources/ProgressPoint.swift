//
//  ProgressPoint.swift
//  TPGHorizontalMenu
//
//  Created by David Livadaru on 07/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import Foundation

/// A type which provides a simple to compute a value based on 2 margins and a progress.
public protocol ProgressPoint {
    associatedtype Point: BasicArithmetic
    
    var first: Point { get }
    var second: Point { get }
    
    func pointProgress(with progress: CGFloat) -> Point
    func middlePoint() -> Point
}

public extension ProgressPoint {
    func pointProgress(with progress: CGFloat) -> Point {
        return first + (second - first) * progress
    }

    func middlePoint() -> Point {
        return pointProgress(with: 0.5)
    }
}
