//
//  TodayViewController.swift
//  Device 9 TodayExtension2
//
//  Created by Eular on 12/8/15.
//  Copyright © 2015 Eular. All rights reserved.
//

import UIKit
import NotificationCenter
import Device9Kit

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var ssidLB: UILabel!
    @IBOutlet weak var bssidLB: UILabel!
    @IBOutlet weak var ipLB: UILabel!
    
    let device9 = Device9()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 调整Widget的高度
        self.preferredContentSize = CGSizeMake(0, 76)
        
        update()
    }
    
    // 取消widget默认的inset，让应用靠左
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    func update() {
        if device9.network == .None {
            ipLB.text = "无网络连接"
        } else {
            ipLB.text = "\(device9.ip!)"
        }
        
        // BSSID & SSID
        bssidLB.text = "\(device9.BSSID)"
        ssidLB.text = "\(device9.SSID)"
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.NewData)
    }
}
