//
//  LayoutController.swift
//  TPGHorizontalMenu
//
//  Created by David Livadaru on 07/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import UIKit

@objc public protocol LayoutControllerDelegate: class {
    /// Asks the delegate for geometry object which to be used.
    ///
    /// - Parameter layoutController: the object which requests the geometry.
    /// - Returns: the geometry object.
    @objc optional func layoutControllerMenuGeometry(layoutController: LayoutController) -> MenuGeometry
    /// Asks the delegate for geometry object which to be used for item at provided index.
    ///
    /// - Parameters:
    ///   - layoutController: the object which requests the geometry.
    ///   - index: the index of item.
    /// - Returns: the geometry object.
    @objc optional func layoutController(layoutController: LayoutController, geometryForItemAt index: Int) -> ItemGeometry
    /// Asks the delegate if it should adjust the offset for screens' scroll view. By default is performed.
    ///
    /// - Parameter layoutController: the object which requests the geometry.
    /// - Returns: true or false.
    @objc optional func layoutControllerAdjustsScreensScrollOffset(layoutController: LayoutController) -> Bool
}

/// An object which is responsible with the layout of the menu.
public class LayoutController: NSObject, GeometryHolder {
    /// Transition which needs to be performed between screen changes.
    ///
    /// - progressive: a progressive transition between 2 screen with a progress.
    /// - single: a simple transition to an index.
    /// - none: no transition performed.
    private enum Transition {
        case progressive(fromIndex: Int, toIndex: Int, progress: CGFloat)
        case single(index: Int)
        case none
    }
    
    unowned let menuDataSource: MenuDataSource
    weak var delegate: LayoutControllerDelegate?
    
    public private (set) var menuGeometry = MenuGeometry()
    public private (set) var itemsGeometry: [ItemGeometry] = []

    private var adjustsScreenScrollOffset: Bool {
        return delegate?.layoutControllerAdjustsScreensScrollOffset?(layoutController: self) ?? true
    }
    
    init(menuDataSource: MenuDataSource) {
        self.menuDataSource = menuDataSource
        
        super.init()
    }
    
    func layoutMenuContainerView() {
        if let menuGeometry = delegate?.layoutControllerMenuGeometry?(layoutController: self) {
            self.menuGeometry = menuGeometry
        }
        reloadItemsGeometry()
        layoutScrollViews()
        layoutItems()
        layoutScreens()
    }
    
    func layout(item: MenuItem, at index: Int) {
        guard index >= 0 && index < itemsGeometry.count else { return }
        
        var leftSpacing: CGFloat = 0.0
        
        if index > 0 {
            let previousItem = menuDataSource.items[index - 1]
            leftSpacing = previousItem.view.frame.maxX + menuGeometry.itemSpacing
        }
        
        var itemFrame = item.view.frame
        itemFrame.origin.x = leftSpacing
        let geometry = itemsGeometry[index]
        itemFrame.size = geometry.size
        
        switch geometry.verticalAlignment {
        case .center:
            itemFrame.origin.y = (menuDataSource.itemsContainerView.bounds.height - itemFrame.height) / 2
        case .bottom:
            itemFrame.origin.y = menuDataSource.itemsContainerView.bounds.height - itemFrame.height
        default:
            itemFrame.origin.y = 0.0
        }
        
        item.view.frame = itemFrame
    }
    
    func layout(screen: UIView, at index: Int) {
        var frame = CGRect()
        frame.origin.x = menuDataSource.screenScrollView.bounds.xAxisOffset(for: index)
        frame.size.width = menuDataSource.screenScrollView.bounds.width
        frame.size.height = menuDataSource.screenScrollView.contentSize.height
        
        screen.frame = frame
    }
    
    func layout(scrollIndicator: UIView, transition: ScrollTransition) {
        let layoutTransition = convertTransitionIntoLayout(scroll: transition)
        layout(scrollIndicator: scrollIndicator, layoutTransition: layoutTransition)
    }
    
    // MARK: Private functionality
    
    private func layoutScrollViews() {
        menuDataSource.itemsScrollView.contentSize = computeItemsContentSize()

        let menuBounds = menuDataSource.menuContainerView.bounds

        var itemsFrame = menuBounds
        itemsFrame.size.width = menuDataSource.menuContainerView.bounds.width
        itemsFrame.size.height = menuDataSource.itemsScrollView.contentSize.height
        menuDataSource.itemsScrollView.frame = itemsFrame

        menuDataSource.screenScrollView.contentSize = computeScreensContentSize()

        var itemsContainerFrame = CGRect.zero
        itemsContainerFrame.origin.x = menuGeometry.itemsInset.left
        itemsContainerFrame.origin.y = menuGeometry.itemsInset.top
        itemsContainerFrame.size = computeItemsSize()
        menuDataSource.itemsContainerView.frame = itemsContainerFrame

        var screensFrame = menuDataSource.screenScrollView.frame
        if adjustsScreenScrollOffset {
            screensFrame.origin.y = itemsFrame.maxY
        } else {
            screensFrame.origin.y = menuBounds.minY
        }
        screensFrame.size.width = itemsFrame.size.width
        screensFrame.size.height = menuDataSource.screenScrollView.contentSize.height
        menuDataSource.screenScrollView.frame = screensFrame
    }
    
