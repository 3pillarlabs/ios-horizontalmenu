//
//  AnimationDynamics.swift
//  TPGHorizontalMenu
//
//  Created by David Livadaru on 22/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import Foundation

/// An abstraction for dynamics which can be used with an animation.
public struct AnimationDynamics {
    /// The damping ratio for the spring animation as it approaches its quiescent state.
    /// To smoothly decelerate the animation without oscillation, use a value of 1. Employ a damping ratio closer to zero to increase oscillation
    public let dampingRatio: CGFloat
    /// The initial spring velocity. For smooth start to the animation, match this value to the view’s velocity as it was prior to attachment.
    ///
    /// A value of 1 corresponds to the total animation distance traversed in one second. 
    ///
    /// For example, if the total animation distance is 200 points and you want the start of the animation to match a view velocity of 100 pt/s, use a value of 0.5.
    public let velocity: CGFloat
}
