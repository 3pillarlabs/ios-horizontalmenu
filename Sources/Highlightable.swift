//
//  Highlightable.swift
//  TPGHorizontalMenu
//
//  Created by David Livadaru on 14/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import Foundation

/// An abstraction for highlighting the menu item.
public protocol Highlightable {
    var isHighlighted: Bool { get set }
}

extension UILabel: Highlightable {}
extension UIImageView: Highlightable {}
extension UIControl: Highlightable {}
