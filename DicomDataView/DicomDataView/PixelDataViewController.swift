//
//  PixelDataViewController.swift
//  DicomDataView
//
//  Created by William Welbes on 4/6/16.
//  Copyright © 2016 Technomagination, LLC. All rights reserved.
//

import Cocoa

class PixelDataViewController: NSViewController {

    var dicomObject: DCMObject? = nil
    
    @IBOutlet var imageView:NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        loadDicomFile() //The document is not yet set in viewDidLoad
    }
    
    func loadDicomFile() {
        
        if let windowController = NSApplication.sharedApplication().mainWindow?.windowController {
            if let document = windowController.document as? Document {
                self.dicomObject = document.dicomObject
                
                loadPixelData()
            }
        }
    }
    
    func loadPixelData() {
        if let dcmObject = self.dicomObject {
            if let dcmPixelDataAttribute = dcmObject.attributes["7FE0,0010"] as? DCMPixelDataAttribute {
                if dcmPixelDataAttribute.numberOfFrames > 0 {
                    let frameData = dcmPixelDataAttribute.decodeFrameAtIndex(0)

                    if let image = NSImage(data: frameData) {
                        imageView.image = image;
                    }
                }
            }
        }
    }
    
}
