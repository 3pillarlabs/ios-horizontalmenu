//
//  HorizontalMenuViewController.swift
//  TPGHorizontalMenu
//
//  Created by David Livadaru on 08/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import UIKit

@objc public protocol HorizontalMenuViewControllerDataSource: class {
    /// Asks the data source for the number of items in the menu.
    ///
    /// - Parameter horizontalMenuViewController: the view controller which asks the information.
    /// - Returns: the number of items.
    func horizontalMenuViewControllerNumberOfItems(horizontalMenuViewController: HorizontalMenuViewController) -> Int
    /// Asks the data source for menu item which should be used at provided index.
    ///
    /// - Parameters:
    ///   - horizontalMenuViewController: the view controller which asks the information.
    ///   - index: the index for which item is requested.
    /// - Returns: menu item.
    func horizontalMenuViewController(horizontalMenuViewController: HorizontalMenuViewController,
                                      menuItemFor index: Int) -> MenuItem
    /// Asks the data source for view controller should be used at provided index.
    ///
    /// - Parameters:
    ///   - horizontalMenuViewController: the view controller which asks the information.
    ///   - index: the index for which item is requested.
    /// - Returns: the view controller
    func horizontalMenuViewController(horizontalMenuViewController: HorizontalMenuViewController,
                                      viewControllerFor index: Int) -> UIViewController
    /// Asks the data source for the view which should be used as scroll indicator.
    ///
    /// - Parameter horizontalMenuViewController: the view controller which asks the information.
    /// - Returns: the view which should be used as scroll indicator.
    @objc optional func horizontalMenuViewControllerScrollIndicatorView(horizontalMenuViewController: HorizontalMenuViewController) -> UIView
}

@objc public protocol HorizontalMenuViewControllerDelegate: class {
    /// Informs delegate when a menu item has been seleected.
    ///
    /// - Parameters:
    ///   - horizontalMenuViewController: the view controller which provide the information.
    ///   - index: index which the item has been selected.
    @objc optional func horizontalMenuViewController(horizontalMenuViewController: HorizontalMenuViewController,
                                                     didSelectItemAt index: Int)
    /// Informs delegate when a scroll transition has been performed.
    ///
    /// - Parameters:
    ///   - horizontalMenuViewController: the view controller which provide the information.
    ///   - scrollTransition: the scroll transition which has been performed.
    @objc optional func horizontalMenuViewController(horizontalMenuViewController: HorizontalMenuViewController,
                                                     scrollTransition: ScrollTransition)
    /// Asks the delegate for the animation which should be used when a menu items is selected.
    ///
    /// - Parameters:
    ///   - horizontalMenuViewController: the view controller which provide the information.
    ///   - index: the index of menu item which will be selected.
    @objc optional func horizontalMenuViewController(horizontalMenuViewController: HorizontalMenuViewController,
                                                     animationForSelectionOf index: Int) -> Animation
    
    /// Asks the delegate for the animation which should be used when the user swiped the other and the selected menu item.
    /// For example: First item is selected, but the last visible. If the user swipes to left, an animation will peformed to make the first item visible.
    ///
    /// - Parameter horizontalMenuViewController: the view controller which provide the information.
    @objc optional func horizontalMenuViewControllerAnimationForEdgeAppearance(horizontalMenuViewController: HorizontalMenuViewController) -> Animation
}

public class HorizontalMenuViewController: UIViewController, MenuDataSource, PaginationControllerDelegate {
    public private (set) var items: [MenuItem] = []
    public internal (set) var screens: [Int : UIViewController] = [:]
    
    public var itemsScrollView: UIScrollView {
        return _itemsScrollView
    }
    public var itemsContainerView: UIView {
        return _itemsContainerView
    }
    
    public var screenScrollView: UIScrollView {
        return _screenScrollView
    }
    
    public var menuContainerView: UIView {
        return view
    }
    
    public var scrollIndicator: UIView?
    
    /// The data source for menu.
    public weak var dataSource: HorizontalMenuViewControllerDataSource? {
        didSet {
            if isViewLoaded {
                reloadData()
            }
        }
    }
    /// The delegate for menu.
    public weak var delegate: HorizontalMenuViewControllerDelegate?
    
    /// The delegate for layout.
    public weak var layoutDelegate: LayoutControllerDelegate? {
        didSet {
            layoutController?.delegate = layoutDelegate
        }
    }
    
    /// If true, when users seleects an iten from menu, 
    /// all view controllers from current index to selected index will be loaded.
    ///
    /// Default value is false.
    public var preloadIntermediateScreensOnSelection: Bool = false
    
    internal (set) var selectionOperation: Operation?
    
    private (set) var layoutController: LayoutController!
    private (set) var paginationController: PaginationController!
    private (set) var appearenceController: AppearenceController!
    private (set) var selectionController: SelectionController!
    private (set) var containerLifeCycleController: ContainerLifeCycleController!
    private (set) var containerLoaderController: ContainerLoaderController!
    
    private var _itemsScrollView: UIScrollView!
    private var _itemsContainerView: UIView!
    private var _screenScrollView: UIScrollView!
    
    private var canUpdateIndicatorColor: Bool = false
    
    // MARK: View Life Cycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.red
        
        initializeSubviews()
        initializeControllers()
        
