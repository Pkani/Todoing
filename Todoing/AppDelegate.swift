//
//  AppDelegate.swift
//  Todoing
//
//  Created by Artixun on 7/13/20.
//  Copyright © 2020 Pk. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //print(Realm.Configuration.defaultConfiguration.fileURL!) // for realm file path

        do {
            // let realm = try Realm()
            _ = try Realm()
            }catch {
            print("Error initialising new realm, \(error)")
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    func applicationDidBecomeActive(_ application: UIApplication) {

    }
    func applicationWillTerminate(_ application: UIApplication) {

    }
    
}


