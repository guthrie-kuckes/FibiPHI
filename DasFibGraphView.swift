//
//  DasFibGraphView.swift
//  FibiPHI
//
//  Created by Shadow on 2/16/2015AD.
//  Copyright (c) 2015 Obsidian Design. All rights reserved.
//





import AppKit






//the point at teh top left corner of the screen
private let zPoint = CGPointMake(0, 0)


//how we draw the graph scale labels.
// TODO: Make the labels look nicer
private let markerDrawingAttributes = [NSForegroundColorAttributeName : NSColor.blueColor() , NSBackgroundColorAttributeName : NSColor.lightGrayColor()]


//the width of the scale lines in the graph
//TODO: implement changing the size and density of the line as we zoom in and out
private let graphLineWidth : CGFloat = 1


//the pixel thickness of the line y = PHI * x
private let PHILineWidth : CGFloat = 3.0;


//this is not being used. note it is specified incorrectly
///private let BabyPowder = NSColor(colorLiteralRed: 254, green: 254, blue: 250, alpha: 1.0)


//the grey color of the lines on the graph.
private let ourGrey = NSColor(colorLiteralRed: 172/255, green: 170/255, blue: 171/255, alpha: 1.0  )



extension NSBezierPath {
    
    func lineFrom(point: CGPoint, toPoint: CGPoint) {
        
        self.moveToPoint(point)
        self.lineToPoint(toPoint)
    }
}




public class fibGraphView : NSView  {
    

    //the data that the graph is going to represent
    private (set) var fibonnaciNumbers = DasFibbonaciSequence(computedTerms: 30)
    
    
    //the scale of the graph. in px : 1 unit
    private (set) var coordinateDilation : CGFloat = 100
    
    //the queue operations not happening on the main queue happen on while drawing this view
    private let graphMaker = NSOperationQueue()

    
    
    //have our own initalizer, to be able to better initalize graphMaker
    override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
        
