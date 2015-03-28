//
//  orderHandling.swift
//  FibiPHI
//
//  Created by Shadow on 3/28/2015AD.
//  Copyright (c) 2015 Obsidian Design. All rights reserved.
//

import Foundation


private var realSharedOrdering : Ordering? = nil


enum Ordering : CGFloat {
    
    case PHI = 0.6180339887498948482045868343656381177203091798057628621
    case PHI_1 = 1.6180339887498948482045868343656381177203091798057628621
    
    //gives the opposite. sensicle for I will be switching back and forth between the two
    static func opp() {
        if realSharedOrdering == PHI {
            realSharedOrdering = PHI_1
        } else {
            realSharedOrdering = PHI
        }
    }
    
    static func sharedOrdering() -> Ordering {
        
        if realSharedOrdering == nil {
            
            realSharedOrdering = Ordering.PHI_1
        }
        
        return realSharedOrdering!
    }
}

//this is a shortCut to make all my old code compatible to deal with different PHIs easily
func autoReversePointMake(x: CGFloat, y: CGFloat) -> CGPoint {
    
    if (Ordering.sharedOrdering() == .PHI_1) {
        return CGPointMake(x, y)
    }
    
    return CGPointMake(y, x)
    
}

//same diff but for the table. could probably be replaced by a generic somehow
func orderReverseDivision(divided: CGFloat, divisor: CGFloat) -> CGFloat {
    
    if (Ordering.sharedOrdering() == .PHI_1) {
        return divided/divisor
    }
    
    return divisor/divided
}

