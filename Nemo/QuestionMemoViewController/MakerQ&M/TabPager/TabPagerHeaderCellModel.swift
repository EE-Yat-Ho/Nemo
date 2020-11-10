////
////  PagerHeaderCellModel.swift
////  UPlusAR
////
////  Created by baedy on 2020/03/24.
////  Copyright © 2020 최성욱. All rights reserved.
////
//
//import UIKit
//
//public struct TabPagerHeaderCellModel {
//    let title: String
//    var selectedFont: UIFont?
//    var deSelectedFont: UIFont?
//
//    var titleSelectedColor: UIColor?
//    var titleDeSelectedColor: UIColor?
//
//    let indicatorColor: UIColor? = nil
//    let indicatorHeight: CGFloat? = nil
//    var displayNewIcon: Bool?
//    var iconImage: UIImage?
//    var iconSelectedImage: UIImage?
//
//    func callAsFunction() -> TabPagerHeaderView {
//        TabPagerHeaderView().then {
//            $0.cellset(self)
//            $0.data = self
//        }
//    }
//}
//
//class TabPagerHeaderDefault {
//    static let indicatorHeight: CGFloat = 3.0
//    static let indicatorColor: UIColor = UIColor.white
//    static let selectedFont = UIFont()
//    static let selectedColor: UIColor = UIColor.red
//    static let deSelectedFont = UIFont()//.notoSans(.regular, size: 17)
//    static let deSelectedColor: UIColor = UIColor.white//R.Color.default ~ 70%
//}
