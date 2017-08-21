//
//  MenuDataSource.swift
//  TPGHorizontalMenu
//
//  Created by Horatiu Potra on 02/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import UIKit

public protocol MenuDataSource: class {
    /// The array of menu items which are being displayed.
    var items: [MenuItem] { get }
    /// The collection of view controller which are loaded at the moment of request.
    var screens: [Int : UIViewController] { get }
    /// The scroll view where container view for menu items is placed.
    var itemsScrollView: UIScrollView { get }
    /// The container view where views of menu items are placed.
    var itemsContainerView: UIView { get }
    /// The scroll view where view controlelrs are placed.
    var screenScrollView: UIScrollView { get }
    /// The scroll indicator view placed at the top or the bottom of the items.
    var scrollIndicator: UIView? { get }
    
    /// The view where entire content of the menu is added.
    var menuContainerView: UIView { get }
    
    /// Boolean to configure if the intermediate screens on menu item selection should be loaded
    var preloadIntermediateScreensOnSelection: Bool { get }

    /// The current index of pagination.
    var currentIndex: Int { get }

    /// The number of elements is the same for items and screen.
    /// However the items.count might be 0 because they are optional.
    var numberOfElements: Int { get }
}

extension MenuDataSource {
    public func isValid(index: Int) -> Bool {
        return index >= 0 && index < numberOfElements
    }
}
