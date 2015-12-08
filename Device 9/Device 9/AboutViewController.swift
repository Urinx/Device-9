//
//  AboutViewController.swift
//  Device 9
//
//  Created by Eular on 9/21/15.
//  Copyright © 2015 Eular. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBAction func goUrinx(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: Urinx)!)
    }
    
    @IBAction func weixinShareTimeline(sender: AnyObject) {
        weixinShare(WXSceneTimeline, title: WXShareDescription)
    }
    
    @IBAction func weixinShareFriend(sender: AnyObject) {
        weixinShare(WXSceneSession, title: WXShareTitle)
    }
    
    func weixinShare(scene: WXScene, title: String) {
        if WXApi.isWXAppInstalled() {
            let message =  WXMediaMessage()
            message.title = title
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

    @IBAction func back(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
