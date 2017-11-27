//
//  AppSummary.swift
//  FindMe
//
//  Created by Алексей on 24.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

public class AppSummary {
    
    public static let shared = AppSummary()
    
    public let serverUrl: String
    
    public var version: String
    public var build: Int
    public var prevVersion: String?
    public var prevBuild: Int?
    public var isNewVersion: Bool
    public var isCriticalUpdate: Bool
    public var isFirstLaunch: Bool {
        return nil == prevVersion
    }
    


    private init() {
        
        let configs = ToolsServices.shared.configs
        
        self.serverUrl = configs.get(forKey: ConfigsKey.serverUrl).value as! String
        
        
        //Version
        self.version = "1.0.0"
        self.build = 1
        self.isNewVersion = false
        self.isCriticalUpdate = false
        checkVersion()
    }
    private func checkVersion() {
        
        let configs = ConfigsStorage(plistName: "Info")
        
        self.version = configs.get(forKey: "CFBundleShortVersionString").value as! String
        self.build = Int(configs.get(forKey: "CFBundleVersion").value as! String)!
        
        
        let storage = PropertiesStorage<PropertiesKey>();
        
        let prevVersion = storage.getString(.appVersion)
        let prevBuild = storage.getInt(.appBuild)
        
        //Update versions and build
        storage.set(.appVersion, value: version)
        storage.set(.appBuild, value: build)
        
        if (!prevVersion.hasValue || !prevBuild.hasValue) {

            self.prevVersion = nil
            self.prevBuild = nil

            return
        }
        
        // Check on new version
        if (build > prevBuild.value) {
            
            self.isNewVersion = true
        } else {
            
            self.isNewVersion = false
            return
        }
        
        // Check on critical update
        let parsedCurrent = parseVersion(version)
        let parsedLast = parseVersion(prevVersion.value)
        
        if ((parsedCurrent.0 > parsedLast.0) ||
            (parsedCurrent.1 > parsedLast.1)) {
            
            self.isCriticalUpdate = true
        } else {
            
            self.isCriticalUpdate = false
        }

        self.prevVersion = prevVersion.value
        self.prevBuild = prevBuild.value
    }
    private func parseVersion(_ version: String) -> (Int, Int, Int) {
        
        let range = version.components(separatedBy: ".").map{ String($0) }
        
        return (Int(range[0])!,
                Int(range[1])!,
                Int(range[2])!)
    }



    public func launchApp() {

        Log.Info(String.tag(AppSummary.self), "Init AppSummary.")
    }
}
