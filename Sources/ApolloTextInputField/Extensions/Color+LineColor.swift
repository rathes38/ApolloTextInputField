//
//  Color+RGB.swift
//  LawInputTextField
//
//  Created by Amjad Khan on 30/04/19.
//  Copyright © 2019 Conduent. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    struct LineColor {
        static var Focus: UIColor  { return UIColor(red: 0, green: 0, blue: 0) }
        static var Active: UIColor { return UIColor(red: 255, green: 135, blue: 0) }
        static var Success: UIColor { return UIColor(red: 0, green: 180, blue: 160) }
        static var Failure: UIColor { return UIColor(red: 201, green: 37, blue: 0) }
        static var Warning: UIColor { return UIColor(red: 255, green: 204, blue: 0) }
        static var Default: UIColor {return UIColor(red: 170, green: 175, blue: 185) }
        static var Disable: UIColor {return UIColor(red: 170, green: 175, blue: 185) }

    }
}
