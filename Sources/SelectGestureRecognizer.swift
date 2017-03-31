//
//  SelectGestureRecognizer.swift
//  TPGHorizontalMenu
//
//  Created by David Livadaru on 14/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

/// A custom gesture recognizer used for menu item selection which are not UIControl subclasses.
class SelectGestureRecognizer: UIGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        guard let firstTouch = touches.first else { return }
        
        let location = firstTouch.location(in: view)
        
        if view?.bounds.contains(location) == true {
            state = .began
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        guard let firstTouch = touches.first else { return }
        
        let location = firstTouch.location(in: view)
        
        if view?.bounds.contains(location) == true {
            state = .changed
        } else {
            state = .failed
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        state = .cancelled
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        guard let firstTouch = touches.first else { return }
        
        let location = firstTouch.location(in: view)
        
        if view?.bounds.contains(location) == true {
            state = .ended
        } else {
            state = .failed
        }
    }
}
