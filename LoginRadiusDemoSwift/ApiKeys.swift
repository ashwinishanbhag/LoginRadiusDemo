//
//  ApiKeys.swift
//  LoginRadiusDemoSwift
//
//  Created by Anaaya Nayanesh Acharya on 14/04/17.
//  Copyright © 2017 Ashwini Acharya. All rights reserved.
//

import Foundation

func valueForAPIKey(named keyname:String) -> String {
    
    let filePath = Bundle.main.path(forResource: "ApiKeys", ofType: "plist")
    let plist = NSDictionary(contentsOfFile:filePath!)
    let value = plist?.object(forKey: keyname) as! String
    return value
}
