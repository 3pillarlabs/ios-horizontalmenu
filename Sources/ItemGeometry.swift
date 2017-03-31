//
//  ItemGeometry.swift
//  TPGHorizontalMenu
//
//  Created by David Livadaru on 07/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import UIKit

/// A data structure which has basic information for each menu item geometry.
open class ItemGeometry: NSObject {
    public enum VerticalAlignment {
        case top, center, bottom
    }
    
    /// The size of item. Default value is (width: 44.0, height: 44.0).
    open let size: CGSize
    /// Alignment of menu itme. Default value is center.
    public let verticalAlignment: VerticalAlignment
    
    public init(size: CGSize = CGSize(width: 44.0, height: 44.0),
                verticalAlignment: VerticalAlignment = .center) {
        self.size = size
        self.verticalAlignment = verticalAlignment
    }
}
