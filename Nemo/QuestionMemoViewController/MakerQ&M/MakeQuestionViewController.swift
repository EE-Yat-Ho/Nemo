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
    let containerView = UIView()
    
    let mutipleChoiceQuestionVC = MakeMultipleChoiceQuestionViewController()
    let subjectQuestionVC = MakeSubjectiveQuestionViewController()
    var currentTab = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupLayout()
    }
    
    func configure() {
        
    }
    
    func setupLayout() {
        view.backgroundColor = UIColor(patternImage: UIImage(named: "배경")!)
        
        view.addSubview(multipleChoiceQuestionButton)
        view.addSubview(subjectQuestionButton)
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
        containerView.snp.makeConstraints{
            $0.top.equalTo(multipleChoiceQuestionButton.snp.bottom)
            $0.bottom.trailing.leading.equalToSuperview()
        }
    }
    
    @objc func setMCQ() {
        if currentTab == 0 { return }
        currentTab = 0
        addChild(mutipleChoiceQuestionVC)
        containerView.addSubview(mutipleChoiceQuestionVC.view)
    }
    
    @objc func setSQ() {
        if currentTab == 1 { return }
        currentTab = 1
        addChild(subjectQuestionVC)
        containerView.addSubview(subjectQuestionVC.view)
    }
}
