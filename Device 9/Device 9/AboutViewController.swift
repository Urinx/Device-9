//
//  AboutViewController.swift
//  Device 9
//
//  Created by Eular on 9/21/15.
//  Copyright © 2015 Eular. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func goUrinx(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://urinx.github.io")!)
    }
    
    @IBAction func weixinShare(sender: AnyObject) {
        let message =  WXMediaMessage()
        message.title = "超用心的誠意之作，讓通知中心變得從來沒有這麼好用"
        message.setThumbImage(UIImage(named: "d9"))
        let ext =  WXWebpageObject()
        ext.webpageUrl = ArticleLink
        message.mediaObject = ext
        let req =  SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = Int32(WXSceneTimeline.rawValue)
        WXApi.sendReq(req)
    }
    
    @IBAction func weixinShareFriend(sender: AnyObject) {
        let message =  WXMediaMessage()
        message.title = "Device 9"
        message.description = "超用心的誠意之作，讓通知中心變得從來沒有這麼好用"
        message.setThumbImage(UIImage(named: "d9"))
        let ext =  WXWebpageObject()
        ext.webpageUrl = ArticleLink
        message.mediaObject = ext
        let req =  SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = Int32(WXSceneSession.rawValue)
        WXApi.sendReq(req)
    }

    @IBAction func back(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
