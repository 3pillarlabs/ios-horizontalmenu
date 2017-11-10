//
//  UIFont+ApplicationFonts.swift
//  HorizontalMenuDemo
//
//  Created by David Livadaru on 27/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import UIKit

extension UIFont {
    static func titleItemFont() -> UIFont? {
        return UIFont(name: "American Typewriter", size: 22.0)
    }
    
    static func menuItemFont() -> UIFont? {
        return UIFont(name: "AmericanTypewriter", size: 18.0)
    }
    
    static func menuItemFontHighlighted() -> UIFont? {
        return UIFont(name: "AmericanTypewriter-Light", size: 18.0)
    }
    
    static func menuItemFontSelected() -> UIFont? {
        return UIFont(name: "AmericanTypewriter-Bold", size: 18.0)
    }
}
