//
//  BasicArithmetic.swift
//  TPGHorizontalMenu
//
//  Created by David Livadaru on 07/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import Foundation

public protocol BasicArithmetic {
    static func +(lhs: Self, rhs: Self) -> Self
    static func -(lhs: Self, rhs: Self) -> Self
    static func *(lhs: Self, rhs: CGFloat) -> Self
    static func /(lhs: Self, rhs: CGFloat) -> Self
}
