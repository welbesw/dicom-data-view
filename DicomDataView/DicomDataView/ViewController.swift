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
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
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

