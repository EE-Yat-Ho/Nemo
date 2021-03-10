//
//  Resource.swift
//  Nemo
//
//  Created by 박영호 on 2020/12/30.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

enum FontKind: String {
    case NotoSansKannada = "NotoSansKannada-Regular"
    case NanumGoDigANiGoGoDing = "NanumGoDigANiGoGoDing"
}

struct Resource {
    static let buttonNormal = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
    static let buttonHighLight = #colorLiteral(red: 0.03921568627, green: 0.4383561644, blue: 0.8965111301, alpha: 1)
    
    struct Font {
        static var globalFont: String = "NanumGoDigANiGoGoDing"
        // 유저디폴트와 인스턴스 모두 세팅
        static func setGlobalFont(font: FontKind) {
            self.globalFont = font.rawValue
            UserDefaults.standard.set(font.rawValue, forKey: "GlobalFont")
        }
        // 유저디폴트에 있는 값을 인스턴스로
        static func FontUDtoInstance() {
            guard let font = UserDefaults.standard.value(forKey: "GlobalFont") as? String
            else { return }
            self.globalFont = font
        }
    }
}
