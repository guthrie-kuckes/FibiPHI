//
//  DasFibGraphView.swift
//  FibiPHI
//
//  Created by Shadow on 2/16/2015AD.
//  Copyright (c) 2015 Obsidian Design. All rights reserved.
//

import Foundation
import Darwin
import Cocoa
import AppKit






class fibGraphView : NSView  {
    
    
    private let markerDrawingAttributes = [NSForegroundColorAttributeName : NSColor.blueColor() , NSBackgroundColorAttributeName : NSColor.lightGrayColor()]

    
    private (set) var fibonnaciNumbers = DasFibbonaciSequence()
    
    private  var coordinateDilation : Float = 100
    
    var currentDilation : Float {
        get {
            return coordinateDilation
        }
    }
    
    func changeFibbonaciStartB(newStartB: Int) { //A / B starts refers to a mathematics paper on fibonacci numbers I read
        
        self.fibonnaciNumbers.changeStartingNumber(newStartB)
        self.setNeedsDisplayInRect(self.bounds)
    }
    
    
    func changeScale(newDilation: Float) {
        
        self.coordinateDilation = Float(newDilation)
        self.setNeedsDisplayInRect(self.bounds)
        DasSharedDelegate?.ScaleSlider.floatValue = newDilation
    }
    
    
    //this can be used anywhere on the scren for getting graph lines however not everywhere for getting the golden ratio line ( i think)
    override func drawRect(dirtyRect: NSRect) {
        
        //this is just the function that does something like graph paper
        let startingX = dirtyRect.origin.x
        let startingY = dirtyRect.origin.y
        
        let endingX = startingX + dirtyRect.size.width
        let endingY = startingY + dirtyRect.size.height
        
        
        let graphLineWidth : CGFloat = 1
        let simpleGraphInterval = Int(coordinateDilation)
        let graphInterval : CGFloat = CGFloat(simpleGraphInterval)
        
        
        var horizontalStart = [CGPoint]()
        var horizontalEnd = [CGPoint]()
        
        for var Index = startingY ; Index < endingY ; Index++ {
            
            if (Index % graphInterval == 0) {
                
                let newStartPoint = CGPointMake(startingX, Index)
                let newEndPoint = CGPointMake(endingX, Index)
                
                horizontalStart.append(newStartPoint)
                horizontalEnd.append(newEndPoint)
            }
        }
        
        
        
        var verticalStart = [CGPoint]()
        var verticalEnd = [CGPoint]()
        
        
        for var Index = startingX ; Index < endingX ; Index++ {
            
            if (Index % graphInterval == 0) {
                
                let newStartPoint = CGPointMake(Index, startingY)
                let newEndPoint = CGPointMake(Index, endingY)
                
                verticalStart.append(newStartPoint)
                verticalEnd.append(newEndPoint)
            }
            
        }
        
        
        
        var horizontalBezier = NSBezierPath()
        var externalHorizontalIndex : Int = 0
        for point in horizontalStart {
            
            horizontalBezier.moveToPoint(point)
            horizontalBezier.lineToPoint(horizontalEnd[externalHorizontalIndex])
            
            externalHorizontalIndex++
        }
        
        NSColor.blackColor().setStroke()
        horizontalBezier.lineWidth = graphLineWidth
        horizontalBezier.stroke()
        
        
        var verticalBezier = NSBezierPath()
        var externalVerticalIndex : Int = 0
        for point in verticalStart {
            
            verticalBezier.moveToPoint(point)
            verticalBezier.lineToPoint(verticalEnd[externalVerticalIndex])
            
            externalVerticalIndex++
        }
        
        NSColor.blackColor().setStroke()
        verticalBezier.lineWidth = graphLineWidth
        verticalBezier.stroke()
        
        
        let linesPerLabel = Int(ceil( Double(100.0) / Double(coordinateDilation)))
        println("lines per label was \(linesPerLabel)")
        
        
        
        for var Iterator = 0 ; Iterator < horizontalStart.count ; Iterator += linesPerLabel {
            
            let actualNumber = Float(horizontalStart[Iterator].y)
            //fudging
            let calibratedLabel = ceil(actualNumber / coordinateDilation)
            let label : NSString = "\(calibratedLabel)"
            
            let regPoint = horizontalStart[Iterator]
            let betterPoint = CGPointMake(regPoint.x + 1.0, regPoint.y + 1.0)
            
            label.drawAtPoint(betterPoint, withAttributes: markerDrawingAttributes)
        }
        
        
        for var Iterator = 0 ; Iterator < verticalStart.count ; Iterator += linesPerLabel {
            
            let actualNumber = Float(verticalStart[Iterator].x)
            //fudging
            let calibratedLabel = ceil(actualNumber / coordinateDilation)
            let label : NSString = "\(calibratedLabel)"
            
            let regPoint = verticalStart[Iterator]
            let betterPoint = CGPointMake(regPoint.x + 1.0, regPoint.y + 1.0)
            
            label.drawAtPoint(betterPoint, withAttributes: markerDrawingAttributes)
        }
        

        
        
        //this part not really any rect compliant
        if (startingX == 0 && startingY == 0) {
            
            var goldenBezierPath = NSBezierPath()
            goldenBezierPath.moveToPoint(dirtyRect.origin)
            
            let goldenYEnd : CGFloat = PHI * dirtyRect.size.width
            let goldenEndPoint = CGPointMake(endingX, goldenYEnd)
            goldenBezierPath.lineToPoint(goldenEndPoint)
            
            goldenBezierPath.lineWidth = 3
            NSColor.redColor().setStroke()
            goldenBezierPath.stroke()
        }
        
        
        if (fibonnaciNumbers.currentCount == 0) {
            
            fibonnaciNumbers.realizeNumberOfTerms(30)
        }
        
        
        //for this is not compliant with other sequences
        let numberPreviousToStart : CGFloat = 0.0
        
        let dilation = coordinateDilation
        let betterStart = CGFloat( Float(fibonnaciNumbers.startingNumber) * dilation)
        let firstPoint = CGPointMake(numberPreviousToStart, betterStart)
        
        var FibonacciBezierPath = NSBezierPath()
        
        FibonacciBezierPath.moveToPoint(firstPoint)
        
        let currentContext = NSGraphicsContext.currentContext()?.CGContext
        println("doing rerendering (inside drawrect:)")
        if (currentContext == nil) {
            println("problems getting graphics context")
            exit(5)
        }
        
        CGContextSetLineWidth(currentContext, 4.0)
        NSColor.blackColor().setStroke()
        for var Index = 1 ; Index < fibonnaciNumbers.currentCount ; Index++ {
            
            let thisNumber : CGFloat = CGFloat(Float(fibonnaciNumbers.numbers[Index]) * dilation )
            let previousNumber : CGFloat = CGFloat( Float(fibonnaciNumbers.numbers[Index - 1]) * dilation)
            
            let newPoint = CGPointMake(thisNumber, previousNumber)
            FibonacciBezierPath.lineToPoint(newPoint)
            
            let pointRectangle = CGRectMake(newPoint.x - 5, newPoint.y - 5, 10, 10)
            CGContextFillEllipseInRect(currentContext, pointRectangle)
            CGContextStrokeEllipseInRect(currentContext, pointRectangle)
        }
        
        NSColor.greenColor().setStroke()
        FibonacciBezierPath.lineWidth = 4.0
        
        FibonacciBezierPath.stroke()
    }
    
    
    override func magnifyWithEvent(event: NSEvent) {
        
        let requestedMagnification = CGFloat(event.magnification + 1.0)
        let combinedMagnification = CGFloat(self.coordinateDilation) * requestedMagnification
        self.changeScale(Float(combinedMagnification))
    }
    
}


