//
//  MakeQuestionViewController.swift
//  Nemo
//
//  Created by 박영호 on 2020/11/09.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class MakeQuestionViewController: UIViewController {
    
    var editTarget: Question?
    let multipleChoiceQuestionButton = UIButton().then{
        $0.setTitle("객관식", for: .normal)
        $0.setTitleColor(UIColor.systemBlue, for: .normal)
        $0.addTarget(self, action: #selector(setMCQ), for: .touchUpInside)
    }
    let subjectQuestionButton = UIButton().then{
        $0.setTitle("주관식", for: .normal)
        $0.setTitleColor(UIColor.systemBlue, for: .normal)
        $0.addTarget(self, action: #selector(setSQ), for: .touchUpInside)
    }
    let separateView = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
    }
    let separateView2 = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    }
    let containerView = UIView()
    
    let mutipleChoiceQuestionVC = MakeMultipleChoiceQuestionViewController()
    let subjectQuestionVC = MakeSubjectiveQuestionViewController()
    var currentTab = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        setupLayout()
        
        NotificationCenter.default.addObserver(self, selector: #selector(KeyBoardwillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
                       
        NotificationCenter.default.addObserver(self, selector: #selector(KeyBoardwillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        configure()
    }
    @objc func KeyBoardwillShow(_ noti : Notification ){
        let keyboardHeight = ((noti.userInfo as! NSDictionary).value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.height
        containerView.snp.updateConstraints{
            $0.bottom.equalToSuperview().offset(-keyboardHeight)
        }
    }
    @objc func KeyBoardwillHide(_ noti : Notification ){
        containerView.snp.updateConstraints{
            $0.bottom.equalToSuperview()
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func configure() {
        //편집화면일 경우
        if editTarget != nil {
            if editTarget?.isSubjective == true{
                setSQ()
                return
            }
        }
        setMCQ()
    }
    
    func setupLayout() {
        view.backgroundColor = UIColor(patternImage: UIImage(named: "배경")!)
        
        view.addSubview(multipleChoiceQuestionButton)
        view.addSubview(subjectQuestionButton)
        view.addSubview(separateView)
        view.addSubview(separateView2)
        view.addSubview(containerView)
        
        multipleChoiceQuestionButton.snp.makeConstraints{
            $0.top.leading.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(35)
            $0.width.equalTo(UIScreen.main.bounds.size.width / 2)
        }
        subjectQuestionButton.snp.makeConstraints{
            $0.top.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(35)
            $0.width.equalTo(UIScreen.main.bounds.size.width / 2)
        }
        separateView.snp.makeConstraints{
            $0.top.equalTo(multipleChoiceQuestionButton.snp.bottom)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(UIScreen.main.bounds.size.width / 2 - 40)
            $0.height.equalTo(3)
        }
        separateView2.snp.makeConstraints{
            $0.top.equalTo(separateView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        containerView.snp.makeConstraints{
            $0.top.equalTo(separateView2.snp.bottom)
            $0.bottom.trailing.leading.equalToSuperview()
        }
    }
    
    @objc func setMCQ() {
        if currentTab == 0 { return }
        currentTab = 0
        addChild(mutipleChoiceQuestionVC)
        containerView.addSubview(mutipleChoiceQuestionVC.view)
        
        subjectQuestionVC.removeFromParent()
        subjectQuestionVC.view.removeFromSuperview()
        
        mutipleChoiceQuestionVC.view.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        separateView.snp.updateConstraints{
            $0.leading.equalToSuperview().offset(20)
        }
    }
    
    @objc func setSQ() {
        if currentTab == 1 { return }
        currentTab = 1
        addChild(subjectQuestionVC)
        containerView.addSubview(subjectQuestionVC.view)
        
        mutipleChoiceQuestionVC.removeFromParent()
        mutipleChoiceQuestionVC.view.removeFromSuperview()
        
        subjectQuestionVC.view.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        separateView.snp.updateConstraints{
            $0.leading.equalToSuperview().offset(UIScreen.main.bounds.size.width / 2 + 20 )
        }
    }
}
