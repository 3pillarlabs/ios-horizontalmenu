//
//  ViewGeometry.swift
//  TPGHorizontalMenu
//
//  Created by David Livadaru on 08/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import UIKit

/// A data structure which asks the menu item view about it's size.
open class ViewGeometry: ItemGeometry {
    public let view: UIView
    
    public init(view: UIView, verticalAlignment: VerticalAlignment = .center) {
        let size = view.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude,
                                            height: CGFloat.greatestFiniteMagnitude))
        self.view = view
        
        super.init(size: size, verticalAlignment: verticalAlignment)
    }
}
