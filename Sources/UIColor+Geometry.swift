//
//  UIColor+Geometry.swift
//  TPGHorizontalMenu
//
//  Created by David Livadaru on 09/03/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import UIKit

/// A final subclass of UIColor which is needed to implement BasicArithmetic.
public final class FinalColor: UIColor, BasicArithmetic {
    /// Adds 2 colors by using addition of components.
    ///
    /// - Parameters:
    ///   - lhs: left hand side color.
    ///   - rhs: right hand side color.
    /// - Returns: resulted color.
    public static func +(lhs: FinalColor, rhs: FinalColor) -> FinalColor {
        if let lhsComponents = lhs.cgColor.components,
            let rhsComponents = rhs.cgColor.components {
            var sumComponents: [CGFloat] = []
            
            for index in 0..<lhsComponents.count {
                guard index < rhsComponents.count else { break }
                sumComponents.append(lhsComponents[index] + rhsComponents[index])
            }
            
            if let colorSpace = lhs.cgColor.colorSpace,
                let cgColor = CGColor(colorSpace: colorSpace, components: sumComponents) {
                return FinalColor(cgColor: cgColor)
            }
        }
        
        return lhs
    }
    
    /// Substracts 2 colors by using substraction of components.
    ///
    /// - Parameters:
    ///   - lhs: left hand side color.
    ///   - rhs: right hand side color.
    /// - Returns: resulted color.
    public static func -(lhs: FinalColor, rhs: FinalColor) -> FinalColor {
        if let lhsComponents = lhs.cgColor.components,
            let rhsComponents = rhs.cgColor.components {
            var substractComponents: [CGFloat] = []
            
            for index in 0..<lhsComponents.count {
                guard index < rhsComponents.count else { break }
                substractComponents.append(lhsComponents[index] - rhsComponents[index])
            }
            
            if let colorSpace = lhs.cgColor.colorSpace,
                let cgColor = CGColor(colorSpace: colorSpace, components: substractComponents) {
                return FinalColor(cgColor: cgColor)
            }
        }
        
        return lhs
    }
    
    /// Multiplies a color with a floaing-point number. Color components are multiplied with the floating-point.
    ///
    /// - Parameters:
    ///   - lhs: the color.
    ///   - rhs: the floating-point number.
    /// - Returns: resulted color.
    public static func *(lhs: FinalColor, rhs: CGFloat) -> FinalColor {
        if let lhsComponents = lhs.cgColor.components {
            var multipliedComponents: [CGFloat] = []
            
            for index in 0..<lhsComponents.count {
                multipliedComponents.append(lhsComponents[index] * rhs)
            }
            
            if let colorSpace = lhs.cgColor.colorSpace,
                let cgColor = CGColor(colorSpace: colorSpace, components: multipliedComponents) {
                return FinalColor(cgColor: cgColor)
            }
        }
        
        return lhs
    }
    
    /// Divides a color with a floaing-point number. Color components are devided with the floating-point.
    ///
    /// - Parameters:
    ///   - lhs: the color.
    ///   - rhs: the floating-point number.
    /// - Returns: resulted color.
    public static func /(lhs: FinalColor, rhs: CGFloat) -> FinalColor {
        if let lhsComponents = lhs.cgColor.components {
            var dividedComponents: [CGFloat] = []
            
            for index in 0..<lhsComponents.count {
                dividedComponents.append(lhsComponents[index] / rhs)
            }
            
            if let colorSpace = lhs.cgColor.colorSpace,
                let cgColor = CGColor(colorSpace: colorSpace, components: dividedComponents) {
                return FinalColor(cgColor: cgColor)
            }
        }
        
        return lhs
    }
}
