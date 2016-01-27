//
//  numInterface.swift
//  FibiPHI
//
//  Created by GK on 1/17/16.
//  Copyright © 2016 Obsidian Design. All rights reserved.
//

import Foundation


public class GMPRational : CustomStringConvertible {
    
    var real : UnsafeMutablePointer<mpf_t>  = memory()

    
    init() {
        
        initFloatWithValue(real, 0)
    }
    
    public init(value: Double) {
        
        initFloatWithValue(real, value)
    }

    
    deinit  {
    
        deinitFloat(real)
    }
    
    func setValue(val: Double) {
        setFloatValue(real, val)
    }
    
    public var description : String {
        
        get {
            
            let good = NSString(CString: getFloatDescription(real), encoding: NSUTF8StringEncoding )
            return good as! String
        }
    }
}