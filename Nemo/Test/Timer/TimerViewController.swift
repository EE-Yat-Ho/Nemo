//
//  TimerViewController.swift
//  BrainSupporter2
//
//  Created by 박영호 on 2020/08/06.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {

    let firstTimer = UIButton().then {
        $0.setImage(UIImage(named: "타이머"), for: .normal)
        $0.setImage(UIImage(named: "타이머_선택"), for: .selected)
        $0.setImage(UIImage(named: "타이머_선택"), for: .highlighted)
        $0.addTarget(self, action: #selector(clickFirstTimer(_:)), for: .touchUpInside)
    }
    let firstLabel = UILabel().then {
        $0.text = "설정 안해"
        $0.textAlignment = .center
    }
    let secondTimer = UIButton().then {
        $0.setImage(UIImage(named: "타이머"), for: .normal)
        $0.setImage(UIImage(named: "타이머_선택"), for: .selected)
        $0.setImage(UIImage(named: "타이머_선택"), for: .highlighted)
        $0.addTarget(self, action: #selector(clickSecondTimer(_:)), for: .touchUpInside)
    }
    let secondLabel = UILabel().then {
        $0.text = "15s"
        $0.textAlignment = .center
    }
    let lastTimer = UIButton().then {
        $0.setImage(UIImage(named: "타이머"), for: .normal)
        $0.setImage(UIImage(named: "타이머_선택"), for: .selected)
        $0.setImage(UIImage(named: "타이머_선택"), for: .highlighted)
        $0.addTarget(self, action: #selector(clickLastTimer(_:)), for: .touchUpInside)
    }
    let lastLabel = UILabel().then {
        $0.text = "s"
    }
    let lastTimerTimeTF = UITextField().then {
        $0.text = "30"
        $0.font = UIFont.systemFont(ofSize: 18)
        $0.borderStyle = UITextField.BorderStyle.roundedRect
        $0.autocorrectionType = UITextAutocorrectionType.no
        $0.keyboardType = UIKeyboardType.decimalPad
        $0.returnKeyType = UIReturnKeyType.done
        $0.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
    }
    
    let fieldAmount = UILabel().then{
        $0.textAlignment = .center
    }
    let questionAmount = UILabel().then{
        $0.textAlignment = .center
    }
    let startTestButton = UIButton().then {
        $0.backgroundColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        $0.setTitle("시험 시작", for: .normal)
        $0.addTarget(self, action: #selector(clickStartTestButton), for: .touchUpInside)
        $0.layer.borderColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 5.0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "배경")!)
        lastTimerTimeTF.delegate = self
        
        if DataManager.shared.noteAmount! > 0 {
            fieldAmount.text = "총 " + String(DataManager.shared.noteAmount!) + "개의 노트"
        } else {
            switch DataManager.shared.noteAmount {
            case 0:
                fieldAmount.text = "일주일 동안의 문제들"
            case -1:
                fieldAmount.text = "이주일 동안의 문제들"
            case -2:
                fieldAmount.text = "한달 동안의 문제들"
            case -3:
                fieldAmount.text = "모든 문제들"
            case .none:
                print("error")
            case .some(_):
                print("error")
            }
        }
        
        questionAmount.text = String(DataManager.shared.nowQAmount!) + " 문제"
        
        setupLayout()
        //테스트 화면에서 하는게 맞긴한데 저기는 문제마다 리로드되더라 ㅜ
        DataManager.shared.testAnswerList.removeAll()
    }
    
    func setupLayout() {
        view.addSubview(fieldAmount)
        view.addSubview(questionAmount)
        view.addSubview(firstTimer)
        view.addSubview(firstLabel)
        view.addSubview(secondTimer)
        view.addSubview(secondLabel)
        view.addSubview(lastTimer)
        view.addSubview(lastLabel)
        view.addSubview(lastTimerTimeTF)
        view.addSubview(startTestButton)
        
        fieldAmount.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-100)
        }
        questionAmount.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(fieldAmount.snp.bottom).offset(20)
        }
        
        firstTimer.snp.makeConstraints{
            $0.centerY.equalTo(secondTimer)
            $0.trailing.equalTo(secondTimer.snp.leading).offset(-50)
            $0.height.width.equalTo(30)
        }
        secondTimer.snp.makeConstraints{
            $0.top.equalTo(questionAmount.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(30)
        }
        lastTimer.snp.makeConstraints{
            $0.centerY.equalTo(secondTimer)
            $0.leading.equalTo(secondTimer.snp.trailing).offset(50)
            $0.height.width.equalTo(30)
        }
        
        lastTimerTimeTF.snp.makeConstraints{
            $0.top.equalTo(lastTimer.snp.bottom).offset(5)
            $0.centerX.equalTo(lastTimer)
        }
        firstLabel.snp.makeConstraints{
            $0.centerY.equalTo(lastTimerTimeTF)
            $0.centerX.equalTo(firstTimer)
        }
        secondLabel.snp.makeConstraints{
            $0.centerY.equalTo(lastTimerTimeTF)
            $0.centerX.equalTo(secondTimer)
        }
        lastLabel.snp.makeConstraints{
            $0.centerY.equalTo(lastTimerTimeTF)
            $0.leading.equalTo(lastTimerTimeTF.snp.trailing).offset(1)
        }
        
        
        startTestButton.snp.makeConstraints{
            $0.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(40)
        }
    }
    
    @objc func clickFirstTimer(_ sender: UIButton) {
        sender.isSelected.toggle()
        secondTimer.isSelected = false
        lastTimer.isSelected = false
    }
    @objc func clickSecondTimer(_ sender: UIButton) {
        sender.isSelected.toggle()
        firstTimer.isSelected = false
        lastTimer.isSelected = false
    }
    @objc func clickLastTimer(_ sender: UIButton) {
        sender.isSelected.toggle()
        firstTimer.isSelected = false
        secondTimer.isSelected = false
    }
    @objc func clickStartTestButton(_ sender: Any) {
        // 셤시작 버튼
        
        // 타이머 확인하면서 값 설정해쥬기, 타이머 선택 안할시 알림
        if firstTimer.isSelected == true {
            DataManager.shared.timerTime = -1
        } else if secondTimer.isSelected == true {
            DataManager.shared.timerTime = 15
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
        DataManager.shared.orderingAnswersToTestQuestion()
        DataManager.shared.nowQNumber = 1
        tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(TestViewController(), animated: true)
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
