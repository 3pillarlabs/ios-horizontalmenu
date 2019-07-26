//
//  ContainerLoaderController.swift
//  TPGHorizontalMenu
//
//  Created by David Livadaru on 17/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import Foundation

/// An object which is responsible with loading of child view controllers on the screen for menu. 
class ContainerLoaderController {
    unowned let menuController: HorizontalMenuViewController
    
    init(menuController: HorizontalMenuViewController) {
        self.menuController = menuController
    }
    
    func preloadScreensForCurrentIndex() {
        let currentIndex = menuController.paginationController.currentIndex
        preloadScreens(for: [currentIndex - 1, currentIndex, currentIndex + 1])
        unloadScreensForCurrentIndex()
    }
    
    func preloadScreens(for range: CountableClosedRange<Int>) {
        preloadScreens(for: Array<Int>(range))
    }
    
    func preloadScreens(for indexes: [Int]) {
        for index in indexes {
            preloadScreen(for: index)
        }
    }
    
    func preloadScreen(for index: Int) {
        guard menuController.isValid(index: index), menuController.screens[index] == nil,
            let childViewController = menuController.dataSource?.horizontalMenuViewController(horizontalMenuViewController: menuController,
                                                                                              viewControllerFor: index)
            else { return }
        
        childViewController.willMove(toParent: menuController)
        menuController.screenScrollView.insertSubview(childViewController.view, at: 0)
        menuController.addChild(childViewController)
        menuController.screens[index] = childViewController
        
        menuController.containerLifeCycleController.prepareMachine(for: index)
        menuController.layoutController.layout(screen: childViewController.view, at: index)
    }
    
    func unloadScreensForCurrentIndex() {
        let unloadClosure = { [weak self] in
            guard let strongSelf = self else { return }
            
            let pagination: PaginationController = strongSelf.menuController.paginationController
            strongSelf.unloadScreens(except: (pagination.currentIndex - 1)...(pagination.currentIndex + 1))
        }
        if let selectionOperation = menuController.selectionOperation {
            let unloadOpereation = BlockOperation(block: unloadClosure)
            unloadOpereation.addDependency(selectionOperation)
            OperationQueue.main.addOperation(unloadOpereation)
        } else {
            unloadClosure()
        }
    }
    
    func unloadScreens(except range: ClosedRange<Int>) {
        for index in 0..<menuController.numberOfElements {
            guard range.contains(index) == false else { continue }
            
            unloadScreen(for: index)
        }
    }
    
    func unloadScreens(for indexes: [Int]) {
        for index in indexes {
            unloadScreen(for: index)
        }
    }
    
    func unloadScreen(for index: Int) {
        guard menuController.isValid(index: index),
            let childViewController = menuController.screens[index] else { return }
        
        childViewController.willMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParent()
        menuController.screens[index] = nil
        
        menuController.containerLifeCycleController.removeMachine(for: index)
    }
}
