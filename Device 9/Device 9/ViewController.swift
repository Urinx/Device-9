//
//  ViewController.swift
//  Device 9
//
//  Created by Eular on 9/17/15.
//  Copyright © 2015 Eular. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var chart: Chart!
    @IBOutlet weak var shareFBtn: UIButton!
    @IBOutlet weak var shareCBtn: UIButton!

    @IBOutlet weak var dataLB: UILabel!
    let defaults = NSUserDefaults(suiteName: "group.device9SharedDefaults")!
    let deviceData = DeviceData()
    var totalStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var cellularUsed: Double = 0
        var wifiUsed: Double = 0
        
        if !defaults.boolForKey("firstBlood") {
            cellularUsed = deviceData.dataFlow.upGPRS + deviceData.dataFlow.downGPRS
            wifiUsed = deviceData.dataFlow.upWiFi + deviceData.dataFlow.downWiFi
            deviceData.dataFlow.cellularUsed = cellularUsed
            deviceData.dataFlow.wifiUsed = wifiUsed
        } else {
            cellularUsed = defaults.doubleForKey("CellularUsed")
            wifiUsed = defaults.doubleForKey("WiFiUsed")
        }
        let total = cellularUsed + wifiUsed
        if total.GB > 1 {
            totalStr = "\(total.GB.afterPoint(1)) GB"
        } else {
            totalStr = "\(Int(total.MB)) MB"
        }
        dataLB.text = totalStr
        
        shareFBtn.layer.borderColor = UIColor.whiteColor().CGColor
        shareFBtn.layer.borderWidth = 1.0
        shareFBtn.addTarget(self, action: "shareF", forControlEvents: .TouchUpInside)
        shareCBtn.layer.borderColor = UIColor.whiteColor().CGColor
        shareCBtn.layer.borderWidth = 1.0
        shareCBtn.addTarget(self, action: "shareC", forControlEvents: .TouchUpInside)
        
        // chart
        let series1 = ChartSeries([10,32,43,54,14,43,54])
        series1.color = ChartColors.cyanColor()
        series1.area = true
        
        let series2 = ChartSeries([4.5,2.3,3.4,5.4,1.4,4.3,2.3])
        series2.color = ChartColors.redColor()
        series2.area = true
        
        chart.addSeries([series1, series2])
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"shortcutItem1:", name: "shareToFriend", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"shortcutItem2:", name: "shareToTimeline", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"shortcutItem3:", name: "setting", object: nil)
        
    }
    
    func shareF() {
        weixinShare(WXSceneSession)
    }
    
    func shareC() {
        weixinShare(WXSceneTimeline)
    }
    
    func weixinShare(scene: WXScene) {
        let message =  WXMediaMessage()
        message.title = "今生我消耗了\(totalStr)的流量，不服來戰！"
        message.description = "超用心的誠意之作，讓通知中心變得從來沒有這麼好用"
        message.setThumbImage(UIImage(named: "d9"))
        let ext =  WXWebpageObject()
        ext.webpageUrl = AppDownload
        message.mediaObject = ext
        let req =  SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = Int32(scene.rawValue)
        WXApi.sendReq(req)
    }
    
    override func viewDidAppear(animated: Bool) {
        if !defaults.boolForKey("firstBlood") {
            if let helpVC = storyboard?.instantiateViewControllerWithIdentifier("HelpViewController") as? HelpViewController {
                self.presentViewController(helpVC, animated: true, completion: nil)
            }
            defaults.setBool(true, forKey: "firstBlood")
            defaults.synchronize()
        }
    }
    
    func shortcutItem1(notification: NSNotification) {
        shareF()
    }
    
    func shortcutItem2(notification: NSNotification) {
        shareC()
    }
    
    func shortcutItem3(notification: NSNotification) {
        self.performSegueWithIdentifier("settingSegue", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}
