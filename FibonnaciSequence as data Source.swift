//
//  FibonnaciSequence as data Source.swift
//  FibiPHI
//
//  Created by GK on 1/16/16.
//  Copyright © 2016 Obsidian Design. All rights reserved.
//



import AppKit



// this extension is solely to give the functionality as a table view data source
extension DasFibbonaciSequence : NSTableViewDataSource {
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return self.numbers.count
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        
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
                return smallNumberFormatter.stringFromNumber(ultimate)
            }
            
            return ultimate
        }
        
        return "Error. Contact Developer" //should never be reached
    }
    
}
