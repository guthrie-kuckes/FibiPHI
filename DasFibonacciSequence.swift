//
//  DasFibonacciSequence.swift
//  FibiPHI
//
//  Created by Shadow on 2/16/2015AD.
//  Copyright (c) 2015 Obsidian Design. All rights reserved.
//




import Foundation //realize that ths is a pretty basic, abstract, class






//absurd amount of digits of the golden ratio. some of these, of course, will be chopped
public let PHI : CGFloat = 0.6180339887498948482045868343656381177203091798057628621

//just global contant for golden ratio plus one since my table is fudged and I need this to get residual
let PHI_P1 : CGFloat = 1.6180339887498948482045868343656381177203091798057628621


internal typealias Pair = (x: Int , y: Int)






class DasFibbonaciSequence : NSObject {
    
    
    //number for the sequence to start with. there is a function to call to change this
    private (set) var startingNumber : Int = 1
    
    
    //numbers in the sequence
    private (set) var numbers = [Int]()
    
    
    /*
        reflects the idea that in a fibonnaci sequence, as you go further and further along, a number in the fibonacci sequence divided
        by the previous number gets increasingly close to the golden ratio. 
    
        so the array contains pairs which represent two numbers which divided approach the golden ratio, this for all numbers in the sequence
    */
    private (set) var aproximationExpressions = [Pair]()

    
    /*
        contains essentially a textual representatio of every Pair in aproximationExpressions, in the form number/previous number
    */
    private (set) var stringPointRepresentation = [String]()
    
    
    var smallNumberFormatter : NSNumberFormatter
    
    
    
    //the number of numbers we have in the sequence currently
    var currentCount : Int {
        get {
            
            return numbers.count
        }
    }
    
    
    //the initialization function. note that the only thing initialized is the number formatter used
    override init () {
        
        smallNumberFormatter = NSNumberFormatter()
        smallNumberFormatter.numberStyle = NSNumberFormatterStyle.ScientificStyle
        smallNumberFormatter.maximumSignificantDigits = 8
    }
    

    /* 
        extends the sequence by numberOfTermsMore terms. this only for numbers, does not touch the string or pairs arrays
        because of this, it is only to be used by being called by realizeNumberOfTerms, which will take care of these things
        - as well it can not handle the first few terms in the sequence, a reason why you use realizeNumberOfTerms
    */
    private func propogateTerms(numberOfTernsMore: Int) {
        
        
        if ( !(numbers.count >= 2) ) {
            
            print("propogation called incorrectly")
            exit(3)
        }
        
        
        var previousNumberIndex = numbers.count - 1 //ie the index of the last member of the array
        
        for var Index : Int = 0 ; Index < numberOfTernsMore ; Index++ {
            
            let twoBeforeIndex = previousNumberIndex - 1
            
            let newTermToAdd = numbers[previousNumberIndex] + numbers[twoBeforeIndex]
            
            numbers.append(newTermToAdd)
            
            previousNumberIndex++
            
        }
        
    }

    
    /*
        capable of changing the starting number of the sequence
        will make sure that the numbers array gets replaced to reflect the new reality, and will be replaced to its old length
        the stringPointRepresentation and aproximation expressions array will also be replaced
    */
    func changeStartingNumber(newStart: Int) {
        
        if (newStart == self.startingNumber) { //do nothing if the new number is the same as what we have already acounted for. (recomputing is a rather expensive operation)
            return
        }
        
        let count = currentCount
        self.numbers.removeAll(keepCapacity: true)
        
        self.startingNumber = newStart
        realizeNumberOfTerms(count)
    }
    
    
    
    
    /*
        takes a number of terms that numbers array should have
        numbers array will have at least terms number of terms after calling it
        will also make sure that the aproximation expressions array and stringPointRepresentation arrays contain what they should for the new numbers array
    */
    func realizeNumberOfTerms(terms: Int) {
        
        if (self.numbers.count >= terms) { //do nothing if this is already true
            
            return
        } else if (terms == 0) { //do nothing if we have been told to do nothing
            return
        }
        
        
        let previousToStartingNumber : Int = 0
        
        
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
    
}
