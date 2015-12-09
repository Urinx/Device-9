//
//  ViewController.swift
//  Device 9
//
//  Created by Eular on 9/17/15.
//  Copyright © 2015 Eular. All rights reserved.
//

import UIKit
import WatchConnectivity
import Device9Kit

class MainViewController: UIViewController {
    
    @IBOutlet weak var chart: Chart!
    @IBOutlet weak var shareFBtn: UIButton!
    @IBOutlet weak var shareCBtn: UIButton!
    @IBOutlet weak var dataLB: UILabel!
    let defaults = NSUserDefaults(suiteName: UserDefaultSuiteName)!
    let device9 = Device9()
    var totalStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // chart
        let series1 = ChartSeries(random(10, 60, arrLen: 7))
        series1.color = ChartColors.cyanColor()
        series1.area = true
        
        let series2 = ChartSeries(random(1, 10, arrLen: 7))
        series2.color = ChartColors.redColor()
        series2.area = true
        
        chart.addSeries([series1, series2])
        
        shareFBtn.layer.borderColor = UIColor.whiteColor().CGColor
        shareFBtn.layer.borderWidth = 1.0
        shareFBtn.addTarget(self, action: "shareF", forControlEvents: .TouchUpInside)
        shareCBtn.layer.borderColor = UIColor.whiteColor().CGColor
        shareCBtn.layer.borderWidth = 1.0
        shareCBtn.addTarget(self, action: "shareC", forControlEvents: .TouchUpInside)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"shortcutItem1:", name: ShareFriendNotif, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"shortcutItem2:", name: ShareTimelineNotif, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"shortcutItem3:", name: SettingNotif, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        // show helper
        // why not put this in viewDidLoad? Because the HelpViewController can't be instanted in viewDidLoad
        if !defaults.boolForKey("firstBlood") {
            if let helpVC = storyboard?.instantiateViewControllerWithIdentifier("HelpViewController") as? HelpViewController {
                self.presentViewController(helpVC, animated: true, completion: nil)
            }
            defaults.setBool(true, forKey: "firstBlood")
            defaults.synchronize()
            
            // set initial data
            device9.dataFlow.cellularUsed = device9.dataFlow.upGPRS + device9.dataFlow.downGPRS
            device9.dataFlow.wifiUsed = device9.dataFlow.upWiFi + device9.dataFlow.downWiFi
        }
        
        updateUI()
    }
    
    func updateUI() {
        let cellularUsed = defaults.doubleForKey("CellularUsed")
        let wifiUsed = defaults.doubleForKey("WiFiUsed")
        let total = cellularUsed + wifiUsed
        if total.GB > 1 {
            totalStr = "\(total.GB.afterPoint(1)) GB"
        } else {
            totalStr = "\(Int(total.MB)) MB"
        }
        dataLB.text = totalStr
        
        // send data to apple watch
        do {
            let cellularLeft = defaults.doubleForKey("CellularTotal") - cellularUsed
            try WCSession.defaultSession().updateApplicationContext(["msg": "data", "cellularUsed": "\(cellularUsed.MB.afterPoint(1)) MB", "cellularLeft": "\(cellularLeft.MB.afterPoint(1)) MB", "wifiUsed": wifiUsed.GB > 1 ? "\(wifiUsed.GB.afterPoint(1)) GB":"\(Int(wifiUsed.MB)) MB"])
        } catch {}
    }
    
    func random(a: UInt32, _ b: UInt32) -> Float? {
        guard a < b else { return nil }
        return Float(arc4random_uniform(b - a) + a)
    }
    
    func random(a: UInt32, _ b: UInt32, arrLen: Int) -> Array<Float> {
        guard a < b else { return [] }
        var arr = [Float]()
        for _ in 0..<arrLen {
            arr.append(random(a, b)!)
        }
        return arr
    }
    
    // btn event
    func shareF() {
        weixinShare(WXSceneSession)
    }
    
    func shareC() {
        weixinShare(WXSceneTimeline)
    }
    
    func weixinShare(scene: WXScene) {
        if WXApi.isWXAppInstalled() {
            let message =  WXMediaMessage()
            message.title = "今生我消耗了\(totalStr)的流量，不服來戰！"
            message.description = WXShareDescription
            message.setThumbImage(UIImage(named: "d9"))
            let ext =  WXWebpageObject()
            ext.webpageUrl = AppDownload
            message.mediaObject = ext
            let req =  SendMessageToWXReq()
            req.bText = false
            req.message = message
            req.scene = Int32(scene.rawValue)
            WXApi.sendReq(req)
        } else {
            let alert = UIAlertController(title: "Share Fail", message: "Wechat app is not installed!", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // short cut
    func shortcutItem1(notification: NSNotification) {
        weixinShare(WXSceneSession)
    }
    
    func shortcutItem2(notification: NSNotification) {
        weixinShare(WXSceneTimeline)
    }
    
    func shortcutItem3(notification: NSNotification) {
        self.performSegueWithIdentifier("settingSegue", sender: self)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}

