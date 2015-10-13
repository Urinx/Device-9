//
//  InterfaceController.swift
//  Device 9 AppleWatch Extension
//
//  Created by Eular on 10/12/15.
//  Copyright © 2015 Eular. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    var watchSession: WCSession?
    @IBOutlet var cellularLB: WKInterfaceLabel!
    @IBOutlet var wifiLB: WKInterfaceLabel!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if WCSession.isSupported() {
            watchSession = WCSession.defaultSession()
            watchSession?.delegate = self
            watchSession?.activateSession()
            
            watchSession?.sendMessage(["msg": "get"], replyHandler: { (result: [String : AnyObject]) -> Void in
                let msg = result as! [String: String]
                if msg["msg"] == "data" {
                    self.cellularLB.setText(msg["cellularUsed"]! + "  " + msg["cellularLeft"]!)
                    self.wifiLB.setText(msg["wifiUsed"]! + "  Unlimited")
                }
                print(msg.description)
                }, errorHandler: nil)
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        let msg = applicationContext as! [String: String]
        if msg["msg"] == "data" {
            cellularLB.setText(msg["cellularUsed"]! + "  " + msg["cellularLeft"]!)
            wifiLB.setText(msg["wifiUsed"]! + "  Unlimited")
        }
        print(msg.description)
    }

    @IBAction func shareToFriend() {
        if WCSession.defaultSession().reachable {
            watchSession?.sendMessage(["share": "wechat"], replyHandler: { (result: [String : AnyObject]) in
                print(result.description)
            }, errorHandler: nil)
        }
    }
    
}
