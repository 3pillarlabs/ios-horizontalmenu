//
//  MenuGeometry.swift
//  TPGHorizontalMenu
//
//  Created by David Livadaru on 07/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import UIKit

/// A data structure has information about the menu's layout.
open class MenuGeometry: NSObject {
    /// The inset between all items and menu bounds. Default is (top: 8.0, left: 8.0, bottom: 8.0, right: 8.0).
    let itemsInset: UIEdgeInsets
    /// The spacing between items. Default is 8.0.
    let itemSpacing: CGFloat
    /// The height of content where menu items are located. Default is 8.0.
    let prefferedHeight: CGFloat
    /// Geometry for scroll indicator view. Uses default values.
    let scrollIndicatorGeometry: ScrollIndicatorGeometry
    
    public init(itemsInset: UIEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0),
                itemSpacing: CGFloat = 8.0,
                prefferedHeight: CGFloat = 0.0,
                scrollIndicatorGeometry: ScrollIndicatorGeometry = ScrollIndicatorGeometry()) {
        self.itemsInset = itemsInset
        self.itemSpacing = itemSpacing
        self.prefferedHeight = prefferedHeight
        self.scrollIndicatorGeometry = scrollIndicatorGeometry
        
        super.init()
    }
}
