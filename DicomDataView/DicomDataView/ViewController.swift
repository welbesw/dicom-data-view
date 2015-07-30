//
//  ViewController.swift
//  DicomDataView
//
//  Created by William Welbes on 7/23/15.
//  Copyright (c) 2015 Technomagination, LLC. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    var dicomElements: [String] = ["Item 1", "Item 2"]
    
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
        if let dcmObject = DCMObject(contentsOfFile: filePath, decodingPixelData: false) {
            
            let attributeKeys = dcmObject.attributes.allKeys.sorted({ (key1, key2) -> Bool in
                (key1 as! String) < (key2 as! String)
            })
            
            for attributeKey in attributeKeys  {
                if let dcmAttributeKey = attributeKey as? String {
                    //println("Attribute: \(dcmAttributeKey)")
                    
                    if let attribute = dcmObject.attributes[dcmAttributeKey] as? DCMAttribute {
                        println(attribute.readableDescription())
                    }
                }
            }
        }
    }

    // MARK : NSTableViewDataSource
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return self.dicomElements.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let string = self.dicomElements[row]
        
        let cell = tableView.makeViewWithIdentifier("tagCell", owner: self) as! NSTableCellView
        cell.textField!.stringValue = string
        
        return cell
    }

}