        self.graphMaker.maxConcurrentOperationCount = 2
    }
    

    //required if we want to have our own initializer.
    required public init?(coder: NSCoder) {
        
        super.init(coder: coder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    
    //A / B starts refers to a mathematics paper on fibonacci numbers I read. 
    //in otherwords, change the second seed. and then redraw
    //TODO: impelement changing the first seed
    func changeFibbonaciStartB(newStartB: Int) {
        
        self.fibonnaciNumbers.changeStartingNumber(newStartB)
        self.setNeedsDisplayInRect(self.bounds)
    }
    
    
    //for changing the scale of the graph from within the program. 
    //the dilation is how many px : 1  unit
    func changeScale(newDilation: CGFloat) {
        
        self.coordinateDilation = newDilation
        self.setNeedsDisplayInRect(self.bounds)
        
    }
    
    
    //event that can be sent by the mouse to change the scale
    override public func magnifyWithEvent(event: NSEvent) {
        
        let requestedMagnification = CGFloat(event.magnification + 1.0)
        let combinedMagnification = CGFloat(self.coordinateDilation) * requestedMagnification
        Swift.print("\(requestedMagnification) the event mag was")
        
        DasSharedDelegate?.ScaleSlider.doubleValue = Double(combinedMagnification) //moves the scale slider as we use the mousepad to change the scale
        
        self.changeScale(combinedMagnification)
    }


    
    //this can be used anywhere on the scren for getting graph lines however not everywhere for getting the golden ratio line ( i think)
    override public func drawRect(dirtyRect: NSRect) {
        
        Swift.print("doing rerendering (inside drawrect:)")
        
        let boundsPath = NSBezierPath(rect: self.bounds)
        NSColor.whiteColor().setFill()
        boundsPath.fill()
        
        //this is just the function that does something like graph paper
        let startingX : CGFloat = dirtyRect.origin.x //note they are all CGFloats
        let startingY : CGFloat = dirtyRect.origin.y
        
        let endingX = startingX + dirtyRect.size.width
        let endingY = startingY + dirtyRect.size.height
        
        
        
        var horizontalStart = [CGPoint]()
        var horizontalEnd = [CGPoint]()
        
        var verticalStart = [CGPoint]()
        var verticalEnd = [CGPoint]()
        
        
        var horizontalBezier = NSBezierPath()
        var horizontalBold = NSBezierPath()
        
        var verticalBezier = NSBezierPath()
        var verticalBold = NSBezierPath()
        
        
        //for concurrency, the horizontal graph lines and vertical graph line making will be divided into seperate blocks to be executed concurrently on the same queue
        func makeHorizontalBezierPath() -> Void {
            
            let numberOfTimesHorizontal : CGFloat = CGFloat( floor(startingY / coordinateDilation) ) //I think this is to get something on the exact line, in case the cg interval is not so ezact
            
            
            var timesThroughLoop = 0
            
            for var Index : CGFloat = numberOfTimesHorizontal * coordinateDilation; Index < endingY ; Index += coordinateDilation { //cg interval is thus the number of pixels which equals a scale of one.
                
                let newStartPoint = CGPointMake(startingX, Index)
                let newEndPoint = CGPointMake(endingX, Index)
                
                
                if(timesThroughLoop % 5 == 0) {
                    
                    horizontalBold.lineFrom(newStartPoint, toPoint: newEndPoint)
                    
                } else {
                    
                    horizontalBezier.lineFrom(newStartPoint, toPoint: newEndPoint)
                }
                
                horizontalStart.append(newStartPoint) //add them to a new array too make the labeling easier
                horizontalEnd.append(newEndPoint)
                
                timesThroughLoop++
            }
            
            horizontalBezier.lineWidth = graphLineWidth
            horizontalBold.lineWidth = graphLineWidth + 1
        }
        
        
        func makeVerticalBezierPath() -> Void {
            
            let numberOfTimesVertical : CGFloat = floor(startingY / coordinateDilation)
            
            var timesThroughLoop = 0
            
            for var Index : CGFloat = numberOfTimesVertical * coordinateDilation ; Index < endingX ; Index += coordinateDilation {
                
                let newStartPoint = CGPointMake(Index, startingY)
                let newEndPoint = CGPointMake(Index, endingY)
                
                
                if(timesThroughLoop % 5 == 0) {
                    
                    verticalBold.lineFrom(newStartPoint, toPoint: newEndPoint)
                } else {
                    
                    verticalBezier.lineFrom(newStartPoint, toPoint: newEndPoint)
                }
                
                verticalStart.append(newStartPoint)
                verticalEnd.append(newEndPoint)
                
                timesThroughLoop++
            }
            
            
            verticalBezier.lineWidth = graphLineWidth
            verticalBold.lineWidth = graphLineWidth + 1
        }
        

        
        if(coordinateDilation > 0.9) { //this creates the effect of having zommed out of everything

            graphMaker.addOperationWithBlock(makeHorizontalBezierPath)
            graphMaker.addOperationWithBlock(makeVerticalBezierPath)
            graphMaker.waitUntilAllOperationsAreFinished()
            
            ourGrey.setStroke()
            horizontalBezier.stroke()
            verticalBezier.stroke()
            
            NSColor.blackColor().setStroke()
            horizontalBold.stroke()
            verticalBold.stroke()
        }
        

        //done with drawing graph lines
        //start drawing axis labels (axes themselves not drawn truly)
        
        
        let linesPerLabel = Int( ceil( 100.0 / coordinateDilation) ) //the effect is to have labels about every 100 px
        

        for var Iterator = 0 ; Iterator < horizontalStart.count ; Iterator += linesPerLabel {
            
            let actualNumber = horizontalStart[Iterator].y
            let calibratedLabel : CGFloat = floor(actualNumber / coordinateDilation)
            let label : NSString = "\(calibratedLabel)"
            
            let regPoint = horizontalStart[Iterator]
            let betterPoint = CGPointMake(regPoint.x + 1.0, regPoint.y + 1.0)
            
            label.drawAtPoint(betterPoint, withAttributes: markerDrawingAttributes)
        }
        
        
        for var Iterator = 0 ; Iterator < verticalStart.count ; Iterator += linesPerLabel {
            
            let actualNumber = verticalStart[Iterator].x
            let calibratedLabel = floor(actualNumber / coordinateDilation)
            let label : NSString = "\(calibratedLabel)"
            
            let regPoint = verticalStart[Iterator]
            let betterPoint = CGPointMake(regPoint.x + 1.0, regPoint.y + 1.0)
            
            label.drawAtPoint(betterPoint, withAttributes: markerDrawingAttributes)
        }
        

        
//done with background , draw golden ratio line
//at this point is decently rect compliant
            let goldenBezierPath = NSBezierPath()
            goldenBezierPath.moveToPoint(zPoint)
                
            let goldenYEnd : CGFloat = Ordering.sharedOrdering().rawValue * (startingX + dirtyRect.size.width)
            let goldenEndPoint = CGPointMake(endingX, goldenYEnd)
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
        
        let currentContext = NSGraphicsContext.currentContext()?.CGContext
        
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


