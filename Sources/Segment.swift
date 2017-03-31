//
//  Segment.swift
//  TPGHorizontalMenu
//
//  Created by David Livadaru on 07/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import Foundation

/// A data structure which provides and implementation for ProgressPoint.
public struct Segment<SegmentPoint: BasicArithmetic>: ProgressPoint {
    public typealias Point = SegmentPoint
    
    public let first: SegmentPoint
    public let second: SegmentPoint
}
