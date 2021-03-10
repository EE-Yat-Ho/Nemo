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
        return UIFont(name: Resource.Font.globalFont, size: 15)! // "NanumGoDigANiGoGoDing"
    }
    static func handNormal16() -> UIFont {
        return UIFont(name: Resource.Font.globalFont, size: 16)! // "NanumGoDigANiGoGoDing"
    }
    static func handNormal() -> UIFont {
        return UIFont(name: Resource.Font.globalFont, size: 20)! // "NanumGoDigANiGoGoDing"
    }
    static func handBig() -> UIFont {
        return UIFont(name: Resource.Font.globalFont, size: 30)! // "NanumGoDigANiGoGoDing"
    }
    static func notoBig() -> UIFont {
        return UIFont(name: "NotoSansKannada-Bold", size: 30)!
    }
}
