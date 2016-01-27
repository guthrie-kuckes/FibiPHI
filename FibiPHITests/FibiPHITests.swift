//
//  FibiPHITests.swift
//  FibiPHITests
//
//  Created by Shadow on 2/16/2015AD.
//  Copyright (c) 2015 Obsidian Design. All rights reserved.
//

import Cocoa
import XCTest
import FibiPHI

class FibiPHITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testFibSequencePerformance() {
        
        let newSeq = DasFibbonaciSequence()
        self.measureBlock { () -> Void in
            
            newSeq.realizeNumberOfTerms(50)
            for i in 0...999 {
                newSeq.changeStartingNumber(i)
            }
        }
    }
    
    
    /*
    func testPerformanceExample() {
        // This is an example of a performance test case.
        
        
        self.measureBlock() {
            // Put the code you want to measure the time of here.
            
            for _ in 0...100000 {
                
                view.setNeedsDisplayInRect(view.bounds)
            }
        }
    }*/
    
}
