//
//  FibiPHITests.swift
//  FibiPHITests
//
//  Created by Shadow on 2/16/2015AD.
//  Copyright (c) 2015 Obsidian Design. All rights reserved.
//

import Cocoa
import XCTest
@testable import FibiPHI


let testingNum = 100


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
        
        let newSeq = DASFibbonaciSequence()
        self.measureBlock { () -> Void in
            
            newSeq.realizeNumberOfTerms(1000)
            for i in 0...4 {
                newSeq.changeStartingNumber(i)
            }
        }
    }
    
    let rectValues : CGFloat  = 1_000
    
    /*
    func testLineGenerationPerformance() {
        

        let rect = CGRectMake(0,0,rectValues, rectValues)

        
        self.measureBlock { () -> Void in
    
            for _ in 0..<testingNum {
            
        
                var horizontalStart = [CGPoint]()
                var horizontalEnd = [CGPoint]()
                
                var verticalStart = [CGPoint]()
                var verticalEnd = [CGPoint]()
            
            
            var horizontalBezier = NSBezierPath()
            var horizontalBold = NSBezierPath()
            
            var verticalBezier = NSBezierPath()
            var verticalBold = NSBezierPath()
            
            let verticalGenerator =   getLineMaker(&verticalBezier,   boldPath: &verticalBold,   startPointArray: &verticalStart,   endPointArray: &verticalEnd,   theRect: rect, isVertical: true ,  coordinateDilation: 100.0)
            let horizontalGenerator = getLineMaker(&horizontalBezier, boldPath: &horizontalBold, startPointArray: &horizontalStart, endPointArray: &horizontalEnd, theRect: rect, isVertical: false, coordinateDilation: 100.0)
            verticalGenerator()
            horizontalGenerator()
                
            }
        }
    }
    
    func testLineGenerationPerformanceMultithread() {
        
        
        let rect = CGRectMake(0,0, rectValues, rectValues)

        
        self.measureBlock { () -> Void in
            
            for _ in 0..<testingNum {
                
                var horizontalStart = [CGPoint]()
                var horizontalEnd = [CGPoint]()
                
                var verticalStart = [CGPoint]()
                var verticalEnd = [CGPoint]()
                
                
                var horizontalBezier = NSBezierPath()
                var horizontalBold = NSBezierPath()
                
                var verticalBezier = NSBezierPath()
                var verticalBold = NSBezierPath()
                
                let verticalGenerator =   getLineMaker(&verticalBezier,   boldPath: &verticalBold,   startPointArray: &verticalStart,   endPointArray: &verticalEnd,   theRect: rect, isVertical: true ,  coordinateDilation: 100.0)
                let horizontalGenerator = getLineMaker(&horizontalBezier, boldPath: &horizontalBold, startPointArray: &horizontalStart, endPointArray: &horizontalEnd, theRect: rect, isVertical: false, coordinateDilation: 100.0)
            
                let graphMaker = NSOperationQueue()
                graphMaker.addOperationWithBlock(verticalGenerator)
                graphMaker.addOperationWithBlock(horizontalGenerator)
                graphMaker.waitUntilAllOperationsAreFinished()
            }
        }

    }
    */
    
    
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
