//
//  ScrollIndicatorGeometry.swift
//  TPGHorizontalMenu
//
//  Created by David Livadaru on 07/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import UIKit

/// A data structure which has information about scroll indicator view's layout.
public struct ScrollIndicatorGeometry {
    public enum VerticalAlignment {
        case top, bottom
    }
    
    /// The height of scroll indicator view. Default value is 4.0.
    let height: CGFloat
    /// Vertical alignment of scroll indicator view. Default value is bottom.
    let verticalAlignment: VerticalAlignment
    
    public init(height: CGFloat = 4.0, verticalAlignment: VerticalAlignment = .bottom) {
        self.height = height
        self.verticalAlignment = verticalAlignment
    }
}
