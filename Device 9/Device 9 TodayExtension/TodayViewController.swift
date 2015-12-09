//
//  TodayViewController.swift
//  Device 9 TodayExtension
//
//  Created by Eular on 9/17/15.
//  Copyright © 2015 Eular. All rights reserved.
//

import UIKit
import NotificationCenter
import Device9Kit

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var ssidLB: UILabel!
    
    @IBOutlet weak var storageLB: UILabel!
    @IBOutlet weak var batteryLB: UILabel!
    @IBOutlet weak var batteryImg: UIImageView!
    @IBOutlet weak var usedDataLB: UILabel!
    @IBOutlet weak var leftDataLB: UILabel!
    @IBOutlet weak var wifiLB: UILabel!
    @IBOutlet weak var uploadLb: UILabel!
    @IBOutlet weak var downloadLB: UILabel!
    
    let device9 = Device9()
    var timer: NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 调整Widget的高度
        self.preferredContentSize = CGSizeMake(0, 87)
        
        update()
        fresh()
    }
    
    override func viewWillAppear(animated: Bool) {
        if device9.network != .None {
            timer = NSTimer.scheduledTimerWithTimeInterval(device9.dataFlow.dt, target: self, selector: "fresh", userInfo: nil, repeats: true)
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        timer.invalidate()
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
        let storage = device9.systemFreeSize
        let battery = device9.batteryLevel
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
            
            switch device9.batteryState {
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
        
    }
    
    func fresh() {
        device9.dataFlow.update()
        let upSpeed = device9.dataFlow.upSpeed
        let downSpeed = device9.dataFlow.downSpeed
        
        // 流量数据
        let usedDataMB = device9.cellularUsedData.MB
        usedDataLB.text = "\(usedDataMB.afterPoint(1)) MB"
        leftDataLB.text = "\((device9.cellularTotalData.MB - usedDataMB).afterPoint(1)) MB"
            
        // WIFI数据
        let wifi = device9.wifiUsedData
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
