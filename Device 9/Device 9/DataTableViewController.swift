//
//  DataTableViewController.swift
//  Device 9
//
//  Created by Eular on 9/21/15.
//  Copyright © 2015 Eular. All rights reserved.
//

import UIKit

class DataTableViewController: UITableViewController {

    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var totalTF: UITextField!
    @IBOutlet weak var usedTF: UITextField!
    
    let defaults = NSUserDefaults(suiteName: UserDefaultSuiteName)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headerView = UIView()
        let back = UIButton()
        let img = UIImageView()
        headerView.frame = CGRectMake(0, 0, view.bounds.width, 100)
        
        back.frame = CGRectMake(20, 35, 30, 30)
        back.setImage(UIImage(named: "back-100"), forState: .Normal)
        back.addTarget(self, action: "back", forControlEvents: .TouchUpInside)
        headerView.addSubview(back)
        
        img.frame = CGRectMake(self.view.bounds.width/2 - 20, 30, 40, 40)
        img.image = UIImage(named: "rfid_signal-96")
        headerView.addSubview(img)
        
        tableView.tableHeaderView = headerView
        
        update()
    }
    
    func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func update() {
        let cellularTotal = defaults.doubleForKey("CellularTotal")
        let cellularUsed = defaults.doubleForKey("CellularUsed")
        totalTF.placeholder = "\(Int(cellularTotal.MB))"
        usedTF.placeholder = "\(cellularUsed.MB.afterPoint(1))"
    }

    @IBAction func reset(sender: AnyObject) {
        defaults.setDouble(0, forKey: "CellularTotal")
        defaults.setDouble(0, forKey: "CellularUsed")
        defaults.synchronize()
        update()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if !totalTF.text!.isEmpty {
            defaults.setDouble(Double(totalTF.text!)! * 1024 * 1024, forKey: "CellularTotal")
        }
        
        if !usedTF.text!.isEmpty {
            defaults.setDouble(Double(usedTF.text!)! * 1024 * 1024, forKey: "CellularUsed")
        }
        defaults.synchronize()
        
        dateTF.resignFirstResponder()
        totalTF.resignFirstResponder()
        usedTF.resignFirstResponder()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
