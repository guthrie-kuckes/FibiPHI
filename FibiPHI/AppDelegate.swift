//
//  AppDelegate.swift
//  FibiPHI
//
//  Created by Shadow on 2/16/2015AD.
//  Copyright (c) 2015 Obsidian Design. All rights reserved.
//

import Cocoa
import AppKit


var DasSharedDelegate : AppDelegate? = nil



@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate  {

    
    
    @IBOutlet weak var window: NSWindow!

    //shows us wether we are using PHI or its reciprocal
    @IBOutlet weak var phiValueText: NSTextField!
    
    //the menu item to click to switch between PHI and its repciprocal
    @IBOutlet weak var PHIreciprocalMenuItem: NSMenuItem!
    
    //the custom view graphing the fibonnacci sequence
    @IBOutlet weak var fibGraphingView: DASFibGraphView!

    //where you enter the starting number b of the sequence
    @IBOutlet weak var startingNumberField: NSTextField!
    
    //one of the ways to change the graph scale
    @IBOutlet weak var ScaleSlider: NSSlider!
    
    //shows with numbers how we are getting closer to PHI
    @IBOutlet weak var resiudalTableView: NSTableView!
    
    
    //what happens when you loick on the menu item to switch between phi and its reciprocal
    @IBAction func wantsPHIreciprocal(sender: AnyObject) {
        
        print("reciprocation desired")
        Ordering.opp()
        
        self.phiValueText.stringValue = "PHI: \(Ordering.sharedOrdering().rawValue)"
        self.fibGraphingView.setNeedsDisplayInRect(fibGraphingView.bounds)
        self.resiudalTableView.reloadData()
    }
    
    
    @IBAction func takeScaleSliderIntValue(sender: AnyObject) {
        
        let newValue : CGFloat = CGFloat(ScaleSlider.doubleValue)
        fibGraphingView.changeScale(newValue)
    }
    
    @IBAction func takeTextFieldStartingValue(sender: AnyObject) {
        
        let newValue = startingNumberField.integerValue
        fibGraphingView.changeFibbonaciStartB(newValue)
        self.resiudalTableView.reloadData()
    }
    
    
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        DasSharedDelegate = self
        self.ScaleSlider.floatValue = 100.0
        self.resiudalTableView.setDataSource(self.fibGraphingView.fibonnaciNumbers)
        
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    
    @IBOutlet weak var aboutMenuItem: NSMenuItem!
    
    
    @IBAction func aboutDocAction(sender: AnyObject) {
        
                let aboutOptions = ["Copyright" : "Copyright 2016 Guthrie Kuckes" , "Version" : "1.0.0" , "Credits" : NSAttributedString(string: "All code in is in Apple's swift language, and the program was originally written in 2015 for a school project") ]
                NSApplication.sharedApplication().orderFrontStandardAboutPanelWithOptions(aboutOptions)
    }
    
    
}


