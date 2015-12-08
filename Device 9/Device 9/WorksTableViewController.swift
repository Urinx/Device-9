//
//  WorksTableViewController.swift
//  Device 9
//
//  Created by Eular on 9/21/15.
//  Copyright © 2015 Eular. All rights reserved.
//

import UIKit

class WorksTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headerView = UIView()
        let back = UIButton()
        let title = UILabel()
        headerView.frame = CGRectMake(0, 0, view.bounds.width, 100)
        
        back.frame = CGRectMake(20, 35, 30, 30)
        back.setImage(UIImage(named: "back-100"), forState: .Normal)
        back.addTarget(self, action: "back", forControlEvents: .TouchUpInside)
        headerView.addSubview(back)
        
        title.frame = CGRectMake(self.view.bounds.width/2 - 60, 30, 120, 40)
        title.text = "Our Apps"
        title.font = UIFont(name: title.font.familyName, size: 25)
        title.textAlignment = .Center
        headerView.addSubview(title)
        
        tableView.tableHeaderView = headerView
    }
    
    func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var url = ""
        switch indexPath.row {
        case 0:
            url = "http://urinx.github.io/app/writetyper"
        case 1:
            url = "https://github.com/Urinx/Iconista/blob/master/README.md"
        case 2:
            url = "http://pre.im/1820"
        case 3:
            url = "http://pre.im/40fb"
        default:
            break
        }
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
