//
//  backPackTimeTabBarController.swift
//  BrainSupporter2
//
//  Created by 박영호 on 2020/07/31.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class BackPackTimeTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //글자 크기 늘리기, 글자 오프셋은 스토리보드에서
        let fontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0)]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
    }
    override func viewDidLayoutSubviews() {
        // 탭바 상단에 위치
        tabBar.frame = CGRect(x: 0, y: 0, width: tabBar.frame.size.width, height: tabBar.frame.size.height)

        super.viewDidLayoutSubviews()
    }
}
