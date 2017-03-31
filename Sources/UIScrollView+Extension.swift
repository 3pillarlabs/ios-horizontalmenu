//
//  UIScrollView+Extension.swift
//  TPGHorizontalMenu
//
//  Created by Horatiu Potra on 09/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import UIKit

extension UIScrollView {
    /// Computed property for visible rectangular area.
    public var visibleRect: CGRect {
        return CGRect(origin: contentOffset, size: bounds.size)
    }
}
