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
        //글자 크기 늘리기, 글자 오프셋은 스토리보드에서
        let fontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0)]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
        //편집화면일 경우
        if editTarget != nil {
            if editTarget?.isSubjective == true{
                let targetView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MakeSubjectiveQuestionViewController") as! MakeSubjectiveQuestionViewController
                //targetView.editTarget = editTarget
                self.viewControllers?[1] = targetView
                self.selectedIndex = 1
            } else {
                let targetView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MakeMultipleChoiceQuestionViewController") as! MakeMultipleChoiceQuestionViewController
                //targetView.editTarget = editTarget
            }
        }
    }
    override func viewDidLayoutSubviews() {
        // 탭바 상단에 위치
        tabBar.frame = CGRect(x: 0, y: 0, width: tabBar.frame.size.width, height: tabBar.frame.size.height)

        super.viewDidLayoutSubviews()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
