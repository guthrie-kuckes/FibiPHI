//
//  DasFibGraphView.swift
//  FibiPHI
//
//  Created by Shadow on 2/16/2015AD.
//  Copyright (c) 2015 Obsidian Design. All rights reserved.
//





import AppKit


//TODO: make as much as possible of this use CoreGraphics
//TODO: implement this as two classes, have a plain graph paper class



///the point at teh top left corner of the screen
private let zPoint = CGPointMake(0, 0)


///how we draw the graph scale labels.
/// TODO: Make the labels look nicer
private let markerDrawingAttributes = [NSForegroundColorAttributeName : NSColor.blueColor() ] //, NSBackgroundColorAttributeName : NSColor.lightGrayColor()]


// TODO: implement changing the size and density of the line as we zoom in and out
///the width of the scale lines in the graph
internal let graphLineWidth : CGFloat = 1


///the pixel thickness of the line y = PHI * x
private let PHILineWidth : CGFloat = 3.0;



///the grey color of the lines on the graph.
private let ourGrey = NSColor(colorLiteralRed: 172/255, green: 170/255, blue: 171/255, alpha: 1.0  ).CGColor


/**
    Slightly extended NSBezierPath to save myself a few lines of code, making a method for a few calls I often do in succession
*/
internal extension NSBezierPath {
    
    
    ///Moves the path to point, and then draws a line to toPoint
    func lineFrom(point point: CGPoint, toPoint: CGPoint) {
        
        self.moveToPoint(point)
        self.lineToPoint(toPoint)
    }
}



/**
 Gives the opacity for the width of a small bar (in px)
 
 - parameter smallBarWidth: the width of one of the small bars on the graph, in pixels
 - returns: the percent opacity for the scale lines, in percent (e.g., the alpha of a CGColor)
 
 - seeAlso: smallBarValueForScale()

*/
internal func opacityForScale(smallBarWidth px: CGFloat) -> CGFloat {
    
    let toReturn = (200.0/9.0 + (7.0/18.0 + 5.0) * px) / 100.0;
    //print("the value was \(toReturn)")
    return toReturn
}


/**

    Graphs the Fibonnacci sequence, using a DASFibonnacci sequence object for its data. 
 
    - seeAlso: DASFibbonaciSequence
*/
public class DASFibGraphView : NSView  {
    

    ///the data that the graph is going to represent
    private (set) var fibonnaciNumbers = DASFibbonaciSequence(computedTerms: 30)
    
    
    ///the scale of the graph. in px : 1 unit
    private (set) var coordinateDilation : CGFloat = 100
    
    ///the queue operations not happening on the main queue happen on while drawing this view
    private let graphMaker = NSOperationQueue()

    
    
    ///have our own initalizer, to be able to better initalize graphMaker
    override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
        
