//
//  PaginationController.swift
//  TPGHorizontalMenu
//
//  Created by Horatiu Potra on 03/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import UIKit

protocol PaginationControllerDelegate: class {
    func paginationController(paginationController: PaginationController, scrollTransition: ScrollTransition)
    func paginationController(paginationController: PaginationController, currentIndex: Int)
}

/// An object which is reponsible with pagination between screens.
public class PaginationController: NSObject, UIScrollViewDelegate {
    /// The state of the controller.
    ///
    /// - scrolling: user is scrolling between screens.
    /// - selection: the controller is not forwarding the transition objects from UIScrollViewDelegate in this state.
    /// - preparingForSelection: the controller prepares for  menu item selection.
    private enum State {
        case scrolling
        case selection(index: Int)
        case preparingForSelection
    }
    
    /// The direction of scroll.
    enum Direction {
        case left, right, none
    }
    
    public unowned let menuDataSource: MenuDataSource
    weak var delegate: PaginationControllerDelegate?
    
    public private (set) var currentIndex: Int = 0
    
    private var previousOffset: CGPoint = CGPoint.zero
    private var state: State = .scrolling
    
    public init(menuDataSource: MenuDataSource) {
        self.menuDataSource = menuDataSource
        super.init()
        
        menuDataSource.screenScrollView.delegate = self
    }
    
    // MARK: Public interface
    
    public func prepareForIndexSelection(_ index: Int) {
        state = .preparingForSelection
        
        if menuDataSource.preloadIntermediateScreensOnSelection == false,
            let indexOffset = selectionIndexOffset(for: index) {
            menuDataSource.screenScrollView.contentOffset = screenContentOffset(for: indexOffset)
        }
        
        state = .selection(index: index)
        
        let transition = ScrollTransition(fromIndex: currentIndex, toIndex: index, progress: 0.0,
                                          kind: .selection)
        delegate?.paginationController(paginationController: self, scrollTransition: transition)
    }
    
    public func scroll(to index: Int) {
        menuDataSource.screenScrollView.contentOffset = screenContentOffset(for: index)
    }
    
    public func cleanupIndexSelection(_ index: Int) {
        state = .scrolling
        
        let transition = ScrollTransition(fromIndex: currentIndex, toIndex: index, progress: 1.0,
                                          kind: .selection)
        delegate?.paginationController(paginationController: self, scrollTransition: transition)
        updateCurrentIndex()
    }
    
    // MARK: Internal interface
    
    func selectionIndexOffset(for index: Int) -> Int? {
        let scrollDirection = direction(fromIndex: currentIndex, toIndex: index)
        
        guard scrollDirection != .none else { return nil }
        
        return selectionIndexOffset(for: scrollDirection, to: index)
    }
    
    // MARK: UIScrollViewDelegate
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch state {
        case .scrolling:
            updateCurrentIndex()
            updateTransition()
        default:
            break
        }
        previousOffset = scrollView.contentOffset
    }
    
    // MARK: Private functionality
    
    private func updateCurrentIndex() {
        let scrollView = menuDataSource.screenScrollView
        
        let currentIndexOffset = CGPoint(x: scrollView.bounds.xAxisOffset(for: currentIndex), y: 0)
        let indexDirection = direction(from: scrollView.contentOffset, to: currentIndexOffset)
        
        var floatingIndex = scrollView.contentOffset.x / scrollView.bounds.width
        switch indexDirection {
        case .right:
            floatingIndex = floor(floatingIndex)
        case .left:
            floatingIndex = ceil(floatingIndex)
        default:
            return
        }
        
        let index = Int(floatingIndex)
        guard index >= 0, index < menuDataSource.numberOfElements else { return }
        
        if currentIndex != index {
            currentIndex = index
            delegate?.paginationController(paginationController: self, currentIndex: currentIndex)
        }
    }
    
    private func updateTransition() {
        let scrollView = menuDataSource.screenScrollView
        
        let scrollingDirection = direction(from: previousOffset, to: scrollView.contentOffset)
        let indexOffset = CGPoint(x: scrollView.bounds.xAxisOffset(for: currentIndex), y: 0)
        let indexDirection = direction(from: indexOffset, to: scrollView.contentOffset)
        
        var fromIndex: Int = Int.min
        var toIndex: Int = Int.min
        
        if scrollingDirection != indexDirection {
            toIndex = currentIndex
            switch indexDirection {
            case .left:
                fromIndex = currentIndex + 1
            case .right:
                fromIndex = currentIndex - 1
            case .none:
                finishTransition(with: scrollingDirection)
                return
            }
        } else {
            fromIndex = currentIndex
            switch indexDirection {
            case .left:
                toIndex = currentIndex + 1
            case .right:
                toIndex = currentIndex - 1
            case .none:
                finishTransition(with: scrollingDirection)
                return
            }
        }
        
        let progress = computeProgress(from: fromIndex)
        
        let transition = ScrollTransition(fromIndex: fromIndex, toIndex: toIndex, progress: progress)
        delegate?.paginationController(paginationController: self, scrollTransition: transition)
    }
    
    private func finishTransition(with direction: Direction) {
        var fromIndex: Int = Int.min
        var toIndex: Int = Int.min
        
        switch direction {
        case .left:
            fromIndex = currentIndex - 1
            toIndex = currentIndex
        case .right:
            fromIndex = currentIndex + 1
            toIndex = currentIndex
        default:
            return
        }
        
        let transition = ScrollTransition(fromIndex: fromIndex, toIndex: toIndex, progress: 1.0)
        delegate?.paginationController(paginationController: self, scrollTransition: transition)
    }
    
    private func direction(from reference: CGPoint, to point: CGPoint) -> Direction {
        let diff = reference.x - point.x
        
        if diff == 0 {
            return .none
        }
        
        return (reference.x - point.x > 0) ? .right : .left
    }
    
    private func direction(fromIndex: Int, toIndex: Int) -> Direction {
        guard fromIndex != toIndex else { return .none }
        
        return (fromIndex - toIndex) > 0 ? .left : .right
    }
    
    private func selectionIndexOffset(for direction: Direction, to index: Int) -> Int {
        switch direction {
        case .left:
            return index + 1
        case .right:
            return index - 1
        case .none:
            return index
        }
    }
    
    private func screenContentOffset(for index: Int) -> CGPoint {
        return CGPoint(x: menuDataSource.screenScrollView.bounds.width * CGFloat(index), y: 0.0)
    }
    
    private func computeProgress(from index: Int) -> CGFloat {
        let fromOffset = menuDataSource.screenScrollView.bounds.xAxisOffset(for: index)
        let progressX = abs(menuDataSource.screenScrollView.contentOffset.x - fromOffset)
        return min(1.0, progressX / menuDataSource.screenScrollView.bounds.width)
    }
}