        reloadData()
        containerLifeCycleController.update(currentIndex: 0)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        selectionController.selectItem(at: paginationController.currentIndex)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutController.layoutMenuContainerView()
        if let scrollIndicator = scrollIndicator {
            let transition = ScrollTransition(toIndex: paginationController.currentIndex)
            layoutController.layout(scrollIndicator: scrollIndicator, transition: transition)
        }
    }
    
    // MARK: View controller container management
    
    public override var shouldAutomaticallyForwardAppearanceMethods: Bool {
        return false
    }
    
    // MARK: Public interface
    
    public func reloadData() {
        populateMenuItems()
        paginationController.scroll(to: 0)
        containerLoaderController.preloadScreensForCurrentIndex()
        containerLifeCycleController.reload()
        
        addScrollIndicator()
        updateAbilityToChangeIndicatorColor()

        selectionController.resetItemsHandling()
    }
    
    // MARK: PaginationControllerDelegate
    
    public func paginationController(paginationController: PaginationController,
                                     scrollTransition: ScrollTransition) {
        containerLifeCycleController.updateContainter(using: scrollTransition)
        
        if let scrollIndicator = scrollIndicator {
            layoutController.layout(scrollIndicator: scrollIndicator, transition: scrollTransition)
        }
        updateScrollIndicatorColor(with: scrollTransition)
        let animated = !items.isValid(index: scrollTransition.toIndex)
        appearenceController.updateItemsScrollView(using: scrollTransition, animated: animated)
        
        delegate?.horizontalMenuViewController?(horizontalMenuViewController: self,
                                                scrollTransition: scrollTransition)
    }
    
    public func paginationController(paginationController: PaginationController, currentIndex: Int) {
        containerLifeCycleController.update(currentIndex: currentIndex)
        containerLoaderController.preloadScreensForCurrentIndex()
        selectionController.selectItem(at: currentIndex)
        delegate?.horizontalMenuViewController?(horizontalMenuViewController: self,
                                                didSelectItemAt: currentIndex)
    }
    
    // MARK: Private functionality
    
    private func initializeSubviews() {
        _itemsScrollView = UIScrollView()
        _itemsScrollView.showsHorizontalScrollIndicator = false
        _itemsScrollView.showsVerticalScrollIndicator = false
        view.addSubview(_itemsScrollView)
        
        _itemsContainerView = UIView()
        _itemsScrollView.addSubview(_itemsContainerView)
        
        _screenScrollView = UIScrollView()
        _screenScrollView.showsHorizontalScrollIndicator = false
        _screenScrollView.showsVerticalScrollIndicator = false
        _screenScrollView.isPagingEnabled = true
        view.addSubview(_screenScrollView)
    }
    
    private func initializeControllers() {
        layoutController = LayoutController(menuDataSource: self)
        layoutController.delegate = layoutDelegate
        paginationController = PaginationController(menuDataSource: self)
        paginationController.delegate = self
        appearenceController = AppearenceController(menuViewController: self, geometryHolder: layoutController)
        selectionController = SelectionController(menuDataSource: self)
        selectionController.delegate = self
        containerLifeCycleController = ContainerLifeCycleController(menuDataSource: self)
        containerLoaderController = ContainerLoaderController(menuController: self)
    }
    
    private func populateMenuItems() {
        let numberOfItems = dataSource?.horizontalMenuViewControllerNumberOfItems(horizontalMenuViewController: self) ?? 0
        guard numberOfItems > 0 else { return }
        
        items = []
        
        for index in 0..<numberOfItems {
            if let menuItem = dataSource?.horizontalMenuViewController(horizontalMenuViewController: self,
                                                                       menuItemFor: index) {
                items.append(menuItem)
            }
        }
        
        for item in items {
            itemsContainerView.addSubview(item.view)
        }
    }
    
    private func addScrollIndicator() {
        guard let scrollIndicator = dataSource?.horizontalMenuViewControllerScrollIndicatorView?(horizontalMenuViewController: self)
            else { return }
        
        self.scrollIndicator = scrollIndicator
        itemsScrollView.addSubview(scrollIndicator)
    }
    
    private func updateAbilityToChangeIndicatorColor() {
        canUpdateIndicatorColor = true
        for item in items {
            if item.indicatorColor == nil {
                canUpdateIndicatorColor = false
                break
            }
        }
    }
    
    private func updateScrollIndicatorColor(with transition: ScrollTransition) {
        guard canUpdateIndicatorColor, items.count > 0, let scrollIndicator = scrollIndicator,
            transition.toIndex >= 0 && transition.toIndex < items.count,
            transition.fromIndex >= 0 && transition.fromIndex < items.count,
            let firstColor = items[transition.fromIndex].indicatorColor,
            let secondColor = items[transition.toIndex].indicatorColor else { return }
        
            let segment = Segment<FinalColor>(first: firstColor, second: secondColor)
            scrollIndicator.backgroundColor = segment.pointProgress(with: transition.progress)
    }
}

extension HorizontalMenuViewController: SelectionControllerDelegate {
    func selectionController(selectionController: SelectionController, didSelect index: Int) {
        let selectIndexRange = range(forSelectedIndex: index)
        if preloadIntermediateScreensOnSelection == false,
            let currentViewController = screens[paginationController.currentIndex],
            let animationIndex = paginationController.selectionIndexOffset(for: index) {
            layoutController.layout(screen: currentViewController.view, at: animationIndex)
        }
        containerLoaderController.preloadScreens(for: selectIndexRange)
        selectionOperation = MenuItemSelectionOperation(menuController: self, index: index)
        if let operation = selectionOperation {
            OperationQueue.main.addOperation(operation)
        }
    }
    
    private func range(forSelectedIndex index: Int) -> CountableClosedRange<Int> {
        if preloadIntermediateScreensOnSelection {
            if index < paginationController.currentIndex {
                return index...paginationController.currentIndex
            } else {
                return paginationController.currentIndex...index
            }
        } else {
            return (index - 1)...(index + 1)
        }
    }
}