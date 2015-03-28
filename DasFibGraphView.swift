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


private let zPoint = CGPointMake(0, 0)



class fibGraphView : NSView  {
    
    
    private let markerDrawingAttributes = [NSForegroundColorAttributeName : NSColor.blueColor() , NSBackgroundColorAttributeName : NSColor.lightGrayColor()]

    
    private (set) var fibonnaciNumbers = DasFibbonaciSequence()
    
    private (set) var coordinateDilation : Float = 100
    
    
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
        let startingX : CGFloat = dirtyRect.origin.x //note they are all CGFloats
        let startingY : CGFloat = dirtyRect.origin.y
        
        let endingX = startingX + dirtyRect.size.width
        let endingY = startingY + dirtyRect.size.height
        
        let graphLineWidth : CGFloat = 1
        
        let cgInterval = CGFloat(coordinateDilation)
        
        var horizontalStart = [CGPoint]()
        var horizontalEnd = [CGPoint]()
        
        let numberOfTimesHorizontal : CGFloat = CGFloat(floor(startingY / cgInterval))//I think this and its equivalent are switched
        
        for var Index : CGFloat = numberOfTimesHorizontal * cgInterval; Index < endingY ; Index += cgInterval {
            
                let newStartPoint = CGPointMake(startingX, Index)
                let newEndPoint = CGPointMake(endingX, Index)
                
                horizontalStart.append(newStartPoint)
                horizontalEnd.append(newEndPoint)
        }
        
        
        
        var verticalStart = [CGPoint]()
        var verticalEnd = [CGPoint]()
        
        
        let numberOfTimesVertical : CGFloat = floor(startingY / cgInterval)
        
        for var Index : CGFloat = numberOfTimesVertical * cgInterval ; Index < endingX ; Index += cgInterval {
            
            
                let newStartPoint = CGPointMake(Index, startingY)
                let newEndPoint = CGPointMake(Index, endingY)
                
                verticalStart.append(newStartPoint)
                verticalEnd.append(newEndPoint)
        }
        
        
        
        var horizontalBezier = NSBezierPath()
        var externalHorizontalIndex : Int = 0 // this is done (as way to avoid a regular for loop) to loop through both arrays at the same time
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
        
        verticalBezier.lineWidth = graphLineWidth
        verticalBezier.stroke() //note assuming color here
        
        
//done with drawing graph lines
//start drawing axis labels (axes themselves not drawn truly)
        
        let linesPerLabel = Int(ceil( 100.0 / coordinateDilation))
        

        for var Iterator = 0 ; Iterator < horizontalStart.count ; Iterator += linesPerLabel {
            
            let actualNumber = horizontalStart[Iterator].y
            let calibratedLabel = actualNumber / cgInterval
            let label : NSString = "\(calibratedLabel)"
            
            let regPoint = horizontalStart[Iterator]
            let betterPoint = CGPointMake(regPoint.x + 1.0, regPoint.y + 1.0)
            
            label.drawAtPoint(betterPoint, withAttributes: markerDrawingAttributes)
        }
        
        
        for var Iterator = 0 ; Iterator < verticalStart.count ; Iterator += linesPerLabel {
            
            let actualNumber = verticalStart[Iterator].x
            let calibratedLabel = actualNumber / cgInterval
            let label : NSString = "\(calibratedLabel)"
            
            let regPoint = verticalStart[Iterator]
            let betterPoint = CGPointMake(regPoint.x + 1.0, regPoint.y + 1.0)
            
            label.drawAtPoint(betterPoint, withAttributes: markerDrawingAttributes)
        }
        

        
//done with background , draw golden ratio line
//at this point is decently rect compliant
            var goldenBezierPath = NSBezierPath()
            goldenBezierPath.moveToPoint(zPoint)
            
            let goldenYEnd : CGFloat = PHI_P1 * (startingX + dirtyRect.size.width)
            let goldenEndPoint = CGPointMake(endingX, goldenYEnd)
            goldenBezierPath.lineToPoint(goldenEndPoint)
            
            goldenBezierPath.lineWidth = 3
            NSColor.redColor().setStroke()
            goldenBezierPath.stroke()
    
        
        
//done ratio line, draw the fibonacci numbers
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
            
            let newPoint = CGPointMake(previousNumber, thisNumber)
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


