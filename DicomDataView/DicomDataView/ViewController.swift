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
    
    @IBOutlet weak var tableView: NSTableView!
    
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
                
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func copy(sender:AnyObject?) -> Void {
        copySelectedRow()
    }
    
    func copySelectedRow() {
        if (self.tableView.selectedRow >= 0) {
            let selectedAttributeKey = self.dicomAttributeKeys[self.tableView.selectedRow]
            
            if let dicomObject = self.dicomObject {
                if let attribute = dicomObject.attributes[selectedAttributeKey] as? DCMAttribute {
                    let description = attribute.readableDescription()
                    let pasteBoard = NSPasteboard.generalPasteboard()
                    pasteBoard.clearContents()
                    pasteBoard.setString(description, forType: NSStringPboardType)
                }
            }
        }
     }

    // MARK : NSTableViewDataSource
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        
        return self.dicomAttributeKeys.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let attributeKey = self.dicomAttributeKeys[row]
        
        var cell: NSTableCellView? = nil
        
        if let dicomObject = self.dicomObject {
            if let attribute = dicomObject.attributes[attributeKey] as? DCMAttribute {
                //Determine which column this is
                if let column = tableColumn {
                
                    var stringValue = ""
                    cell = tableView.makeViewWithIdentifier("\(column.identifier)Cell", owner: self) as? NSTableCellView
                    
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

