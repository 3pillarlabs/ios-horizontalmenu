//
//  MenuContainerViewController.swift
//  HorizontalMenuDemo
//
//  Created by David Livadaru on 02/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import UIKit
import TPGHorizontalMenu

class MenuContainerViewController: UIViewController, LayoutControllerDelegate {
    private var menuViewController: HorizontalMenuViewController!
    
    fileprivate let items: [DemoItem] = [DemoItem(text: " Privacy ", color: FinalColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)),
                                         DemoItem(text: " Background refresh ", color: FinalColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)),
                                         DemoItem(text: " Mail ", color: FinalColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)),
                                         DemoItem(text: " Display brightness ", color: FinalColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)),
                                         DemoItem(text: " Localization ", color: FinalColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 1.0)),
                                         DemoItem(text: " Settings ", color: FinalColor(red: 1.0, green: 0.0, blue: 1.0, alpha: 1.0)),
                                         DemoItem(text: " Apple and iTunes Store ", color: FinalColor(red: 0.723, green: 0.45, blue: 0.15, alpha: 1.0))]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        title = "Horizontal menu demo"
        
        let shadowImage = UIImage()
        navigationController?.navigationBar.shadowImage = shadowImage
        navigationController?.navigationBar.setBackgroundImage(shadowImage, for: .default)
        navigationController?.navigationBar.barTintColor = UIColor.menuItemBackgroundColor()
        
        if let titleFont = UIFont.titleItemFont() {
            navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : titleFont,
                                                                       NSForegroundColorAttributeName : UIColor.menuItemTextColor()]
        }

        menuViewController = HorizontalMenuViewController()
        menuViewController.willMove(toParentViewController: self)
        menuViewController.view.frame = view.bounds
        menuViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        menuViewController.view.backgroundColor = UIColor.menuBackgroundColor()
        view.addSubview(menuViewController.view)
        addChildViewController(menuViewController)

        menuViewController.dataSource = self
        menuViewController.layoutDelegate = self
    }
    
    // MARK: LayoutControllerDelegate
    
    func layoutControllerMenuGeometry(layoutController: LayoutController) -> MenuGeometry {
        let scrollIndicatorGeometry = ScrollIndicatorGeometry(height: 2, verticalAlignment: .bottom)
        return MenuGeometry(itemsInset: UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0),
                            itemSpacing: 4, prefferedHeight: 0,
                            scrollIndicatorGeometry: scrollIndicatorGeometry)
    }
    
    func layoutController(layoutController: LayoutController, geometryForItemAt index: Int) -> ItemGeometry {
        let view = menuViewController.items[index].view
        let button = view as? UIButton
        let selectState = button?.isSelected
        button?.isSelected = true
        let geometry = ViewGeometry(view: view)
        button?.isSelected = selectState ?? false
        return geometry
    }
}

// MARK: - HorizontalMenuViewControllerDataSource
extension MenuContainerViewController: HorizontalMenuViewControllerDataSource {
    func horizontalMenuViewControllerNumberOfElements(horizontalMenuViewController: HorizontalMenuViewController) -> Int {
        return items.count
    }
    
    func horizontalMenuViewController(horizontalMenuViewController: HorizontalMenuViewController,
                                      menuItemFor index: Int) -> MenuItem {
        let menuView = UIButton()
        menuView.backgroundColor = UIColor.menuItemBackgroundColor()
        menuView.layer.cornerRadius = 1
        menuView.clipsToBounds = true
        menuView.layer.borderColor = UIColor.menuItemBorderColor().cgColor
        menuView.layer.borderWidth = 1
        let item = items[index]
        let text = item.text
        
        if let font = UIFont.menuItemFont() {
            let attributes = [NSFontAttributeName : font,
                              NSForegroundColorAttributeName : UIColor.menuItemTextColor()]
            let attributedText = NSAttributedString(string: text, attributes: attributes)
            menuView.setAttributedTitle(attributedText, for: .normal)
        }
        
        if let font = UIFont.menuItemFontHighlighted() {
            let attributes = [NSFontAttributeName : font,
                              NSForegroundColorAttributeName : UIColor.menuItemTextColor().withAlphaComponent(0.5)]
            let attributedText = NSAttributedString(string: text, attributes: attributes)
            menuView.setAttributedTitle(attributedText, for: .highlighted)
        }
        
        if let font = UIFont.menuItemFontSelected() {
            let attributes = [NSFontAttributeName : font,
                              NSForegroundColorAttributeName : UIColor.menuItemTextColor()]
            let attributedText = NSAttributedString(string: text, attributes: attributes)
            menuView.setAttributedTitle(attributedText, for: .selected)
        }
        
        let menuItem = MenuItem(view: menuView, indicatorColor: item.color)
        return menuItem
    }
    
    func horizontalMenuViewController(horizontalMenuViewController: HorizontalMenuViewController,
                                      viewControllerFor index: Int) -> UIViewController {
        let screen: MenuScreenViewController = UIStoryboard.loadMainStoryboardVC()
        
        let white = CGFloat(index + 1) / CGFloat(horizontalMenuViewController.numberOfElements)
        screen.view.backgroundColor = UIColor(white: white, alpha: 1.0)
        let item = items[index]
        let text = item.text
        
        screen.textLabel.text = "Screen for\(text)"
        screen.textLabel.textColor = item.color
        
        return screen
    }
    
    func horizontalMenuViewControllerScrollIndicatorView(horizontalMenuViewController: HorizontalMenuViewController) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        return view
    }
}
