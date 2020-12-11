//
//  EndTestTableViewController.swift
//  BrainSupporter2
//
//  Created by 박영호 on 2020/08/10.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class EndTestTableViewController: UIViewController {
    let topView = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    let resultLabel = UILabel().then {
        $0.font = UIFont(name: "NotoSansKannada-Bold", size: 20)
        $0.text = "시험 결과"
        $0.textColor = UIColor.white
    }
    let xButton = UIButton().then {
        $0.setImage(UIImage(named: "엑스_회색"), for: .normal)
        $0.addTarget(self, action: #selector(xmarkClick(_:)), for: .touchUpInside)
    }
    
    let containerView = UIView().then{
        $0.backgroundColor = UIColor.clear
    }
    let rightQuestionNumLabel = UILabel().then {
        $0.font = UIFont(name: "NotoSansKannada-Regular", size: 18)
        $0.text = "맞춘 문제 수"
    }
    let questionImage = UIImageView().then {
        $0.image = UIImage(named:"문제")
    }
    let rightNumPerNumLable = UILabel().then {
        $0.text = "0 / 0"
        $0.font = UIFont(name: "NotoSansKannada-Bold", size: 22)
    }
    let separator = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    let tableView = UITableView().then {
        $0.register(EndingCell.self, forCellReuseIdentifier: "EndingCell")
        $0.separatorStyle = .none
        $0.backgroundColor = UIColor.clear
        $0.tableFooterView = UIView()
    }
    var isRightList = Array(repeating: false, count: DataManager.shared.testAnswerList.count)
    var rightAmount = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        getRightList()
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = "시험결과"
    }
    
    func getRightList() {
        rightAmount = 0
        for (index, question) in DataManager.shared.testQuestionList.enumerated() {
            if question.isSubjective {
                if question.answer == DataManager.shared.testAnswerList[index] {
                    isRightList[index] = true
                    rightAmount += 1
                } else {
                    for i in question.answers ?? []{
                        if i == DataManager.shared.testAnswerList[index] {
                            isRightList[index] = true
                            rightAmount += 1
                        }
                    }
                }
            } else {
                if question.answer == DataManager.shared.testAnswerList[index] {
                    isRightList[index] = true
                    rightAmount += 1
                }
            }
        }
        rightNumPerNumLable.text = String(rightAmount) + " / " + String(isRightList.count)
        
        for (index, elem) in isRightList.enumerated() {
            if elem == false {
                DataManager.shared.testQuestionList[index].failCount += 1
                DataManager.shared.testQuestionList[index].failDate = Date()
            }
        }
        
        DataManager.shared.saveContext()
    }
    
    func setupLayout() {
        view.backgroundColor = UIColor(patternImage: UIImage(named: "배경")!)
        
        topView.addSubview(resultLabel)
        topView.addSubview(xButton)
        view.addSubview(topView)
        
        containerView.addSubview(rightQuestionNumLabel)
        containerView.addSubview(questionImage)
        containerView.addSubview(rightNumPerNumLable)
        view.addSubview(containerView)
        
        view.addSubview(separator)
        view.addSubview(tableView)
        
        topView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
        }
        resultLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.centerX.equalToSuperview()
            //$0.height.equalTo(20)
            $0.bottom.equalToSuperview().offset(-15)
        }
        xButton.snp.makeConstraints{
            $0.centerY.equalTo(resultLabel)
            $0.height.width.equalTo(30)
            $0.trailing.equalToSuperview().offset(-15)
        }
        
        containerView.snp.makeConstraints{
            $0.top.equalTo(topView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(rightNumPerNumLable.snp.bottom).offset(30)
        }
        questionImage.snp.makeConstraints{
            $0.centerY.equalToSuperview().offset(-10)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(53)
        }
        rightNumPerNumLable.snp.makeConstraints{
            $0.top.equalTo(questionImage.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
            //$0.height.equalTo(25)
        }
        rightQuestionNumLabel.snp.makeConstraints{
            $0.bottom.equalTo(questionImage.snp.top).offset(-10)
            $0.centerX.equalToSuperview()
            //$0.height.equalTo(20)
        }
        separator.snp.makeConstraints{
            $0.height.equalTo(3)
            $0.top.equalTo(containerView.snp.bottom)//.offset(-3)
            $0.leading.trailing.equalToSuperview()//.inset(30)
        }
        
        tableView.snp.makeConstraints{
            $0.top.equalTo(containerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension EndTestTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.nowQAmount!
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EndingCell", for: indexPath) as! EndingCell
        cell.mappingData(index: indexPath.row, isRight: isRightList[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(190)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let makeQuestionViewController = MakeQuestionViewController()
        makeQuestionViewController.isEnd = true
        makeQuestionViewController.editTarget = DataManager.shared.testQuestionList[indexPath.row]
        navigationController?.navigationBar.isHidden = false
        navigationController?.pushViewController(makeQuestionViewController, animated: true)
    }
//
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row == DataManager.shared.nowQAmount { // 한번만 하면 되자너 ^_^ㅜ 다른 좋은 방법이 있을거같긴함..
//            endingCell.rightPerAll.text = String(rightAmount) + " / " + String(DataManager.shared.nowQAmount!)
//        }
//    }
//
    @objc func xmarkClick(_ sender: Any) {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popToRootViewController(animated: true)
    }
}
