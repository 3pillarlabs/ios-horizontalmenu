//
//  ContainerLifeCycleController.swift
//  TPGHorizontalMenu
//
//  Created by David Livadaru on 15/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import Foundation
import GameplayKit

/// An object which is reponsible with the life cycle control of menu child view controllers.
class ContainerLifeCycleController {
    /// Enumeration if possible states of object.
    ///
    /// - inProgress: enters when users scrolls between menu items.
    /// - selecting: enters when user selected a menu item.
    /// - changing: enters when menu view controlelr is loading.
    /// - notChanging: enters when there is no need to perform any changes.
    private enum State {
        case inProgress(from: Int, to: Int, progress: CGFloat)
        case selecting(from: Int, to: Int, progress: CGFloat)
        case changing(toIndex: Int)
        case notChanging
    }
    
    unowned let menuDataSource: MenuDataSource
    
    private var stateMachines: [Int : GKStateMachine] = [:]
    private var state: State = .notChanging {
        didSet {
            updateState(from: oldValue, to: state)
        }
    }
    
    init(menuDataSource: MenuDataSource) {
        self.menuDataSource = menuDataSource
    }
    
    func reload() {
        stateMachines = [:]
        
        for index in 0..<menuDataSource.screens.count {
            let stateMachine = createStateMachine(for: index)
            stateMachine.enter(ViewDidLoadState.self)
            stateMachines[index] = stateMachine
        }
    }
    
    func prepareMachine(for index: Int) {
        guard menuDataSource.isValid(index: index), stateMachines[index] == nil else { return }
        
        let stateMachine = createStateMachine(for: index)
        stateMachine.enter(ViewDidLoadState.self)
        stateMachines[index] = stateMachine
    }
    
    func removeMachine(for index: Int) {
        guard menuDataSource.isValid(index: index), stateMachines[index] != nil else { return }
        stateMachines[index] = nil
    }
    
    func updateContainter(using transition: ScrollTransition) {
        state = createState(from: transition)
    }
    
    func update(currentIndex index: Int) {
        state = .changing(toIndex: index)
    }

    func startAppearanceForCurrentIndex() {
        startAppearance(for: menuDataSource.currentIndex)
    }

    func endAppearanceForCurrentIndex() {
        endAppearance(for: menuDataSource.currentIndex)
    }

    func startDisappearanceForCurrentIndex() {
        startDisappearance(for: menuDataSource.currentIndex)
    }

    func endDisappearanceForCurrentIndex() {
        endDisappearance(for: menuDataSource.currentIndex)
    }
    
    // MARK: Private functionality
    
    private func createStateMachine(for index: Int) -> GKStateMachine {
        var states: [GKState] = []
        if let viewController = menuDataSource.screens[index] {
            states = [ViewDidLoadState(viewController: viewController),
                      ViewWillAppearState(viewController: viewController),
                      AppearanceProgressState(viewController: viewController),
                      ViewDidAppearState(viewController: viewController),
                      ViewWillDisappearState(viewController: viewController),
                      DisappearanceProgressState(viewController: viewController),
                      ViewDidDisappearState(viewController: viewController)]
        }
        return GKStateMachine(states: states)
    }
    
    private func createState(from transition: ScrollTransition) -> State {
        let fromIndexIsValid = menuDataSource.isValid(index: transition.fromIndex)
        let toIndexIsValid = menuDataSource.isValid(index: transition.toIndex)
        
        switch (fromIndexIsValid, toIndexIsValid) {
        case (true, true) where transition.kind == .selection:
            return .selecting(from: transition.fromIndex, to: transition.toIndex,
                              progress: transition.progress)
        case (true, true):
            return .inProgress(from: transition.fromIndex, to: transition.toIndex,
                               progress: transition.progress)
        case (false, true):
            return .changing(toIndex: transition.toIndex)
        default:
            return .notChanging
        }
    }
    
    private func updateState(from old: State, to new: State) {
        switch (old, new) {
        case (.inProgress(let oldFrom, let oldTo, _), .inProgress(_, let newTo, _)) where newTo > oldTo:
            if newTo == oldFrom { break }
            endDisappearance(for: oldFrom)
        case (.inProgress(let oldFrom, let oldTo, _), .changing(let index)) where oldTo == index:
            endDisappearance(for: oldFrom)
        default:
            break
        }
    
        switch new {
        case .inProgress(let fromIndex, let toIndex, let progress):
            startAppearance(for: toIndex)
            updateAppearance(for: toIndex, progress: progress)
            startDisappearance(for: fromIndex)
            updateDisappearance(for: fromIndex, progress: progress)
        case .changing(let index):
            startAppearance(for: index)
            endAppearance(for: index)
        case .selecting(let from, let to, let progress):
            switch progress {
            case 0.0:
                startAppearance(for: to)
                startDisappearance(for: from)
            case 1.0:
                endAppearance(for: to)
                endDisappearance(for: from)
            default:
                updateAppearance(for: to, progress: progress)
                updateDisappearance(for: from, progress: progress)
            }
        default:
            break
        }
    }
    
    private func startAppearance(for index: Int) {
        guard let machine = stateMachines[index] else { return }
        if machine.canEnterState(ViewWillAppearState.self) {
            machine.enter(ViewWillAppearState.self)
        }
    }
    
    private func updateAppearance(for index: Int, progress: CGFloat) {
        guard let machine = stateMachines[index] else { return }
        if machine.canEnterState(AppearanceProgressState.self) {
            machine.enter(AppearanceProgressState.self)
            if let currentState = machine.currentState as? AppearanceProgressState {
                currentState.update(progress: progress)
            }
            if progress == 1.0 {
                endAppearance(for: index)
            }
        }
    }
    
    private func endAppearance(for index: Int) {
        guard let machine = stateMachines[index] else { return }
        if machine.canEnterState(ViewDidAppearState.self) {
            machine.enter(ViewDidAppearState.self)
        }
    }
    
    private func startDisappearance(for index: Int) {
        guard let machine = stateMachines[index] else { return }
        if machine.canEnterState(ViewWillDisappearState.self) {
            machine.enter(ViewWillDisappearState.self)
        }
    }
    
    private func updateDisappearance(for index: Int, progress: CGFloat) {
        guard let machine = stateMachines[index] else { return }
        if machine.canEnterState(DisappearanceProgressState.self) {
            machine.enter(DisappearanceProgressState.self)
            if let currentState = machine.currentState as? DisappearanceProgressState {
                currentState.update(progress: progress)
            }
            if progress == 1.0 {
                endDisappearance(for: index)
            }
        }
    }
    
    private func endDisappearance(for index: Int) {
        guard let machine = stateMachines[index] else { return }
        if machine.canEnterState(ViewDidDisappearState.self) {
            machine.enter(ViewDidDisappearState.self)
        }
        if machine.canEnterState(ViewDidLoadState.self) {
            machine.enter(ViewDidLoadState.self)
        }
    }
}
