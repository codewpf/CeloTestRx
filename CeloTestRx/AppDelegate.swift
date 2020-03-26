//
//  AppDelegate.swift
//  CeloTestRx
//
//  Created by Alex on 12/03/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit
import Then

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.createDB()
        
        return true
    }
    
    func createDB()  {
        CTPersonModel.createTable(with: CTPersonModel.sql)
            .subscribe { (event) in
                switch event {
                case let .error(err):
                    print("create person table success = " + err.localizedDescription)
                default:
                    print("create person table success")
                }
        }.disposed(by: rx.disposeBag)
        
        print(CTDataBaseManager.manager.dbURL)
    }
    
    
}

