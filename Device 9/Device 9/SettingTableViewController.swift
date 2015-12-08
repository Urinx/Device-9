//
//  SettingTableViewController.swift
//  Device 9
//
//  Created by Eular on 9/21/15.
//  Copyright © 2015 Eular. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headerView = UIView()
        let close = UIButton()
        let img = UIImageView()
        headerView.frame = CGRectMake(0, 0, view.bounds.width, 100)
        
        close.frame = CGRectMake(20, 30, 40, 40)
        close.setImage(UIImage(named: "close-100"), forState: .Normal)
        close.addTarget(self, action: "close", forControlEvents: .TouchUpInside)
        headerView.addSubview(close)
        
        img.frame = CGRectMake(self.view.bounds.width/2 - 20, 30, 40, 40)
        img.image = UIImage(named: "settings-100")
        headerView.addSubview(img)
        
        tableView.tableHeaderView = headerView
    }
    
    func close() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 2 {
            var todo = ""
            if indexPath.row == 0 {
                todo = "mailto://\(AuthorEmail)"
            } else if indexPath.row == 1 {
                todo = "sms://\(AuthorMobile)"
            }
            UIApplication.sharedApplication().openURL(NSURL(string: todo)!)
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}
