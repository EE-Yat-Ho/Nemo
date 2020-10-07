//
//  TimerViewController.swift
//  BrainSupporter2
//
//  Created by 박영호 on 2020/08/06.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {

    @IBOutlet weak var firstTimer: UIButton!
    @IBOutlet weak var secondTimer: UIButton!
    @IBOutlet weak var thirdTimer: UIButton!
    @IBOutlet weak var lastTimer: UIButton!
    @IBOutlet weak var lastTimerTimeTF: UITextField!
    
    @IBOutlet weak var fieldAmount: UILabel!
    @IBOutlet weak var QuestionAmount: UILabel!
    @IBOutlet weak var startTestButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "똥종이")!)
        lastTimerTimeTF.delegate = self
        
        startTestButton.layer.borderColor = UIColor.systemBlue.cgColor
        startTestButton.layer.borderWidth = 1.0
        startTestButton.layer.cornerRadius = 5.0
        startTestButton.layer.masksToBounds = true
        
        fieldAmount.text = String(DataManager.shared.nowNoteName!) + " 등 " + String(DataManager.shared.noteAmount!) + "개의 노트 "
        QuestionAmount.text = "총 " + String(DataManager.shared.testQuestionList.count) + " 문제 중 " + String(DataManager.shared.nowQAmount!) + " 문제"
        
        //테스트 화면에서 하는게 맞긴한데 저기는 문제마다 리로드되더라 ㅜ
        DataManager.shared.testAnswerList.removeAll()
    }
    
    @IBAction func ClickFirstTimer(_ sender: UIButton) {
        sender.isSelected.toggle()
        secondTimer.isSelected = false
        thirdTimer.isSelected = false
        lastTimer.isSelected = false
    }
    @IBAction func ClickSecondTimer(_ sender: UIButton) {
        sender.isSelected.toggle()
        firstTimer.isSelected = false
        thirdTimer.isSelected = false
        lastTimer.isSelected = false
    }
    @IBAction func ClickThirdTimer(_ sender: UIButton) {
        sender.isSelected.toggle()
        firstTimer.isSelected = false
        secondTimer.isSelected = false
        lastTimer.isSelected = false
    }
    @IBAction func ClickLastTimer(_ sender: UIButton) {
        sender.isSelected.toggle()
        firstTimer.isSelected = false
        secondTimer.isSelected = false
        thirdTimer.isSelected = false
    }
    @IBAction func StartTestButtonClick(_ sender: Any) {
        // 셤시작 버튼
        
        // 타이머 확인하면서 값 설정해쥬기, 타이머 선택 안할시 알림
        if firstTimer.isSelected == true {
            DataManager.shared.timerTime = -1
        } else if secondTimer.isSelected == true {
            DataManager.shared.timerTime = 15
        } else if thirdTimer.isSelected == true {
            DataManager.shared.timerTime = 30
        } else if lastTimer.isSelected == true {
            // 커스텀 타이머했는데, 값이 0이면 알림
            if Int(lastTimerTimeTF.text!) ?? 0 == 0{
                let alert = UIAlertController(title: "알림", message: "커스텀 타이머의 값은 1이상으로 해주세요.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default)
                alert.addAction(okAction)
                // 알림창 띄우기
                present(alert, animated: true, completion: nil)
                return
            }
            
            DataManager.shared.timerTime = Int(lastTimerTimeTF.text!) ?? 1
        } else {
            let alert = UIAlertController(title: "알림", message: "타이머를 선택해주세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            alert.addAction(okAction)
            // 알림창 띄우기
            present(alert, animated: true, completion: nil)
            return
        }
        
        DataManager.shared.testQuestionList.shuffle()
        DataManager.shared.nowQNumber = 1
        tabBarController?.tabBar.isHidden = true
    }
}

extension TimerViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {// 캬 완벽~
        if Int(textField.text!) ?? 0 > 600 {
            textField.text = "600"
        }
        textField.text = String(Int(textField.text!) ?? 0)
    }
}
