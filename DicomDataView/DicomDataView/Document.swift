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
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateControllerWithIdentifier("Document Window Controller") as! NSWindowController
        self.addWindowController(windowController)
    }
    
    /*
    override func dataOfType(typeName: String) throws -> NSData {
        //Doduments not being written
    }
    */

    override func readFromData(data: NSData, ofType typeName: String) throws {
        // Insert code here to read your document from the given data of the specified type.
        
        if (!DCMObject.isDICOM(data)) {
            //Set the error and return
            let userInfo = [NSLocalizedDescriptionKey : "File is not DICOM data.", NSLocalizedFailureReasonErrorKey : "File is not DICOM data."]
            
            throw NSError(domain: Constants.errorDomain, code: ErrorCodes.FileLoadFailed.rawValue, userInfo: userInfo)
        } else {
            
            if let dicomObject = DCMObject(data: data, decodingPixelData: true) {
                
                self.dicomObject = dicomObject
                
                print("Loaded dicom file")
                
            } else {
                let userInfo = [NSLocalizedDescriptionKey : "File could not be loaded.", NSLocalizedFailureReasonErrorKey : "File could not be loaded."]
                throw NSError(domain: Constants.errorDomain, code: ErrorCodes.FileLoadFailed.rawValue, userInfo: userInfo)
            }
        }
        
        return
    }

}

