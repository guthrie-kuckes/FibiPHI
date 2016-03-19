//
//  DasFibonacciSequence.swift
//  FibiPHI
//
//  Created by Shadow on 2/16/2015AD.
//  Copyright (c) 2015 Obsidian Design. All rights reserved.
//


// TODO: make compatible with negative numbers







import Foundation //realize that ths is a pretty basic, abstract, class




///Absurd amount of digits of the golden ratio.
public let PHI : CGFloat = 0.6180339887498948482045868343656381177203091798057628621

///Just a global constant for the golden ratio plus one. Used to be able to talk about the golde ratio and its reciprocal
public let PHI_P1 : CGFloat = 1.6180339887498948482045868343656381177203091798057628621



/**
This works in conjunction with FibGraphView, which divideds numbers in the fibonacci
sequence by each other to show that they ever approach PHI

This can be represented graphically with one number in the sequecnce as x and another as y, so
storing numbers in the sequence like this is a nice precursor to that
*/
internal typealias Pair = (x: Double , y: Double)








/**
 Represents the fibonnaci sequence. Originally menant to be graphed.
*/
public class DASFibbonaciSequence : NSObject {
    
    
    ///number for the sequence to start with. there is a function to call to change this.
    private (set) var startingNumber : Double = 1.0
    
    
    ///numbers in the sequence
    public private (set) var numbers = [Double]()
    
    
    /**
        A constant to note that the class does not yet support negative terms. As well, note that the Fibonnacci sequence
        is determined by two numbers. Usually, this is one and zero. In the current version of the application, the user
        can change the starting "1" to any natural number. But the application does not yet support changing the "0", 
        which is what this constant represents. 
    */
    let previousToStartingNumber : Double = 0

    
    
    /**
        reflects the idea that in a fibonnaci sequence, as you go further and further along, a number in the fibonacci sequence divided
        by the previous number gets increasingly close to the golden ratio. 
    
        so the array contains pairs which represent two numbers which divided approach the golden ratio, this for all numbers in the sequence
    */
    private (set) var aproximationExpressions = [Pair]()

    
    /**
        contains essentially a textual representatio of every Pair in aproximationExpressions, in the form number/previous number
    */
    private (set) var stringPointRepresentation = [String]()
    
    
    
    
    
    ///the number of numbers we have in the sequence currently
    var currentCount : Int {
        get {
            
            return numbers.count
        }
    }
    
    
    ///a convenience initializer which immediatly calls realizeNumberOfTerms, to make sure it is filled out
    public convenience init(computedTerms: Int) {
        
        self.init()
        self.realizeNumberOfTerms(computedTerms)
    }
    

    /**
        extends the sequence by numberOfTermsMore terms. this only for numbers, does not touch the string or pairs arrays
        because of this, it is only to be used by being called by realizeNumberOfTerms, which will take care of these things
        - as well it can not handle the first few terms in the sequence, a reason why you use realizeNumberOfTerms
    */
    private func propogateTerms(numberOfTernsMore: Int) {
        
        
        //without implementing negative terms, the first two terms are special, always being 0 and then the starting number
        assert(self.currentCount > 1, "DasFibonacciSequence.propogateTerms called incorrectly")
        
        
        
        var previousNumberIndex = numbers.count - 1 //ie the index of the last member of the array
        
        
        for var Index : Int = 0 ; Index < numberOfTernsMore ; Index++ {
            
            
            let twoBeforeIndex = previousNumberIndex - 1 //the index of the second to last member of the array
            
            
            let newTermToAdd = numbers[previousNumberIndex] + numbers[twoBeforeIndex] //calculates the next term using previous term + term before that
            numbers.append(newTermToAdd)
            
            previousNumberIndex++
        }
        
    }

    
    /**
        capable of changing the starting number of the sequence
        will make sure that the numbers array gets replaced to reflect the new reality, and will be replaced to its old length
        the stringPointRepresentation and aproximation expressions array will also be replaced
    */
    func changeStartingNumber(newStart: Int) {
        
        let realNewStart = Double(newStart)
        if (realNewStart == self.startingNumber) { //do nothing if the new number is the same as what we have already acounted for. (recomputing is a rather expensive operation)
            return
        }
        
        
        let count = currentCount
        self.numbers.removeAll(keepCapacity: true)
        
        self.startingNumber = realNewStart
        realizeNumberOfTerms(count) //will take care of the Pair and String arrays
    }
    
    
    
    
    /**
        takes a number of terms that numbers array should have
        numbers array will have at least terms number of terms after calling it
        will also make sure that the aproximation expressions array and stringPointRepresentation arrays contain what they should for the new numbers array
    */
    public func realizeNumberOfTerms(terms: Int) {
        
        if (self.numbers.count >= terms) { //do nothing if this is already true
            
            return
        } else if (terms == 0) { //do nothing if we have been told to do nothing
            return
        }
        

        
        if (numbers.count < 2) {
            
            if (numbers.isEmpty) {
                
                let firstTerm : Double = startingNumber
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
        
        
        let firstPoint = "\(startingNumber)/\(previousToStartingNumber)"
        stringPointRepresentation.append(firstPoint)
        let firstPair = Pair(x: startingNumber , y: previousToStartingNumber)
        aproximationExpressions.append(firstPair)
        
        for var Index = 1 ; Index < self.currentCount ; Index++ {
            
            let thisNumber  = self.numbers[Index]
            let previousNumber = self.numbers[Index - 1]
            
            let newPoint = "\(thisNumber)/\(previousNumber)"
            let newPair = Pair(x: thisNumber , y: previousNumber)
            
            stringPointRepresentation.append(newPoint)
            aproximationExpressions.append(newPair)
        }
        
        //print("terms are \(self.numbers)")
    }
    
}
