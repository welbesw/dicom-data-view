//
//  OutlineViewController.swift
//  DicomDataView
//
//  Created by William Welbes on 8/13/15.
//  Copyright (c) 2015 Technomagination, LLC. All rights reserved.
//

import Cocoa

class OutlineViewController: NSViewController, NSOutlineViewDataSource, NSOutlineViewDelegate {

    var dicomAttributeKeys: [String] = []
    
    var dicomObject: DCMObject? = nil
    
    @IBOutlet weak var outlineView: NSOutlineView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        loadDicomFile() //The document is not yet set in viewDidLoad
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
            println("representedObject called")
        }
    }
    
    func loadDicomFile() {
        if let windowController = self.view.window?.windowController() as? NSWindowController {
            if let document = windowController.document as? Document {
                self.dicomObject = document.dicomObject
                
                let attributesOfInterest = (self.dicomObject!.attributes.allKeys as! Array<String>).filter { $0 != "0000,0000" }
                
                self.dicomAttributeKeys = attributesOfInterest.sorted({ (key1, key2) -> Bool in
                    (key1 as String) < (key2 as String)
                }) as [String]
                
                self.outlineView.reloadData()
            }
        }
    }
    
    // MARK : NSOutlineViewDataSource
    
    func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        return item == nil ? dicomAttributeKeys.count : 0
    }
    
    func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        
        return item == nil ? self.dicomAttributeKeys[index] : ""
    }
    
    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
        return false
    }
    
    func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
        let attributeKey = item as! String
        
        var cell: NSTableCellView? = nil
        
        if let dicomObject = self.dicomObject {
            if let attribute = dicomObject.attributes[attributeKey] as? DCMAttribute {
                //Determine which column this is
                if let column = tableColumn {
                    
                    var stringValue = ""
                    cell = outlineView.makeViewWithIdentifier("\(column.identifier)Cell", owner: self) as? NSTableCellView
                    
                    if(cell != nil) {
                        switch(column.identifier) {
                        case "tag":
                            
                            //let groupString = String(attribute.group, radix:16, uppercase:true)
                            let groupString = String(format: "%04X", arguments: [attribute.group])
                            let elementString = String(format: "%04X", arguments: [attribute.element])
                            
                            stringValue = "(\(groupString),\(elementString))"
                            
                        case "size":
                            stringValue = attribute.vr == "SQ" ? "" : String(attribute.valueLength)
                            
                        case "vr":
                            stringValue = attribute.vr
                            
                        case "name":
                            stringValue = attribute.attrTag.name
                            
                        case "data":
                            stringValue = attribute.valuesAsReadableString()
                            
                        default:
                            cell!.textField!.stringValue = ""
                        }
                        
                        cell!.textField!.stringValue = stringValue
                    }
                }
            }
        }
        
        return cell
    }
    
}
