//
//  GeometryHolder.swift
//  TPGHorizontalMenu
//
//  Created by Horatiu Potra on 09/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import Foundation

@objc public protocol GeometryHolder: class {
    var menuGeometry: MenuGeometry { get }
    var itemsGeometry: [ItemGeometry] { get }
}
