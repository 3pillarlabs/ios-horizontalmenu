//
//  ScrollTransition.swift
//  TPGHorizontalMenu
//
//  Created by David Livadaru on 06/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import Foundation

public class ScrollTransition: NSObject {
    public enum Direction {
        case left, right
    }
    
    /// The type of transition.
    ///
    /// - scroll: sent while scrolling is performed.
    /// - selection: sent when user selected an index.
    public enum Kind {
        case scroll, selection
    }
    
    /// Start index for transition.
    public let fromIndex: Int
    /// End index for transition.
    public let toIndex: Int
    /// Progress of the transition
    public let progress: CGFloat
    /// The kind of transition
    public let kind: Kind
    
    /// Direction of progress.
    public var direction: Direction {
        return (toIndex > fromIndex) ? .right : .left
    }
    
    public static let invalidIndex = Int.min
    
    override public var debugDescription: String {
        return "ScrollTransition: { fromIndex: \(fromIndex), toIndex: \(toIndex), progress: \(progress) }"
    }
    
    public init(fromIndex: Int = ScrollTransition.invalidIndex, toIndex: Int, progress: CGFloat = 0.0,
         kind: Kind = .scroll) {
        self.fromIndex = fromIndex
        self.toIndex = toIndex
        self.progress = progress
        self.kind = kind
    }
    
    // MARK: Equatable
    
    public override func isEqual(_ object: Any?) -> Bool {
        guard let transition = object as? ScrollTransition else { return false }
        guard self !== transition else { return true }
        
        return self.fromIndex == transition.fromIndex && self.toIndex == transition.toIndex
    }
}
