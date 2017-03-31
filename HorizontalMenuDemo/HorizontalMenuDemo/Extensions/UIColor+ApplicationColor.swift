//
//  UIColor+ApplicationColor.swift
//  HorizontalMenuDemo
//
//  Created by David Livadaru on 27/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import UIKit

extension UIColor {
    static func menuBackgroundColor() -> UIColor {
        return UIColor(red: 23.0 / 255.0, green: 23.0 / 255.0, blue: 23.0 / 255.0, alpha: 1.0)
    }
    
    static func menuItemBackgroundColor() -> UIColor {
        return UIColor(red: 39.0 / 255.0, green: 39.0 / 255.0, blue: 39.0 / 255.0, alpha: 1.0)
    }
    
    static func menuItemTextColor() -> UIColor {
        return UIColor(red: 200.0 / 255.0, green: 200.0 / 255.0, blue: 200.0 / 255.0, alpha: 1.0)
    }
    
    static func menuItemBorderColor() -> UIColor {
        return UIColor(red: 80.0 / 255.0, green: 80.0 / 255.0, blue: 80.0 / 255.0, alpha: 1.0)
    }
    
    static func menuIndicatorColor() -> UIColor {
        return UIColor.magenta
    }
}
