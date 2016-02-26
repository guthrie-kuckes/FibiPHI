//
//  graph view external funcs.swift
//  FibiPHI
//
//  Created by GK on 2/13/16.
//  Copyright © 2016 Obsidian Design. All rights reserved.
//

import Foundation


/**
 Gives the value, in uints that one small scale marker should represent.
 
 - parameter scale: the scale of the graph, in pixels representing one unit
 - returns: the width of one of the small (non bold) scale markers, in units
 */
internal func smallBarValueForScale(scale scale: CGFloat) -> CGFloat {
    
    let ten : CGFloat = 10.0
    let theValue : CGFloat = pow(ten, 2.0 - ceil( log10( scale/2.5 ) ) ) / 5.0
    return theValue
}

/**
 Provides a no argument block which can generate lines for the graph, returning results through arguments provided to the function.
 - uses smallBarValueForScale to model
 
 - parameter normalPath: a path consisting of the generated small scale markings
 - parameter boldPath: a path consisting of the generated large scale markings 
 - parameter startPointArray: array of the points at the beginning of each scale line. a pointer in order for capturing to work properly
 - parameter endPointArray: array of the points at the end of each scale line. a pointer in order for capturing to work properly
 - parameter theRect: the rectangle to make the path inside of.
 - parameter isVertical: true means that lines will be paralell with the y axis. false means that the lines will be paralell to the x axis
 - parameter coordinateDilation: the scale of the graph, in pixels per unit
*/
internal func getLineMaker(inout normalPath: NSBezierPath, inout boldPath: NSBezierPath, startPointArray: UnsafeMutablePointer<[CGPoint]>, endPointArray: UnsafeMutablePointer<[CGPoint]>, let theRect: CGRect, let isVertical: Bool, let coordinateDilation: CGFloat) -> () -> Void {

    
    let startingValue : CGFloat
    let endingValue : CGFloat
    
    let oppositeEnd : CGFloat
    let oppositeStart : CGFloat
    /*
        startingValue is the value of of the beginning of the line that is the same for all vertical lines, and all horizontal lines.
    It represents one edge of the graph. This means that all vertical lines, for example, will begin at coordinates of the form 
    (x, startingValue). Ending value represents the other edge of the graph, and is also the same for all beginning/ends of either types
    of lines so the end of vertical lines would have coordinates like (x, endingValue)
        oppositeEnd/oppositeStart are necessary because these represent the relevant parts of the axes that we are effectively tesselating
    along. They will be defined.
    */

    
    let currentProcess : (CGFloat) -> (CGPoint,  CGPoint) //esentially this is saying "what function do we use to get the starting and end point of a line given the flexible (x in the comment above) part of the coordinate?" this is defined below
    
    
    if(isVertical) { //making lines parallell to the y axis
        
        
        startingValue = theRect.origin.y
        endingValue = startingValue + theRect.height
        
        oppositeEnd = theRect.origin.x + theRect.width
        oppositeStart = theRect.origin.x
        
        func verticalProcess(index: CGFloat) -> (CGPoint, CGPoint) {
            
            let startPoint = CGPointMake(index, startingValue)
            let endPoint = CGPointMake(index, endingValue)
            return (startPoint, endPoint)
        }
        
        
        currentProcess = verticalProcess
        
    } else { //making lines paraellel to the x axis
        
        
        startingValue = theRect.origin.x
        endingValue = startingValue + theRect.width
        
        oppositeEnd = theRect.origin.y + theRect.height
        oppositeStart = theRect.origin.y
        
        func horizontalProcess(index: CGFloat) -> ( CGPoint,  CGPoint) {
            
            let startPoint = CGPointMake(startingValue, index)
            let endPoint = CGPointMake(endingValue, index)
            return (startPoint, endPoint)
        }
        
        currentProcess = horizontalProcess
    }
    
    
    
    let smallBarValue : CGFloat = smallBarValueForScale(scale: coordinateDilation)
    let smallBarPixels : CGFloat = smallBarValue  * coordinateDilation
    let numberOfTimesAlreadyTesselated : CGFloat = floor(oppositeStart/smallBarPixels) //would maybe use this if we are talking about situations in which we are srolling/moving the graph
    
    
    func toReturn() {
        
        var timesThroughLoop = 0
        
        for var Index : CGFloat = numberOfTimesAlreadyTesselated * smallBarPixels; Index < oppositeEnd; Index += smallBarPixels { //cg interval is thus the number of pixels which equals a scale of one.
            
            let (newStartPoint, newEndPoint) = currentProcess(Index)
            
            
            if(timesThroughLoop % 5 == 0) {
                
                boldPath.lineFrom(point: newStartPoint, toPoint: newEndPoint)
                
            } else {
                
                normalPath.lineFrom(point: newStartPoint, toPoint: newEndPoint)
            }
            
            
            startPointArray.memory.append(newStartPoint) //add them to a new array too make the labeling easier
            endPointArray.memory.append(newEndPoint)
            
            timesThroughLoop++
            
        }
        
        normalPath.lineWidth = graphLineWidth
        boldPath.lineWidth = graphLineWidth + 1
        
        //Swift.print("startPoint had \(startPointArray.memory.count) inside the func" )
        
    }
    
    return toReturn
}


/**
    The formatter for scale labels on the graph for very large or small numbers,
    controlling how numbers look
*/
private let GraphViewExrtremeLabelFormatter = makeGraphViewExtremeLabelFormatter()


/**
    makes the number formatter for the scale labels, used when they are very large or small
*/
private func makeGraphViewExtremeLabelFormatter() -> NSNumberFormatter {
    
    let ourFormatter = NSNumberFormatter()
    ourFormatter.usesSignificantDigits = true
    ourFormatter.maximumSignificantDigits = 5
    ourFormatter.minimumSignificantDigits = 3
    ourFormatter.numberStyle = .ScientificStyle

    return ourFormatter
}


/**
    The formatter for scale labels on the graph, used for numbers that are not very 
    small, and not very large. controls how the numbers look, and rounds so that 
    floating point errors (which seem to happen more often than they should?) don't
    show through
*/
private let GraphViewMiddlingLabelFormatter = makeGraphViewMiddlingLabelFormatter()


/**
    makes the formatter for scale labels when the numbers for the labels are neither very small nor very large.
*/
private func makeGraphViewMiddlingLabelFormatter() -> NSNumberFormatter {
    
    let thisFormatter = NSNumberFormatter()
    thisFormatter.minimumFractionDigits = 2
    
    return thisFormatter
}


/**
    Does all necessary number formatting for a an axis label. 
    - if less than 10,000 or greater or equal to 0.001, will return a formatted decimal, rounding to about the hundreds place
    - otherwise, will return a scientific notation formatted string with at most five digits dignificant figures, at least three
 
    - parameter labelValue: the number to format
    - returns: returns the number formatted as an NSString so that it can be very easily drawn.
*/
internal func GraphViewFormatLabel(labelValue: CGFloat) -> NSString {
    
    if( (labelValue < 10_000.0 && labelValue >= 0.01) || labelValue == 0.0) {
        
        return GraphViewMiddlingLabelFormatter.stringFromNumber(labelValue)!
    }
    
    return GraphViewExrtremeLabelFormatter.stringFromNumber(labelValue)!
}



