//
//  DeviceData.swift
//  Device 9
//
//  Created by Eular on 9/19/15.
//  Copyright © 2015 Eular. All rights reserved.
//

import UIKit
import Foundation
import CoreTelephony

class DeviceData {
    
    enum NetworkState {
        case None
        case WIFI
        case Cellular
        case Connected
    }
    
    struct DataFlow {
        private let defaults = NSUserDefaults(suiteName: "group.device9SharedDefaults")!
        var upGPRS: Double = 0.0
        var upWiFi: Double = 0.0
        var downGPRS: Double = 0.0
        var downWiFi: Double = 0.0
        var upSpeed: Double = 0.0
        var downSpeed: Double = 0.0
        var dt = 1.0
        var cellularUsed: Double {
            set {
                defaults.setDouble(newValue, forKey: "CellularUsed")
                defaults.synchronize()
            }
            get {
                return defaults.doubleForKey("CellularUsed")
            }
        }
        var wifiUsed: Double {
            set {
                defaults.setDouble(newValue, forKey: "WiFiUsed")
                defaults.synchronize()
            }
            get {
                return defaults.doubleForKey("WiFiUsed")
            }
        }
        
        init() {
            
            let data = ObjC().getDataFlowBytes()
            upWiFi = data["WiFiSent"] as! Double
            downWiFi = data["WiFiReceived"] as! Double
            upGPRS = data["WWANSent"] as! Double
            downGPRS = data["WWANReceived"] as! Double
            
        }
        
        mutating func update() {
            let up1 = upGPRS + upWiFi
            let down1 = downGPRS + downWiFi
            let cell1 = upGPRS + downGPRS
            let wifi1 = upWiFi + downWiFi
            
            let data = ObjC().getDataFlowBytes()
            upWiFi = data["WiFiSent"] as! Double
            downWiFi = data["WiFiReceived"] as! Double
            upGPRS = data["WWANSent"] as! Double
            downGPRS = data["WWANReceived"] as! Double
            
            let up2 = upGPRS + upWiFi
            let down2 = downGPRS + downWiFi
            let cell2 = upGPRS + downGPRS
            let wifi2 = upWiFi + downWiFi
            
            upSpeed = (up2 - up1) / dt
            downSpeed = (down2 - down1) / dt
            
            cellularUsed += cell2 - cell1
            wifiUsed += wifi2 - wifi1
        }
    }
    
    let device = UIDevice.currentDevice()
    var dataFlow = DataFlow()
    
    
    var systemFreeSize: Double {
        let fm = NSFileManager.defaultManager()
        let fattributes = try! fm.attributesOfFileSystemForPath(NSHomeDirectory())
        return fattributes["NSFileSystemFreeSize"] as! Double
    }
    
    var batteryLevel: Float {
        return device.batteryLevel
    }
    
    var batteryState: UIDeviceBatteryState{
        return device.batteryState
    }
    
    var ip: String? {
        let ipAddr = getIFAddresses()
        if ipAddr.count > 0 {
            return ipAddr[0]
        }
        return nil
    }
    
    var wan: [String: String]? {
        let url = NSURL(string: "http://1111.ip138.com/ic.asp")
        let gb2312 = CFStringConvertEncodingToNSStringEncoding(0x0632)
        do {
            let html = try NSString(contentsOfURL: url!, encoding: gb2312) as String
            let tmp = html.split("[")[1].split("]")
            let wan = tmp[0]
            let pos = tmp[1].split("<")[0].split("：")[1]
            return ["ip":wan, "pos":pos]
        } catch {
            return nil
        }
    }
    
    // Network
    var network: NetworkState {
        if self.ip != nil {
            return .Connected
        }
        return .None
    }
    
    // WIFI
    var SSID: String {
        return ObjC().SSID()
    }
    
    var BSSID: String {
        return ObjC().BSSID()
    }
    
    var cellularUsedData: Double {
        return dataFlow.cellularUsed
    }
    
    var cellularTotalData: Double {
        return NSUserDefaults(suiteName: "group.device9SharedDefaults")!.doubleForKey("CellularTotal")
    }
    
    var wifiUsedData: Double {
        return dataFlow.wifiUsed
    }
    
    var mobileTemperature: Double {
        return 30.0
    }
    
    var UUID: String {
        return device.identifierForVendor!.UUIDString
    }
    
    var name: String {
        return device.name
    }
    
    var systemVersion: String {
        return device.systemVersion
    }
    
    var app: Array<String> {
        var appList = [String]()
        for app in ObjC().getAppList() {
            let BundleID = String(app).split(" ")[2]
            if !BundleID.hasPrefix("com.apple") {
                appList.append(BundleID)
            }
        }
        return appList
    }
    
    var appNum: Int {
        return app.count
    }
    
    init() {
        device.batteryMonitoringEnabled = true
    }
}

// add to swift bridge #include <ifaddrs.h>
func getIFAddresses() -> [String] {
    var addresses = [String]()
    
    // Get list of all interfaces on the local machine:
    var ifaddr : UnsafeMutablePointer<ifaddrs> = nil
    if getifaddrs(&ifaddr) == 0 {
        
        // For each interface ...
        for (var ptr = ifaddr; ptr != nil; ptr = ptr.memory.ifa_next) {
            let flags = Int32(ptr.memory.ifa_flags)
            var addr = ptr.memory.ifa_addr.memory
            
            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
                    if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                        nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String.fromCString(hostname) {
                                addresses.append(address)
                            }
                    }
                }
            }
        }
        freeifaddrs(ifaddr)
    }
    return addresses
}

extension Double {
    var KB: Double {
        return self / 1024
    }
    
    var MB: Double {
        return self.KB / 1024
    }
    
    var GB: Double {
        return self.MB / 1024
    }
    
    func afterPoint(n: Int) -> Double {
        let s = String(format: "%.\(n)f", self)
        return Double(s)!
    }
}

extension String {
    func split(separator: String) -> [String] {
        return self.componentsSeparatedByString(separator)
    }
}