        self.graphMaker.maxConcurrentOperationCount = 2
    }
    

    ///required if we want to have our own initializer.
    //TODO: figure out why this keeps getting called on start up, and implement it truly
    required public init?(coder: NSCoder) {
        
        super.init(coder: coder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    
    ///A / B starts refers to a mathematics paper on fibonacci numbers I read.
    ///in otherwords, change the second seed. and then redraw
    ///TODO: impelement changing the first seed
    func changeFibbonaciStartB(newStartB: Int) {
        
        self.fibonnaciNumbers.changeStartingNumber(newStartB)
        self.setNeedsDisplayInRect(self.bounds)
    }
    
    
    ///for changing the scale of the graph from within the program.
    ///the dilation is how many px : 1  unit
    func changeScale(newDilation: CGFloat) {
        
        self.coordinateDilation = newDilation
        self.setNeedsDisplayInRect(self.bounds)
        
    }
    
    
    ///event that can be sent by the mouse to change the scale
    override public func magnifyWithEvent(event: NSEvent) {
        
        let requestedMagnification = CGFloat(event.magnification + 1.0)
        let combinedMagnification = CGFloat(self.coordinateDilation) * requestedMagnification
        //Swift.print("\(requestedMagnification) the event mag was")
        
        DasSharedDelegate?.ScaleSlider.doubleValue = Double(combinedMagnification) //moves the scale slider as we use the mousepad to change the scale
        
        self.changeScale(combinedMagnification)
    }


    
    ///this can be used anywhere on the scren for getting graph lines however not everywhere for getting the golden ratio line ( i think)
    override public func drawRect(dirtyRect: NSRect) {
        
        Swift.print("doing rerendering (inside drawrect:)")
        
        
        
        let boundsPath = NSBezierPath(rect: self.bounds)
        NSColor.whiteColor().setFill()
        boundsPath.fill()
        
        
        
        //this is just the function that does something like graph paper
        
        var horizontalStart = [CGPoint]()
        var horizontalEnd = [CGPoint]()
        
        var verticalStart = [CGPoint]()
        var verticalEnd = [CGPoint]()
        
        
        var horizontalBezier = CGPathCreateMutable()
        var horizontalBold = CGPathCreateMutable()
        
        var verticalBezier = CGPathCreateMutable()
        var verticalBold = CGPathCreateMutable()
        
        

        let verticalGenerator =   getLineMaker(&verticalBezier,   boldPath: &verticalBold,   startPointArray: &verticalStart,   endPointArray: &verticalEnd,   theRect: dirtyRect, isVertical: true ,  coordinateDilation: self.coordinateDilation)
        let horizontalGenerator = getLineMaker(&horizontalBezier, boldPath: &horizontalBold, startPointArray: &horizontalStart, endPointArray: &horizontalEnd, theRect: dirtyRect, isVertical: false, coordinateDilation: self.coordinateDilation)
        
        let graphMaker = NSOperationQueue()
        graphMaker.addOperationWithBlock(verticalGenerator)
        graphMaker.addOperationWithBlock(horizontalGenerator)
        graphMaker.waitUntilAllOperationsAreFinished()

        
       //Swift.print("horizontal bold had \(horizontalBold.elementCount), vertical bold had \(verticalBold.elementCount)")
        Swift.print("horizontalStart had \(horizontalStart.count) outside")
        
        
        
        let largeBar = smallBarValueForScale(scale: self.coordinateDilation) * coordinateDilation
        let goodOpacity = opacityForScale(smallBarWidth: largeBar)
        Swift.print("largebar was \(largeBar)")
        let adjustedGrey = CGColorCreateCopyWithAlpha(ourGrey, goodOpacity)
        let adjustedBlack = CGColorCreateCopyWithAlpha(NSColor.blackColor().CGColor, goodOpacity + 0.1)
        
        
        let currentContext = NSGraphicsContext.currentContext()?.CGContext
        CGContextAddPath(currentContext, horizontalBezier)
        CGContextAddPath(currentContext, verticalBezier)
        CGContextSetLineWidth(currentContext, graphLineWidth)
        CGContextSetStrokeColorWithColor(currentContext, adjustedGrey)
        CGContextStrokePath(currentContext)
        
        
        CGContextSetStrokeColorWithColor(currentContext, adjustedBlack)
        CGContextSetLineWidth(currentContext, graphLineWidth + 1.0)
        CGContextAddPath(currentContext, verticalBold)
        CGContextAddPath(currentContext, horizontalBold)
        CGContextStrokePath(currentContext)

        
        
        

        //done with drawing graph lines
        //start drawing axis labels (axes themselves not drawn truly)
        
        

        for var Iterator = 0 ; Iterator < horizontalStart.count ; Iterator += 5 {
            
            let actualNumber = horizontalStart[Iterator].y
            let calibratedLabel : CGFloat = actualNumber / coordinateDilation
            let label : NSString = GraphViewFormatLabel(calibratedLabel)
            
            let regPoint = horizontalStart[Iterator]
            let betterPoint = CGPointMake(regPoint.x + 1.0, regPoint.y + 1.0)
            
            label.drawAtPoint(betterPoint, withAttributes: markerDrawingAttributes)
        }
        
        
        for var Iterator = 0 ; Iterator < verticalStart.count ; Iterator += 5 {
            
            let actualNumber = verticalStart[Iterator].x
            let calibratedLabel = actualNumber / coordinateDilation
            let label : NSString = GraphViewFormatLabel(calibratedLabel)
            
            let regPoint = verticalStart[Iterator]
            let betterPoint = CGPointMake(regPoint.x + 1.0, regPoint.y + 1.0)
            
            label.drawAtPoint(betterPoint, withAttributes: markerDrawingAttributes)
        }
        

        
//done with background , draw golden ratio line
//at this point is decently rect compliant
            let goldenBezierPath = NSBezierPath()
            goldenBezierPath.moveToPoint(zPoint)
                
            let goldenYEnd : CGFloat = Ordering.sharedOrdering().rawValue * (dirtyRect.origin.x + dirtyRect.size.width)
            let goldenEndPoint = CGPointMake(dirtyRect.origin.x + dirtyRect.width , goldenYEnd)
            goldenBezierPath.lineToPoint(goldenEndPoint)
            
            goldenBezierPath.lineWidth = PHILineWidth
            NSColor.redColor().setStroke()
            goldenBezierPath.stroke()
    
        
        
//done ratio line, draw the fibonacci numbers
        
        //for this is not compliant with other sequences
        let numberPreviousToStart : CGFloat = 0.0
        
        let betterStart = CGFloat(fibonnaciNumbers.startingNumber) * coordinateDilation
        let firstPoint = autoReversePointMake(numberPreviousToStart, y: betterStart)//CGPointMake(numberPreviousToStart, betterStart)
        
        let FibonacciBezierPath = NSBezierPath()
        
        FibonacciBezierPath.moveToPoint(firstPoint)
                
        assert(currentContext != nil, "error: problems getting a CGContext from an NSGraphicsContext")
        
        
        CGContextSetLineWidth(currentContext, 4.0)
        NSColor.blackColor().setStroke()
        for var Index = 1 ; Index < fibonnaciNumbers.currentCount ; Index++ {
            
            let thisNumber : CGFloat = CGFloat(fibonnaciNumbers.numbers[Index]) * coordinateDilation
            let previousNumber : CGFloat = CGFloat( fibonnaciNumbers.numbers[Index - 1]) * coordinateDilation
            
            let newPoint = autoReversePointMake(previousNumber, y: thisNumber)//CGPointMake(previousNumber, thisNumber)
            FibonacciBezierPath.lineToPoint(newPoint)
            
            let pointRectangle = CGRectMake(newPoint.x - 5, newPoint.y - 5, 10, 10)
            CGContextFillEllipseInRect(currentContext, pointRectangle)
            CGContextStrokeEllipseInRect(currentContext, pointRectangle)
        }
        
        NSColor.greenColor().setStroke()
        FibonacciBezierPath.lineWidth = 4.0
        
        FibonacciBezierPath.stroke()
        
    }
    
}


