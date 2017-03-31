//
//  Selectable.swift
//  TPGHorizontalMenu
//
//  Created by David Livadaru on 14/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import Foundation

/// An abstraction for selectting the menu item.
protocol Selectable {
    var isSelected: Bool { get set }
}

extension UIControl: Selectable {}
