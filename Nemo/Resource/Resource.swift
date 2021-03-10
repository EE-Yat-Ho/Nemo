//
//  Resource.swift
//  Nemo
//
//  Created by 박영호 on 2020/12/30.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

enum FontKind: String { // fontSize, topPadding, bottomPadding
    case NanumGoDigANiGoGoDing = "NanumGoDigANiGoGoDing" // 1.00, 0, 0
    case NotoSansKannada = "NotoSansKannada-Regular" // 0.85, 7, -6.5
}

struct Resource {
    static let buttonNormal = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
    static let buttonHighLight = #colorLiteral(red: 0.03921568627, green: 0.4383561644, blue: 0.8965111301, alpha: 1)
    
    struct Font {
        static var globalFont: String = "NanumGoDigANiGoGoDing"
        static var sizeCorrect: CGFloat = 1
        static var topPadding: CGFloat = 0
        static var bottomPadding: CGFloat = 0
        // 유저디폴트와 인스턴스 모두 세팅
        static func setGlobalFont(font: FontKind) {
            UserDefaults.standard.set(font.rawValue, forKey: "GlobalFont")
            FontUDtoInstance()
        }
        // 유저디폴트에 있는 값을 인스턴스로
        static func FontUDtoInstance() {
            guard let font = UserDefaults.standard.value(forKey: "GlobalFont") as? String
            else { return }
            globalFont = font
            if globalFont == "NanumGoDigANiGoGoDing" {
                sizeCorrect = 1.0
                topPadding = 0
                bottomPadding = 0
            } else if globalFont == "NotoSansKannada-Regular" {
                sizeCorrect = 0.85
                topPadding = 7
                bottomPadding = -6.5
            }
        }
    }
}
