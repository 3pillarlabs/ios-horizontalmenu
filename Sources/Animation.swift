//
//  Animation.swift
//  TPGHorizontalMenu
//
//  Created by David Livadaru on 10/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import UIKit

/// A class which provides and abstraction for an animation
///
/// - seealso: 
///   [UIView - animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:]
///   (apple-reference-documentation://hcEaMPVO1d)
public class Animation: NSObject {
    public typealias AnimationClosure = () -> Void
    public typealias CompletionClosure = ((_ finished: Bool) -> Void)
    
    /// Animation's duration in seconds.
    public let duration: TimeInterval
    /// The amount of time to wait before animation begins. The time is specifed in seconds.
    public let delay: TimeInterval
    /// An object which provides facility to use dynamics for animation.
    public let dynamics: AnimationDynamics?
    /// Animation's options.
    public let options: UIViewAnimationOptions
    /// Closure where changes will be performed using an animation.
    public private (set) var animation: AnimationClosure?
    /// Closure which specifies the end of animation.
    public private (set) var completion: CompletionClosure?
    
    /// Property which says if the animation is in progress or not.
    public private (set) var inProgress: Bool = false
    
    /// Create an animation with specified parameters.
    ///
    /// - Parameters:
    ///   - duration: duration in seconds.
    ///   - delay: the amount of time to wait before animation begins. The time is specifed in seconds.
    ///   - dynamics: an object which provides facility to use dynamics for animation.
    ///   - options: animation's options.
    ///   - animation: closure where changes will be performed using an animation.
    ///   - completion: closure which specifies the end of animation.
    public init(duration: TimeInterval, delay: TimeInterval = 0.0, dynamics: AnimationDynamics? = nil,
                options: UIViewAnimationOptions = [], animation: AnimationClosure? = nil,
                completion: CompletionClosure? = nil) {
        self.duration = duration
        self.delay = delay
        self.dynamics = dynamics
        self.options = options
        self.animation = animation
        self.completion = completion
        
        super.init()
    }
    
    public func addAnimation(_ animation: @escaping AnimationClosure) {
        let currentAnimation = self.animation
        self.animation = {
            currentAnimation?()
            animation()
        } as Animation.AnimationClosure
    }
    
    public func addCompletion(_ completion: @escaping CompletionClosure) {
        let currentCompletion = self.completion
        self.completion = { finished in
            currentCompletion?(finished)
            completion(finished)
        }
    }
    
    /// Performs animation using the provided properties. Must be called on main queue.
    public func animate() {
        inProgress = true
        let animation = self.animation
        let completion = { [weak self] (_ finished: Bool) in
            guard let strongSelf = self else { return }
            
            strongSelf.inProgress = false
            strongSelf.completion?(finished)
        }
        if let dynamics = dynamics {
            UIView.animate(withDuration: duration, delay: delay,
                           usingSpringWithDamping: dynamics.dampingRatio,
                           initialSpringVelocity: dynamics.velocity, options: options, animations: {
                            animation?()
            }, completion: completion)
        } else {
            UIView.animate(withDuration: duration, delay: delay, options: options, animations: {
                animation?()
            }, completion: completion)
        }
    }
}
