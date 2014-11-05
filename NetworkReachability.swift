//
//  NetworkReachability.swift
//  Capitol Words
//
//  Created by srihari padmanabhan on 11/4/14.
//  Copyright (c) 2014 docusign. All rights reserved.
//

import UIKit
import Foundation

var alert : UIAlertView!

/*
struct alertVisibility {
    static var visible : Bool = false
    static var computedTypeProperty: Int {
        // return an Int value here
    }
}
*/

public class NetworkReachability {
    class func isNetworkReachable() -> Bool {
        let reachability: Reachability = Reachability.reachabilityForInternetConnection()
        let networkStatus: Int = reachability.currentReachabilityStatus().value
        return networkStatus != 0
    }
    
    class func showNetworkUnreachableAlert() {
        if(alert == nil) {
            alert = UIAlertView()
        }
        
        if !(alert.visible) {
            alert.title = "Network unreachable"
            alert.message = "Please connect to the internet"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
    }
}