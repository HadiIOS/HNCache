//
//  AppDelegate.swift
//  HNStorage
//
//  Created by Hadi Nourallah on 2021-01-08.
//

import UIKit
import HNStorage

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    struct Str: Storable, Codable {
        var primaryKey: String {
            name
        }
        
        let name: String
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let s = HNStorage<HNUserDefaultsStorage>.init()
        
//        try? HNStorage<HNUserDefaultsStorage>().insert(Str(name: "domethig"))
        return true
    }
    
}

