//
//  AppDelegate.swift
//  FibiPHI
//
//  Created by Shadow on 2/16/2015AD.
//  Copyright (c) 2015 Obsidian Design. All rights reserved.
//

import Cocoa
import AppKit


///The app delegeate. Initialized on launch
var DasSharedDelegate : AppDelegate? = nil


/**
 The applications delegate. Handles program lifetime notifications. This application adopts a simple
 structure, so the delegate also manages the window and owns most other objects (directly or indirectly)
 in the application.
*/
@NSApplicationMain class AppDelegate: NSObject, NSApplicationDelegate  {

    
    
    ///The application's window.
    @IBOutlet weak var window: NSWindow!

    ///Shows the user wether they are using PHI or its reciprocal
    @IBOutlet weak var phiValueText: NSTextField!
    
    ///the menu item to click to switch between PHI and its repciprocal
    @IBOutlet weak var PHIreciprocalMenuItem: NSMenuItem!
    
    ///the custom view graphing the fibonnacci sequence
    @IBOutlet weak var fibGraphingView: DASFibGraphView!

    ///where you enter the starting number b of the sequence
    @IBOutlet weak var startingNumberField: NSTextField!
    
    ///one of the ways to change the graph scale
    @IBOutlet weak var ScaleSlider: NSSlider!
    
    ///shows with numbers how we are getting closer to PHI
    @IBOutlet weak var resiudalTableView: NSTableView!
    
    
    ///what happens when the user clicks on the menu item to switch between phi and its reciprocal
    @IBAction func wantsPHIreciprocal(sender: AnyObject) {
        
        print("reciprocation desired")
        Ordering.opp()
        
        self.phiValueText.stringValue = "PHI: \(Ordering.sharedOrdering().rawValue)"
        self.fibGraphingView.setNeedsDisplayInRect(fibGraphingView.bounds)
        self.resiudalTableView.reloadData()
    }
    
    
    /**
        Connected to the scale slider in the application.
        
        When the slider stops moving, the scale of the graph changes to that indicated by the slider.
    */
    @IBAction func takeScaleSliderDoubleValue(sender: AnyObject) {
        
        let newValue : CGFloat = CGFloat(ScaleSlider.doubleValue)
        fibGraphingView.changeScale(newValue)
    }
    
    
    /**
        Connected to the text field of the application.
        
        When the user types an integer into the text field and hits enter, the fibonacci sequence changes to 
        have that starting number and the graph and table view are redrawn to reflect this.
    */
    @IBAction func takeTextFieldStartingValue(sender: AnyObject) {
        
        let newValue = startingNumberField.integerValue
        fibGraphingView.changeFibbonaciStartB(newValue)
        self.resiudalTableView.reloadData()
    }
    
    
    ///Called on launch. Does some brief setup
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        DasSharedDelegate = self
        self.ScaleSlider.floatValue = 100.0
        self.resiudalTableView.setDataSource(self.fibGraphingView.fibonnaciNumbers)
    }

    ///Called on termination. Currently a blank implementation.
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    
    ///Where the user clicks to get my copyright information, when the program was written and things like that.
    @IBOutlet weak var aboutMenuItem: NSMenuItem!
    
    ///The code which makes the application show the copyright and such information when the "about" menu item is clicked
    @IBAction func aboutDocAction(sender: AnyObject) {
        
                let aboutOptions = ["Copyright" : "Copyright 2016 Guthrie Kuckes" , "Version" : "1.0.0" , "Credits" : NSAttributedString(string: "All code in is in Apple's swift language, and the program was originally written in 2015 for a school project") ]
                NSApplication.sharedApplication().orderFrontStandardAboutPanelWithOptions(aboutOptions)
    }
    
    
}


