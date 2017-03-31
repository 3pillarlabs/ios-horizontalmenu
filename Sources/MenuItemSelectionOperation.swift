//
//  MenuItemSelectionOperation.swift
//  TPGHorizontalMenu
//
//  Created by David Livadaru on 17/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import UIKit

/// An operation which perform the animation of menu item selection.
class MenuItemSelectionOperation: Operation {
    override var isExecuting: Bool {
        return _isExecuting
    }
    
    override var isFinished: Bool {
        return _isFinished
    }
    
    private var _isExecuting: Bool  = false
    private var _isFinished: Bool = false
    private let menuController: HorizontalMenuViewController
    private let index: Int
    
    private static let defaultSelectionAnimation = Animation(duration: 0.3)
    
    init(menuController: HorizontalMenuViewController, index: Int) {
        self.menuController = menuController
        self.index = index
    }
    
    override func start() {
        guard isCancelled == false else {
            finish()
            return
        }
        
        updateExecuting(true)
        performSelectionAnimation()
    }
    
    // MARK: Private functionality
    
    private func finish() {
        willChangeValue(forKey: "isFinished")
        _isFinished = true
        didChangeValue(forKey: "isFinished")
    }
    
    private func updateExecuting(_ executing: Bool) {
        willChangeValue(forKey: "isExecuting")
        _isExecuting = executing
        didChangeValue(forKey: "isExecuting")
    }
    
    private func performSelectionAnimation() {
        let delegateAnimation = menuController.delegate?.horizontalMenuViewController?(horizontalMenuViewController: menuController,
                                                                                       animationForSelectionOf: index)
        let animation = delegateAnimation ?? MenuItemSelectionOperation.defaultSelectionAnimation
        
        animation.addAnimation({ [weak self] in
            guard let strongSelf = self else { return }
            
            let controller = strongSelf.menuController
            controller.paginationController.scroll(to: strongSelf.index)
            
            if let scrollIndicator = controller.scrollIndicator {
                let transition = ScrollTransition(toIndex: strongSelf.index, progress: 1.0)
                controller.layoutController.layout(scrollIndicator: scrollIndicator, transition: transition)
                controller.appearenceController.updateItemsScrollView(using: transition)
                scrollIndicator.backgroundColor = controller.items[strongSelf.index].indicatorColor
            }
        })
        
        animation.addCompletion({ [weak self] (finished) in
            guard let strongSelf = self else { return }
            
            strongSelf.finishAnimation()
            strongSelf.finish()
            strongSelf.updateExecuting(false)
        })
        
        prepareForAnimation()
        animation.animate()
    }
    
    private func prepareForAnimation() {
        menuController.paginationController.prepareForIndexSelection(index)
    }
    
    private func finishAnimation() {
        menuController.selectionOperation = nil
        menuController.paginationController.cleanupIndexSelection(index)
    }
}
