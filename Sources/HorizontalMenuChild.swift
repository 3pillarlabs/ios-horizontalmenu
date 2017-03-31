//
//  HorizontalMenuChild.swift
//  TPGHorizontalMenu
//
//  Created by Horatiu Potra on 02/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import Foundation

@objc public protocol HorizontalMenuChild: class {
    /// When a user swipes. A screen will be dismissed and the other will be become visible.
    /// This callback is called after (viewWillAppear:) has been called and before (viewDidAppear:).
    ///
    /// - Parameter progress: the progress up to now.
    @objc optional func appearanceProgress(progress: CGFloat)
    /// When a user swipes. A screen will be dismissed and the other will be become visible.
    /// This callback is called after (viewWillDisappear:) has been called and before (viewDidDisappear:).
    ///
    /// - Parameter progress: the progress up to now.
    @objc optional func disappearanceProgress(progress: CGFloat)
}
