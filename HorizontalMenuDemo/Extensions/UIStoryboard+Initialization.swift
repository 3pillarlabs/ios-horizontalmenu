//
//  UIStoryboard+Initialization.swift
//  HorizontalMenuDemo
//
//  Created by David Livadaru on 14/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import UIKit

extension UIStoryboard {
    static func loadMainStoryboardVC<T: UIViewController>() -> T {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    }
}
