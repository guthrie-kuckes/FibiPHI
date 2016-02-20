//
//  orderHandling.swift
//  FibiPHI
//
//  Created by Shadow on 3/28/2015AD.
//  Copyright (c) 2015 Obsidian Design. All rights reserved.
//

import Foundation


/**
    The singleton enumeration instance for the application
*/
private var realSharedOrdering : Ordering? = nil


/**
    Essentially, takes care of switching between PHI and its reciprocal
    - really it is a sort of stopgap solution to the problem
    - realize that to have in points a ratio that is PHI, bigger numbers must be divided by smaller numbers
    whereas to get a ratio that is its reciprocal, smaller numbers must be divided by bigger numbers. Instead of having a bunch
    of procedural calls, I decided to have this class.
 
    - note: Is effectively a singleton enumeration
*/
internal enum Ordering : CGFloat {
    
    /**
        When we the application is using the reciprocal of the golden ratio
    */
    case PHI = 0.6180339887498948482045868343656381177203091798057628621
    
    
    /**
        When the application is using the golden ratio.
    */
    case PHI_1 = 1.6180339887498948482045868343656381177203091798057628621
    
    ///Switches the singleton enumeration to the opposite value. sensible for the applcation will be switching back and forth between the two
    static func opp() {
        if realSharedOrdering == PHI {
            realSharedOrdering = PHI_1
        } else {
            realSharedOrdering = PHI
        }
    }
    
    /**
        Returns the singleton enumeration instance, initializes it if necessary.
    */
    static func sharedOrdering() -> Ordering {
        
        if realSharedOrdering == nil {
            
            realSharedOrdering = Ordering.PHI_1
        }
        
        return realSharedOrdering!
    }
}



/**
    Deals with the fact that the x/y of a point in the graph should be switched depending on the value
    of the golden ratio which is used. Uses the shared Ordering
    
    - parameters:
        - x: What may or may not be the x coordinate of the point
        - y: What may or may not be the y coordinate of the point
 
    - returns: A point made in the correct order, according to the singleton Ordering instance
 
    - seeAlso: Ordering
*/
internal func autoReversePointMake(x: CGFloat, y: CGFloat) -> CGPoint {
    
    if (Ordering.sharedOrdering() == .PHI_1) {
        return CGPointMake(x, y)
    }
    
    return CGPointMake(y, x)
    
}

///same diff but for the table. could probably be replaced by a generic somehow
internal func orderReverseDivision(divided: CGFloat, divisor: CGFloat) -> CGFloat {
    
    if (Ordering.sharedOrdering() == .PHI_1) {
        return divided/divisor
    }
    
    return divisor/divided
}

