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
    let containerView = UIView()
    
    let mutipleChoiceQuestionVC = MakeMultipleChoiceQuestionViewController()
    let subjectQuestionVC = MakeSubjectiveQuestionViewController()
    var currentTab = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        setupLayout()
    }
    
    override func viewDidLayoutSubviews() {
        configure()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
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
        containerView.snp.makeConstraints{
            $0.top.equalTo(separateView.snp.bottom)
            $0.bottom.trailing.leading.equalToSuperview()
        }
    }
    
    @objc func setMCQ() {
        if currentTab == 0 { return }
        currentTab = 0
        addChild(mutipleChoiceQuestionVC)
        containerView.addSubview(mutipleChoiceQuestionVC.view)
        separateView.snp.updateConstraints{
            $0.leading.equalToSuperview().offset(20)
        }
    }
    
    @objc func setSQ() {
        if currentTab == 1 { return }
        currentTab = 1
        addChild(subjectQuestionVC)
        containerView.addSubview(subjectQuestionVC.view)
        separateView.snp.updateConstraints{
            $0.leading.equalToSuperview().offset(UIScreen.main.bounds.size.width / 2 + 20 )
        }
    }
}
