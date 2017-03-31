//
//  Array+IndexValidation.swift
//  TPGHorizontalMenu
//
//  Created by David Livadaru on 14/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import Foundation

extension Array {
    /// Check if the index within the range of valid indexes.
    ///
    /// - Parameter index: the index to check.
    /// - Returns: `true` if index within array bounds [0, count), `false` otherwise.
    public func isValid(index: Int) -> Bool {
        return index >= startIndex && index < endIndex
    }
}
