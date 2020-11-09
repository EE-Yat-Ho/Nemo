//
//  QuestionTabBarController.swift
//  BrainSupporter2
//
//  Created by 박영호 on 2020/07/19.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class QuestionTabBarController: UITabBarController {
    var editTarget: Question?
    override func viewDidLoad() {
        super.viewDidLoad()
        //tabBarController?.tabBar.backgroundColor = UIColor.clear
        // 왜 안먹냐 ㅡㅡ
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.backgroundColor = UIColor.clear
        //글자 크기 늘리기, 글자 오프셋은 스토리보드에서
        let fontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0)]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
        
        
        viewControllers = [MakeMultipleChoiceQuestionViewController(), MakeSubjectiveQuestionViewController()]
        
        //편집화면일 경우
        if editTarget != nil {
            if editTarget?.isSubjective == true{
                self.selectedIndex = 1
            }
        }
    }
    override func viewDidLayoutSubviews() {
        // 탭바 상단에 위치
        tabBar.frame = CGRect(x: 0, y: 0, width: tabBar.frame.size.width, height: tabBar.frame.size.height)

        super.viewDidLayoutSubviews()
    }
}
