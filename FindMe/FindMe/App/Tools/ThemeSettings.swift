//
//  ThemeSettings.swift
//  FindMe
//
//  Created by Алексей on 24.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class ThemeSettings {
    
    //MARK: Colors
    public struct Colors {
        
        public static let main = UIColor(red: 246, green: 101, blue: 86)
        public static let divider = UIColor(red: 215, green: 216, blue: 218)
        
        public static let blackText = UIColor(red: 57, green: 51, blue: 53)
        public static let whiteText = UIColor(red: 57, green: 51, blue: 53)
        
        public static let background = UIColor(red: 255, green: 255, blue: 255)
    }
    
    
    
    //MARK: Images
    public struct Images {
        
        public static let `default` = UIImage(contentsOfFile: "\(Bundle.main.bundlePath)/default-image.jpg")!
    }
    
    
    
    //MARK: Fonts
    public class Fonts {
        
        public static let defaultName = "Helvetica"
        
        public enum Sizes: Int {
            
            case title = 20
            case headline = 17
            case subhead = 15
            case caption = 12
        }
        
        
        
        public class func `default`(size: CGFloat) -> UIFont {
            
            return UIFont(name: defaultName, size: size)!
        }
        public class func `default`(size: Sizes) -> UIFont {
            
            return UIFont(name: defaultName, size: CGFloat(size.rawValue))!
        }
    }
    
    //MARk: Date & Time formats
    public struct DataTimeFormat {
        
        public static let dateWithTime = "HH:mm dd/MM/yyyy"
        public static let shortTime = "HH:MM"
        public static let shortDate = "dd/MM"
    }
}