//
//  UIFont+.swift
//  Nemo
//
//  Created by 박영호 on 2020/12/30.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

extension UIFont {
    static func handSmall() -> UIFont {
        return UIFont(name:  "NanumGoDigANiGoGoDing", size: 15)!
    }
    static func handNormal16() -> UIFont {
        return UIFont(name:  "NanumGoDigANiGoGoDing", size: 16)!
    }
    static func handNormal() -> UIFont {
        return UIFont(name:  "NanumGoDigANiGoGoDing", size: 20)!
    }
    static func handBig() -> UIFont {
        return UIFont(name:  "NanumGoDigANiGoGoDing", size: 30)!
    }
    static func notoBig() -> UIFont {
        return UIFont(name: "NotoSansKannada-Bold", size: 30)!
    }
    
    static func testAnswer() -> UIFont {
        return UIFont(name: Resource.Font.globalFont,
                      size: 20 * Resource.Font.sizeCorrect)!
    }
    static func testQuestion() -> UIFont {
        return UIFont(name: Resource.Font.globalFont,
                      size: 30 * Resource.Font.sizeCorrect)!
    }
}
