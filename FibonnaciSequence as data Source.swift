//
//  FibonnaciSequence as data Source.swift
//  FibiPHI
//
//  Created by GK on 1/16/16.
//  Copyright © 2016 Obsidian Design. All rights reserved.
//



import AppKit




/**
    The number formatter used for very small numbers in the table.
    - Uses Scientific notation.
    - Has at max 8 significant digits.
*/
private let fibTableSmallNumberFormatter = makeFibbonnaciResidualNumberFormatter()


/**
    A simple Initializer function for fibTableSmallNumberFormatter
    - Its formatting details are covered in fibTableSmallNumberFormatter
 
    - seeAlso: fibTableSmallNumberFormatter
*/
private func makeFibbonnaciResidualNumberFormatter() -> NSNumberFormatter {
    
    let smallNumberFormatter = NSNumberFormatter()
    smallNumberFormatter.numberStyle = NSNumberFormatterStyle.ScientificStyle
    smallNumberFormatter.maximumSignificantDigits = 8

    return smallNumberFormatter
}



///This extension is solely to give the functionality as a table view data source
extension DASFibbonaciSequence : NSTableViewDataSource {
    
    
    ///Tells the table to display all the numbers in the fibonnaci sequence that we have computed
    public func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return self.numbers.count
    }
    
    ///Returns appropriate string values for both collums of the table view in the application.
    public func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        
        if(tableColumn?.identifier == "TermsDivided") {
            
            return stringPointRepresentation[row]
        } else if (tableColumn?.identifier == "Aproximation") {
            
            let pairToUse = aproximationExpressions[row]
            let divided = CGFloat(pairToUse.x)
            let divideBy = CGFloat(pairToUse.y)
            let answer = orderReverseDivision(divided, divisor: divideBy)
            
            
            let subjtracted : CGFloat = Ordering.sharedOrdering().rawValue - answer
            let ultimate = abs(subjtracted)
            
            if (ultimate < 0.000_1) {
                return fibTableSmallNumberFormatter.stringFromNumber(ultimate)
            }
            
            return ultimate
        }
        
        return "Error. Contact Developer" //should never be reached
    }
    
}
