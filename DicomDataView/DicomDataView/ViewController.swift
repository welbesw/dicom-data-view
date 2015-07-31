//
//  ViewController.swift
//  DicomDataView
//
//  Created by William Welbes on 7/23/15.
//  Copyright (c) 2015 Technomagination, LLC. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    var dicomAttributeKeys: [String] = []
    
    var dicomObject: DCMObject? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadDicomFile()
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func loadDicomFile() {
        let filePath = "/Users/will/Downloads/IDEFIX/unnamed/unnamed/IM-0001-30001.dcm"
        if let dicomObject = DCMObject(contentsOfFile: filePath, decodingPixelData: false) {
            
            self.dicomObject = dicomObject
            
            self.dicomAttributeKeys = dicomObject.attributes.allKeys.sorted({ (key1, key2) -> Bool in
                (key1 as! String) < (key2 as! String)
            }) as! [String]
            
            /*
            for attributeKey in self.dicomAttributeKeys  {
                    
                if let attribute = dicomObject.attributes[attributeKey] as? DCMAttribute {
                    println(attribute.readableDescription())
                }
            }
            */
        }
    }

    // MARK : NSTableViewDataSource
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        
        return self.dicomAttributeKeys.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let attributeKey = self.dicomAttributeKeys[row]
        
        let cell = tableView.makeViewWithIdentifier("tagCell", owner: self) as! NSTableCellView
        
        if let dicomObject = self.dicomObject {
            if let attribute = dicomObject.attributes[attributeKey] as? DCMAttribute {
                //Determine which column this is
                if let column = tableColumn {
                
                    var stringValue = ""
                    switch(column.identifier) {
                        case "tag":
                            let groupString = String(format: "%04d", arguments: [attribute.group])
                            let elementString = String(format: "%04d", arguments: [attribute.element])
                            
                            stringValue = "(\(groupString),\(elementString))"
                        
                        case "vr":
                            stringValue = attribute.vr
                        
                        case "name":
                            stringValue = attribute.attrTag.name
                        
                        default:
                            stringValue = ""
                    }
                    cell.textField!.stringValue = stringValue
                }
            }
        } else {
            cell.textField!.stringValue = ""
        }
        
        return cell
    }

}

