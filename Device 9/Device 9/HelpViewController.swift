//
//  HelpViewController.swift
//  Device 9
//
//  Created by Eular on 9/21/15.
//  Copyright © 2015 Eular. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

    @IBOutlet weak var tryBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tryBtn.layer.borderColor = UIColor.whiteColor().CGColor
        tryBtn.layer.borderWidth = 1.0
        tryBtn.layer.cornerRadius = 6.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(sender: AnyObject) {
        if navigationController != nil {
            navigationController?.popViewControllerAnimated(true)
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
