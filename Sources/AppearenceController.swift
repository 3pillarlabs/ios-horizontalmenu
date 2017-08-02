//
//  AppearenceController.swift
//  TPGHorizontalMenu
//
//  Created by Horatiu Potra on 09/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import UIKit

/// An object which is responsible with appereance control of menu items.
class AppearenceController {
    private enum Layout {
        case scroll(offset: CGPoint)
        case none
    }
    
    unowned let menuViewController: HorizontalMenuViewController
    private (set) var geometryHolder: GeometryHolder
    
    private var layout: Layout = .none
    private var previousTransition: ScrollTransition?
    
    private static let defaultAppearanceAnimation = Animation(duration: 0.3)
    
    init(menuViewController: HorizontalMenuViewController, geometryHolder: GeometryHolder) {
        self.menuViewController = menuViewController
        self.geometryHolder = geometryHolder
    }
    
    func updateItemsScrollView(using transition: ScrollTransition, animated: Bool = false) {
        updateLayout(using: transition)
        
        let layout = appearanceLayout(for: transition.toIndex, and: transition.progress)
        perform(layout: layout, animated: animated)
        
        resetLayout(using: transition)
    }
    
    // MARK: Private functionality
    
    private func isValid(_ transition: ScrollTransition) -> Bool {
        return menuViewController.isValid(index: transition.toIndex)
    }
    
    private func appearanceLayout(for index: Int, and progress: CGFloat) -> Layout {
        guard menuViewController.items.isValid(index: index) else { return .none }
        
        let item = menuViewController.items[index]
        let spacing = offsetSpacing(for: index)
        let itemsScrollView = menuViewController.itemsScrollView
        
        var minX = menuViewController.itemsContainerView.convert(CGPoint(x: item.view.frame.minX, y: 0),
                                                                 to: itemsScrollView).x
        minX -= spacing
        var maxX = menuViewController.itemsContainerView.convert(CGPoint(x: item.view.frame.maxX, y: 0),
                                                                 to: itemsScrollView).x
        maxX += spacing
        
        var nextX: CGFloat = itemsScrollView.contentOffset.x
        
        let visibleRect = itemsScrollView.visibleRect
        if visibleRect.minX > minX {
            nextX = minX
        } else if visibleRect.maxX < maxX {
            nextX = maxX - itemsScrollView.bounds.width
        }
        
        if nextX != itemsScrollView.contentOffset.x {
            let segment = Segment<CGFloat>(first: xOffset(for: layout), second: nextX)
            let x = segment.pointProgress(with: progress)
            return .scroll(offset: CGPoint(x: x, y: 0.0))
        }
        
        return .none
    }
    
    private func perform(layout: Layout, animated: Bool = false) {
        switch layout {
        case .scroll(let offset):
            update(offset: offset, animated: animated)
        default:
            break
        }
    }
    
    private func update(offset: CGPoint, animated: Bool) {
        let itemsScrollView = menuViewController.itemsScrollView
        let change = {
            if itemsScrollView.contentOffset.x != offset.x {
                itemsScrollView.contentOffset.x = offset.x
            }
        }
        
        if animated {
            let delegateAnimation = menuViewController.delegate?.horizontalMenuViewControllerAnimationForEdgeAppearance?(horizontalMenuViewController: menuViewController)
            let animation = delegateAnimation ?? AppearenceController.defaultAppearanceAnimation
            
            animation.addAnimation(change)
            animation.animate()
        } else {
            change()
        }
    }
    
    private func updateLayout(using transition: ScrollTransition) {
        let layoutUpdate = { [unowned self] in
            self.layout = .scroll(offset: self.menuViewController.itemsScrollView.contentOffset)
        }
        
        switch previousTransition {
        case nil:
            layoutUpdate()
        case let oldTransition where oldTransition != transition:
            layoutUpdate()
        default:
            break
        }
        
        previousTransition = transition
    }
    
    private func resetLayout(using transition: ScrollTransition) {
        let reset = { [unowned self] in
            self.layout = .none
            self.previousTransition = nil
        }
        
        if !menuViewController.isValid(index: transition.toIndex) {
            reset()
            let layout = appearanceLayout(for: transition.fromIndex, and: 1.0)
            perform(layout: layout, animated: true)
        } else if transition.progress == 1.0 {
            reset()
        }
    }
    
    private func offsetSpacing(for index: Int) -> CGFloat {
        guard index >= 0 && index < menuViewController.numberOfElements else { return 0.0 }
        
        switch index {
        case 0:
            return geometryHolder.menuGeometry.itemsInset.left
        case menuViewController.items.count - 1:
            return geometryHolder.menuGeometry.itemsInset.right
        default:
            return geometryHolder.menuGeometry.itemSpacing
        }
    }
    
    private func xOffset(for layout: Layout) -> CGFloat {
        switch layout {
        case .scroll(let offset):
            return offset.x
        default:
            return 0.0
        }
    }
}
