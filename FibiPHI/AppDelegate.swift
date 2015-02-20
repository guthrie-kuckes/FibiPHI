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

    @IBOutlet weak var fibGraphingView: fibGraphView!

    @IBOutlet weak var startingNumberField: NSTextField!
    
    @IBOutlet weak var ScaleSlider: NSSlider!
    
    
    @IBOutlet weak var resiudalTableView: NSTableView!
    
    
    @IBAction func takeScaleSliderIntValue(sender: AnyObject) {
        
        let newValue = ScaleSlider.floatValue
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

    
    
    
}