    private func layoutItems() {
        for (index, item) in menuDataSource.items.enumerated() {
            layout(item: item, at: index)
        }
    }
    
    private func layoutScreens() {
        for (index, screen) in menuDataSource.screens {
            layout(screen: screen.view, at: index)
        }
    }
    
    private func layout(scrollIndicator: UIView, layoutTransition: Transition) {
        var indicatorFrame = scrollIndicator.frame
        var centerX = scrollIndicator.center.x
        
        indicatorFrame.size.height = menuGeometry.scrollIndicatorGeometry.height
        switch menuGeometry.scrollIndicatorGeometry.verticalAlignment {
        case .top:
            indicatorFrame.origin.y = 0.0
        case .bottom:
            indicatorFrame.origin.y = menuDataSource.itemsScrollView.contentSize.height - indicatorFrame.height
        }
        
        switch layoutTransition {
        case .progressive(let fromIndex, let toIndex, let progress):
            let fromView = menuDataSource.items[fromIndex].view
            let toView = menuDataSource.items[toIndex].view
            
            let widthSegment = Segment<CGFloat>(first: fromView.bounds.width, second: toView.bounds.width)
            indicatorFrame.size.width = widthSegment.pointProgress(with: progress)
            
            let xSegment = Segment<CGFloat>(first: fromView.center.x, second: toView.center.x)
            let progressX = xSegment.pointProgress(with: progress)
            centerX = menuDataSource.itemsContainerView.convert(CGPoint(x: progressX, y: 0),
                                                                to: menuDataSource.itemsScrollView).x
        case .single(let index):
            let view = menuDataSource.items[index].view
            indicatorFrame.size.width = view.bounds.width
            var toIndexCenter = view.center.x
            toIndexCenter = menuDataSource.itemsContainerView.convert(CGPoint(x: toIndexCenter, y: 0),
                                                                      to: menuDataSource.itemsScrollView).x
            
            centerX = toIndexCenter
        default:
            break
        }
        
        scrollIndicator.frame = indicatorFrame
        scrollIndicator.center.x = centerX
    }
    
    private func reloadItemsGeometry() {
        itemsGeometry.removeAll()
        for index in 0..<menuDataSource.items.count {
            let geometry = delegate?.layoutController?(layoutController: self, geometryForItemAt: index)
            itemsGeometry.append(geometry ?? ItemGeometry())
        }
    }
    
    private func computeItemsContentSize() -> CGSize {
        var size = computeItemsSize()
        
        size = size.insetBy(-menuGeometry.itemsInset)
        size.height = max(size.height, menuGeometry.prefferedHeight)
        
        return size
    }
    
    private func computeItemsSize() -> CGSize {
        var size = CGSize()
        
        for (index, geometry) in itemsGeometry.enumerated() {
            size.width += geometry.size.width
            size.height = max(size.height, geometry.size.height)
            
            if index < itemsGeometry.count - 1 {
                size.width += menuGeometry.itemSpacing
            }
        }
        
        return size
    }
    
    private func computeScreensContentSize() -> CGSize {
        var size = CGSize()

        size.width = CGFloat(menuDataSource.numberOfElements) * menuDataSource.screenScrollView.bounds.width
        size.height = menuDataSource.menuContainerView.bounds.height

        if adjustsScreenScrollOffset {
            size.height -= menuDataSource.itemsScrollView.frame.maxY
        }
        
        return size
    }
    
    private func convertTransitionIntoLayout(scroll transition: ScrollTransition) -> Transition {
        let fromIndexIsValid = menuDataSource.isValid(index: transition.fromIndex)
        let toIndexIsValid = menuDataSource.isValid(index: transition.toIndex)
        
        switch (fromIndexIsValid, toIndexIsValid) {
        case (true, true):
            return .progressive(fromIndex: transition.fromIndex, toIndex: transition.toIndex,
                                progress: transition.progress)
        case (true, false):
            return .single(index: transition.fromIndex)
        case (false, true):
            return .single(index: transition.toIndex)
        default:
            return .none
        }
    }
}
