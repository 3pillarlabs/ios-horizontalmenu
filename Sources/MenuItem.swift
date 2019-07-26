//
//  MenuItem.swift
//  TPGHorizontalMenu
//
//  Created by David Livadaru on 09/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import Foundation

/// A class which defines an item from menu.
open class MenuItem: NSObject {
    /// The view which represents the item in the menu.
    public let view: UIView
    
    /// The color used on indicator view.
    ///
    /// If all menu items provide an indicator color, the menu will handle the progressive color change.
    public let indicatorColor: FinalColor?
    
    
    /// Default initializer. Create an item with provided view and indicator color.
    ///
    /// - Parameters:
    ///   - view: internal view
    ///   - indicatorColor: background color for indicator view.
    public init(view: UIView, indicatorColor: FinalColor? = nil) {
        self.view = view
        self.indicatorColor = indicatorColor
        super.init()
    }
    
    /// Convenience initializer which create an item with provided title and indicator color.
    ///
    /// - Parameters:
    ///   - attributedTitle: the title for menu item.
    ///   - indicatorColor: background color for indicator view.
    public convenience init(attributedTitle: NSAttributedString, indicatorColor: FinalColor? = nil) {
        let label = UILabel()
        label.attributedText = attributedTitle
        label.sizeToFit()
        
        self.init(view: label, indicatorColor: indicatorColor)
    }
    
    /// Convenience initializer which create an item with provided text states and indicator color.
    ///
    /// - Parameters:
    ///   - textStates: a dictionary which contains attributed string for each state (normal, highlighted, selected)
    ///   - indicatorColor: background color for indicator view.
    public convenience init(textStates: [UIControl.State : NSAttributedString],
                            indicatorColor: FinalColor? = nil) {
        let button = UIButton()
        
        for (state, text) in textStates {
            button.setAttributedTitle(text, for: state)
        }
        
        self.init(view: button, indicatorColor: indicatorColor)
    }
}
