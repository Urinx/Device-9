//
//  TodayViewController.swift
//  Device 9 TodayExtension
//
//  Created by Eular on 9/17/15.
//  Copyright © 2015 Eular. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var storageLB: UILabel!
    @IBOutlet weak var batteryLB: UILabel!
    @IBOutlet weak var batteryImg: UIImageView!
    @IBOutlet weak var usedDataLB: UILabel!
    @IBOutlet weak var leftDataLB: UILabel!
    @IBOutlet weak var wifiLB: UILabel!
    @IBOutlet weak var uploadLb: UILabel!
    @IBOutlet weak var downloadLB: UILabel!
    @IBOutlet weak var ipLB: UILabel!
    @IBOutlet weak var wanLB: UILabel!
    @IBOutlet weak var ipPositionLB: UILabel!
    @IBOutlet weak var bssidLB: UILabel!
    @IBOutlet weak var ssidLB: UILabel!
    @IBOutlet weak var phoneLB: UILabel!
    @IBOutlet weak var systemLB: UILabel!
    @IBOutlet weak var appLB: UILabel!
    @IBOutlet weak var uuidLB: UILabel!
    
    let deviceData = DeviceData()
    var timer: NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        // 调整Widget的高度
        self.preferredContentSize = CGSizeMake(0, 255)
        
        update()
        fresh()
    }
    
    override func viewWillAppear(animated: Bool) {
        if deviceData.network != .None {
            timer = NSTimer.scheduledTimerWithTimeInterval(deviceData.dataFlow.dt, target: self, selector: "fresh", userInfo: nil, repeats: true)
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        timer.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 取消widget默认的inset，让应用靠左
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NoData)
    }
    
    func update() {
        // 储存
        let storage = deviceData.systemFreeSize
        let battery = deviceData.batteryLevel
        if storage.GB < 1 {
            storageLB.text = "\(Int(storage.MB)) MB"
        } else if storage.GB > 10 {
            storageLB.text = "\(storage.GB.afterPoint(1)) GB"
        } else {
            storageLB.text = "\(storage.GB.afterPoint(2)) GB"
        }
        
        // 电量
        if battery > 0 {
            batteryLB.text = "\(Int(battery * 100)) %"
            
            switch deviceData.batteryState {
            case .Unknown:
                break
            case .Unplugged:
                switch battery {
                case 0.9...1:
                    batteryImg.image = UIImage(named: "fully_charged_battery")
                case 0.6..<0.9:
                    batteryImg.image = UIImage(named: "high_battery")
                case 0.3..<0.6:
                    batteryImg.image = UIImage(named: "medium_battery")
                case 0..<0.3:
                    batteryImg.image = UIImage(named: "low_battery")
                default:
                    break
                }
            case .Charging:
                batteryImg.image = UIImage(named: "charge_battery")
            case .Full:
                batteryImg.image = UIImage(named: "fully_charged_battery")
            }
        }
        
        if deviceData.network == .None {
            ipLB.text = "无网络连接"
        } else {
            ipLB.text = "\(deviceData.ip!)"
            if let wan = deviceData.wan {
                wanLB.text = wan["ip"]
                ipPositionLB.text = wan["pos"]
            }
        }
        
        // BSSID & SSID
        bssidLB.text = "\(deviceData.BSSID)"
        ssidLB.text = "\(deviceData.SSID)"
        
        // System Info
        phoneLB.text = "\(deviceData.name)"
        systemLB.text = "iOS \(deviceData.systemVersion)"
        appLB.text = "\(deviceData.appNum)"
        uuidLB.text = "\(deviceData.UUID)"
    }
    
    func fresh() {
        deviceData.dataFlow.update()
        let upSpeed = deviceData.dataFlow.upSpeed
        let downSpeed = deviceData.dataFlow.downSpeed
        
        // 流量数据
        let usedDataMB = deviceData.cellularUsedData.MB
        usedDataLB.text = "\(usedDataMB.afterPoint(1)) MB"
        leftDataLB.text = "\((deviceData.cellularTotalData.MB - usedDataMB).afterPoint(1)) MB"
            
        // WIFI数据
        let wifi = deviceData.wifiUsedData
        if wifi.GB > 1 {
            wifiLB.text = "\(wifi.GB.afterPoint(2)) GB"
        } else {
            wifiLB.text = "\(Int(wifi.MB)) MB"
        }
            
        // 网速
        if upSpeed.MB > 1 {
            uploadLb.text = "\(upSpeed.MB.afterPoint(1)) MB/s"
        } else {
            uploadLb.text = "\(upSpeed.KB.afterPoint(1)) KB/s"
        }
            
        if downSpeed.MB > 1 {
            downloadLB.text = "\(downSpeed.MB.afterPoint(1)) MB/s"
        } else {
            downloadLB.text = "\(downSpeed.KB.afterPoint(1)) KB/s"
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let context = extensionContext {
            context.openURL(NSURL(string: "device9://")!, completionHandler: nil)
        }
    }
}
