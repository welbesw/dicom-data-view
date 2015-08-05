//
//  Document.swift
//  DicomDataView
//
//  Created by William Welbes on 7/31/15.
//  Copyright (c) 2015 Technomagination, LLC. All rights reserved.
//

import Cocoa

class Document: NSDocument {

    var dicomObject: DCMObject? = nil
    
    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override func windowControllerDidLoadNib(aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
        // Add any code here that needs to be executed once the windowController has loaded the document's window.
    }

    override class func autosavesInPlace() -> Bool {
        return false
    }

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)!
        let windowController = storyboard.instantiateControllerWithIdentifier("Document Window Controller") as! NSWindowController
        self.addWindowController(windowController)
    }

    override func dataOfType(typeName: String, error outError: NSErrorPointer) -> NSData? {
        // Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
        // You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
        outError.memory = NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        return nil
    }

    override func readFromData(data: NSData, ofType typeName: String, error outError: NSErrorPointer) -> Bool {
        // Insert code here to read your document from the given data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning false.
        // You can also choose to override readFromFileWrapper:ofType:error: or readFromURL:ofType:error: instead.
        // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
        
        var success = false
        
        if (!DCMObject.isDICOM(data)) {
            //Set the error and return
            let userInfo = [NSLocalizedDescriptionKey : "File is not DICOM data.", NSLocalizedFailureReasonErrorKey : "File is not DICOM data."]
            
            outError.memory = NSError(domain: Constants.errorDomain, code: ErrorCodes.FileLoadFailed.rawValue, userInfo: userInfo)
        } else {
        
            if let dicomObject = DCMObject(data: data, decodingPixelData: true) {
                
                self.dicomObject = dicomObject
                
                println("Loaded dicom file")
                
                success = true
                
            } else {
                let userInfo = [NSLocalizedDescriptionKey : "File could not be loaded.", NSLocalizedFailureReasonErrorKey : "File could not be loaded."]
                outError.memory = NSError(domain: Constants.errorDomain, code: ErrorCodes.FileLoadFailed.rawValue, userInfo: userInfo)
            }
        }
        
        return success
    }


}

