//
//  DasFibonacciSequence.swift
//  FibiPHI
//
//  Created by Shadow on 2/16/2015AD.
//  Copyright (c) 2015 Obsidian Design. All rights reserved.
//

import Foundation

///all these required
import Cocoa
import Darwin

//absurd amount of digits of the golden ratio
let PHI : CGFloat = 0.6180339887498948482045868343656381177203091798057628621
//just global contant for golden ratio plus one since my table is fudged and I need this to get residual
let PHI_P1 : CGFloat = 1.6180339887498948482045868343656381177203091798057628621


private typealias Pair = (x: Int , y: Int)


class DasFibbonaciSequence : NSObject {
    
    //reflects fact that this not completly compliant with other sequences if number that comes before is not zero
    private ( set) var startingNumber : Int = 1
    
    private (set) var numbers = [Int]()
    
    private var stringPointRepresentation = [String]()

    private var aproximationExpressions = [Pair]()
    
    private var smallNumberFormatter : NSNumberFormatter
    
    var currentCount : Int {
        get {
            
            return numbers.count
        }
    }
    
    func changeStartingNumber(newStart: Int) {
        
        if (newStart == self.startingNumber) {
            return
        }
        
        let count = currentCount
        self.numbers.removeAll(keepCapacity: true)
        
        self.startingNumber = newStart
        realizeNumberOfTerms(count)
    }
    
    //this takes a number of terms that numbers array should have
    //numbers array will have at least terms number of terms after calling it
    func realizeNumberOfTerms(terms: Int) {
        
        if (self.numbers.count >= terms) {
            
            return
        } else if (terms == 0) {
            return
        }
        
        
        var previousToStartingNumber : Int = 0
        
        
        if (numbers.count < 2) {
            
            if (numbers.count < 1 && terms >= 1) {
                
                let firstTerm = startingNumber
                numbers.append(firstTerm)
            }
            
            if (numbers.count < 2 || terms >= 2) {
                
                let secondTerm = startingNumber + previousToStartingNumber
                numbers.append(secondTerm)
            }
        }
        
        let gapToMakeUp = terms - numbers.count
        if (gapToMakeUp <= 0) {
            
            return
        }
        
        propogateTerms(gapToMakeUp)
        
        
        //done with actual numbers , doing acessories
        self.stringPointRepresentation.removeAll(keepCapacity: true)
        aproximationExpressions.removeAll(keepCapacity: true)
        
        let numberPreviousToStart = 0
        
        let betterStart =   self.startingNumber
        let firstPoint = "\(betterStart)/\(numberPreviousToStart)"
        stringPointRepresentation.append(firstPoint)
        let firstPair = Pair(x: betterStart , y: numberPreviousToStart)
        aproximationExpressions.append(firstPair)
        
        for var Index = 1 ; Index < self.currentCount ; Index++ {
            
            let thisNumber  = self.numbers[Index]
            let previousNumber = self.numbers[Index - 1]
            
            let newPoint = "\(thisNumber)/\(previousNumber)"
            let newPair = Pair(x: thisNumber , y: previousNumber)
            
            stringPointRepresentation.append(newPoint)
            aproximationExpressions.append(newPair)
        }
    }
    
    
    //this function is just to add a bunch more terms to the array
    private func propogateTerms(numberOfTernsMore: Int) {
        
        var previousToStartingNumber : Int = 0
        
        
        if ( !(numbers.count >= 2) ) {
            
            println("propogation called incorrectly")
            exit(3)
        }
        
        
        var previousNumberIndex = numbers.count - 1
        
        for var Index : Int = 0 ; Index < numberOfTernsMore ; Index++ {
            
            let twoBeforeIndex = previousNumberIndex - 1
            
            let newTermToAdd = numbers[previousNumberIndex] + numbers[twoBeforeIndex]
            
            numbers.append(newTermToAdd)
            
            previousNumberIndex++
            
        }
        
    }
    
    
    override init () {
    
        smallNumberFormatter = NSNumberFormatter()
        smallNumberFormatter.numberStyle = NSNumberFormatterStyle.ScientificStyle
        smallNumberFormatter.maximumSignificantDigits = 8
    }
    
    
}



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
            let answer = orderReverseDivision(divided, divideBy)//CGFloat(divided)/CGFloat(divideBy)
            
            
            let subjtracted : CGFloat = Ordering.sharedOrdering().rawValue - answer
            let ultimate = abs(subjtracted)
            
            if (ultimate < 0.000_1) {
                return smallNumberFormatter.stringFromNumber(ultimate)
            }
            
            return ultimate
        }
        
        return "Error. Contact Developer"
    }
    
}

