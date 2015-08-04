//
//  AppDelegate.swift
//  DicomDataView
//
//  Created by William Welbes on 7/23/15.
//  Copyright (c) 2015 Technomagination, LLC. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var isFirstLanuch: Bool = true

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    func applicationDidBecomeActive(notification: NSNotification) {
        //Handle the app becoming active again
        println("applicationDidBecomeActive")
        
        if(isFirstLanuch) {
            self.isFirstLanuch = false
            showOpenDialog()
            
        }
    }
    
    func applicationShouldHandleReopen(sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        println("applicationShouldHandleReopen")
        
        if (!flag) {    //There are no visible windows - show the open panel
            showOpenDialog()
        }
        
        return true
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return false
    }
    
    func showOpenDialog() {
        let documentController = NSDocumentController.sharedDocumentController() as! NSDocumentController
        if (documentController.documents.count == 0) {
            //prompt the user to open a document
            documentController.openDocument(self)
        }
    }

}

