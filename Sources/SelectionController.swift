//
//  SelectionController.swift
//  TPGHorizontalMenu
//
//  Created by Horatiu Potra on 02/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import UIKit

protocol SelectionControllerDelegate: class {
    func selectionController(selectionController: SelectionController, didSelect index:Int)
}

/// An object which is reponsible with the control of menu items highlighting and selection.
class SelectionController {
    unowned var menuDataSource: MenuDataSource
    weak var delegate: SelectionControllerDelegate?
    
    private var gestures: [UITapGestureRecognizer] = []
    private var controls: [UIControl] = []
    
    private var highlightedItem: Highlightable? {
        didSet {
            if var oldValue = oldValue {
                oldValue.isHighlighted = false
            }
            if var highlightedItem = highlightedItem {
                highlightedItem.isHighlighted = true
            }
        }
    }
    private var selectedItem: Selectable? {
        didSet {
            if var oldValue = oldValue {
                oldValue.isSelected = false
            }
            if var selectedItem = selectedItem {
                selectedItem.isSelected = true
            }
        }
    }
    
    init(menuDataSource: MenuDataSource) {
        self.menuDataSource = menuDataSource
    }
    
    func resetItemsHandling() {
        clearTargets()
        addTargets()
    }
    
    func selectItem(at index: Int) {
        guard menuDataSource.items.isValid(index: index) else { return }
        
        let item = menuDataSource.items[index]
        select(view: item.view)
    }
    
    // MARK: Actions
    
    @objc private func viewDidTouchUpInside(_ sender: Any) {
        var targetIndex: Int?
        var targetView: UIView?
        
        switch sender {
        case let view as UIView:
            targetIndex = index(for: view)
            targetView = view
        case let gesture as UIGestureRecognizer:
            targetIndex = index(for: gesture.view)
            targetView = gesture.view
        default:
            break
        }
        
        select(view: targetView)
        if let index = targetIndex {
            delegate?.selectionController(selectionController: self, didSelect: index)
        }
    }
    
    @objc private func gestureDidChangeState(_ gesture: UIGestureRecognizer) {
        switch gesture.state {
        case .began:
            highlight(view: gesture.view)
        case .ended:
            viewDidTouchUpInside(gesture)
            fallthrough
        case .failed:
            fallthrough
        case .cancelled:
            highlightedItem = nil
        default:
            break
        }
    }
    
    // MARK: Private functionality
    
    private func index(for view: UIView?) -> Int? {
        guard let view = view else { return nil }
        return menuDataSource.items.firstIndex(where: { $0.view == view })
    }
    
    private func clearTargets() {
        for gesture in gestures {
            gesture.removeTarget(self, action: nil)
        }
        gestures = []
        for control in controls {
            control.removeTarget(self, action: nil, for: .allEvents)
        }
        controls = []
    }
    
    private func addTargets() {
        for item in menuDataSource.items {
            item.view.isExclusiveTouch = true
            if let itemControl = item.view as? UIControl {
                itemControl.addTarget(self, action: #selector(viewDidTouchUpInside(_:)), for: .touchUpInside)
            } else {
                let gesture = SelectGestureRecognizer(target: self, action: #selector(gestureDidChangeState(_:)))
                item.view.isUserInteractionEnabled = true
                item.view.addGestureRecognizer(gesture)
            }
        }
    }
    
    private func highlight(view: UIView?) {
        if let highlightableView = view as? Highlightable {
            highlightedItem = highlightableView
        }
    }
    
    private func select(view: UIView?) {
        if let selectableView = view as? Selectable {
            selectedItem = selectableView
        }
    }
}
