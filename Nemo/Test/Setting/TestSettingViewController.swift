//
//  BackPackTestSettingViewController.swift
//  BrainSupporter2
//
//  Created by 박영호 on 2020/07/31.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class TestSettingViewController: UIViewController {
    
    var titleLabel = UILabel().then{
        $0.text = "풀어보기"
        $0.font = UIFont(name: "NotoSansKannada-Bold", size: 34)
    }
    let backPackButton = UIButton().then{
        $0.setTitle("가방", for: .normal)
        $0.setTitleColor(UIColor.systemBlue, for: .normal)
        $0.addTarget(self, action: #selector(setBP), for: .touchUpInside)
    }
    let timeButton = UIButton().then{
        $0.setTitle("시간", for: .normal)
        $0.setTitleColor(UIColor.systemBlue, for: .normal)
        $0.addTarget(self, action: #selector(setT), for: .touchUpInside)
    }
    let separateView = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
    }
    let separateView2 = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    }
    
    let testableContainer = UIView()
    let testableLabel = UILabel().then {
        $0.text = "가능한 문제 수:"
    }
    let testableNumLabel = UILabel().then {
        $0.text = "0"
    }
    
    let wantContainer = UIView()
    let wantLabel = UILabel().then {
        $0.text = "풀고 싶은 문제 수:"
    }
    let wantTextField = UITextField().then {
        $0.text = "0"
        $0.font = UIFont.systemFont(ofSize: 18)
        $0.borderStyle = UITextField.BorderStyle.roundedRect
        $0.autocorrectionType = UITextAutocorrectionType.no
        $0.keyboardType = UIKeyboardType.decimalPad
        $0.returnKeyType = UIReturnKeyType.done
        //$0.clearButtonMode = UITextField.ViewMode.whileEditing
        $0.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
    }
    var tableView = UITableView().then {
        $0.register(NoteCell_Test.self, forCellReuseIdentifier: "NoteCell_Test")
        $0.register(BackPackCell_Test.self, forCellReuseIdentifier: "BackPackCell_Test")
        $0.register(TimeCell.self, forCellReuseIdentifier: "TimeCell")
        $0.tableFooterView = UIView()
    }
    let testReadyButton = UIButton().then{
        $0.backgroundColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        $0.setTitle("시험 준비", for: .normal)
        $0.addTarget(self, action: #selector(clickTestReadyButton), for: .touchUpInside)
        $0.layer.borderColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 5.0
    }
    
    var isTime = false
    var bpBoolList = [[Bool]]()
    var timeBoolList = [false, false, false, false]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "배경")!)
        
        tableView.delegate = self
        tableView.dataSource = self
        wantTextField.delegate = self
        
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        testableNumLabel.text = "0"
        wantTextField.text = "0"
        
        for (idx, ele) in bpBoolList.enumerated() {
            for (idx2, ele2) in ele.enumerated() {
                if ele2 {
                    bpBoolList[idx][idx2] = false
                }
            }
        }
        
        tableView.reloadData()
    }
    
    func setupLayout() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        
        tableView.separatorColor = UIColor.clear
        tableView.backgroundColor = UIColor.clear
        
        view.addSubview(titleLabel)
        view.addSubview(backPackButton)
        view.addSubview(timeButton)
        view.addSubview(separateView)
        view.addSubview(separateView2)
        testableContainer.addSubview(testableLabel)
        testableContainer.addSubview(testableNumLabel)
        view.addSubview(testableContainer)
        wantContainer.addSubview(wantLabel)
        wantContainer.addSubview(wantTextField)
        view.addSubview(wantContainer)
        view.addSubview(tableView)
        view.addSubview(testReadyButton)
        
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        backPackButton.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.equalToSuperview()
            $0.height.equalTo(35)
            $0.width.equalTo(UIScreen.main.bounds.size.width / 2)
        }
        timeButton.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(35)
            $0.width.equalTo(UIScreen.main.bounds.size.width / 2)
        }
        separateView.snp.makeConstraints{
            $0.top.equalTo(backPackButton.snp.bottom)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(UIScreen.main.bounds.size.width / 2 - 40)
            $0.height.equalTo(3)
        }
        separateView2.snp.makeConstraints{
            $0.top.equalTo(separateView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        testableLabel.snp.makeConstraints{
            $0.top.bottom.leading.equalToSuperview()
        }
        testableNumLabel.snp.makeConstraints{
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalTo(testableLabel.snp.trailing).offset(8)
        }
        testableContainer.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(separateView2.snp.bottom).offset(20)
            $0.height.equalTo(20)
        }
        
        wantLabel.snp.makeConstraints{
            $0.leading.centerY.equalToSuperview()
            $0.height.equalTo(20)
        }
        wantTextField.snp.makeConstraints{
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalTo(wantLabel.snp.trailing).offset(8)
        }
        wantContainer.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(testableContainer.snp.bottom).offset(20)
        }
        
        tableView.snp.makeConstraints{
            $0.top.equalTo(wantContainer.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
        }
        testReadyButton.snp.makeConstraints{
            $0.top.equalTo(tableView.snp.bottom).offset(20)
            $0.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(40)
        }
    }
    
    @objc func setBP() {
        if !isTime { return }
        isTime.toggle()
        tableView.reloadData()
        
        bpBoolList.removeAll()
        testableNumLabel.text = "0"
        wantTextField.text = "0"
        
        separateView.snp.updateConstraints{
            $0.leading.equalToSuperview().offset(20)
        }
    }
    
    @objc func setT() {
        if isTime { return }
        isTime.toggle()
        tableView.reloadData()
        
        timeBoolList = [false,false,false,false]
        testableNumLabel.text = "0"
        wantTextField.text = "0"
        
        separateView.snp.updateConstraints{
            $0.leading.equalToSuperview().offset(UIScreen.main.bounds.size.width / 2 + 20 )
        }
    }
    
    @objc func clickTestReadyButton(_ sender: Any) {
        if (Int(testableNumLabel.text!) ?? 0) == 0 {
            let alert = UIAlertController(title: "알림", message: "가능한 문제가 없습니다. 문제가 들어있는 노트를 선택해주세요!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            alert.addAction(okAction)
            // 알림창 띄우기
            present(alert, animated: true, completion: nil)
        }
        
        if (Int(wantTextField.text!) ?? 0) == 0 {
            let alert = UIAlertController(title: "알림", message: "풀고 싶은 문제 수를 1개 이상 입력해주세요!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            alert.addAction(okAction)
            // 알림창 띄우기
            present(alert, animated: true, completion: nil)
        }
        
        if isTime {
            DataManager.shared.testQuestionList = DataManager.shared.questionListToDate
            DataManager.shared.nowQAmount = DataManager.shared.questionListToDate.count
            for i in 0...3 {
                if timeBoolList[i] {
                    DataManager.shared.noteAmount = -i
                    break
                }
            }
        } else {
            DataManager.shared.testQuestionList.removeAll()
            DataManager.shared.noteAmount = 0
            for i in 0..<DataManager.shared.backPackList.count {
                // 일단, 백팩단위로 노트 패치해주시고요
                //DataManager.shared.fetchNote(backPackName: DataManager.shared.backPackList[i].name)
                for j in 0..<DataManager.shared.noteList[i].count {
                    // 체크한
                    if bpBoolList[i][j] == true {
                        DataManager.shared.nowBackPackName = DataManager.shared.backPackList[i].name
                        DataManager.shared.nowNoteName = DataManager.shared.noteList[i][j].name
                        DataManager.shared.fetchQuestion()
                        DataManager.shared.testQuestionList += DataManager.shared.questionList
                        DataManager.shared.noteAmount! += 1
                    }
                }
            }
            DataManager.shared.nowQAmount = Int(wantTextField.text!) ?? 0
        }
        navigationController?.pushViewController(TimerViewController(), animated: true)
    }
    
}

extension TestSettingViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if isTime {
            return 1
        } else {
            return DataManager.shared.backPackList.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isTime { return 4}
        if DataManager.shared.backPackList[section].opened == true {
            return Int(DataManager.shared.backPackList[section].numberOfNote) + 1
        } else {
            return 1
        }
        //return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isTime {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell", for: indexPath) as! TimeCell
            cell.mappingData(index: indexPath.row, isCheck: timeBoolList[indexPath.row])
            return cell
        }
        if(indexPath.row == 0) { // 가방일경우
            // DataManager.shared.fetchNote(backPackName: DataManager.shared.backPackList[indexPath.section].name, index: <#Int#>)
            // bool list 관리 (생성)
            bpBoolList.append(Array(repeating: false, count: DataManager.shared.noteList[indexPath.section].count))
            
            let backPackCell = tableView.dequeueReusableCell(withIdentifier: "BackPackCell_Test", for: indexPath) as! BackPackCell_Test// cell이라는 아이덴티파이어를 가진 놈으로 셀 생성(디자인부분)
            backPackCell.mappingData(index: indexPath.section)
            return backPackCell
        } else { // 노트일경우
            let noteCell = tableView.dequeueReusableCell(withIdentifier: "NoteCell_Test", for: indexPath) as! NoteCell_Test
            noteCell.mappingData(indexPath: indexPath, isCheck: bpBoolList[indexPath.section][indexPath.row - 1])
            return noteCell
        }
        // 나중에 선택할 경우 체크 표시로 바꾸기 위한 체크상태 색 변경 cell.selectedBackgroundView = bgColorView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isTime {
            for i in 0...3 {
                if indexPath.row == i {
                    timeBoolList[i] = true
                    switch i {
                    case 0:
                        DataManager.shared.fetchQuestionToDate(second: 604800)
                    case 1:
                        DataManager.shared.fetchQuestionToDate(second: 604800 * 2)
                    case 2:
                        DataManager.shared.fetchQuestionToDate(second: Int(2.628e+6))
                    case 3:
                        DataManager.shared.fetchQuestionToDate(second: -1)
                    default:
                        print("isTime for timeBoolList error")
                    }
                    testableNumLabel.text = String(DataManager.shared.questionListToDate.count)
                } else {
                    timeBoolList[i] = false
                }
            }
            tableView.reloadData()
            return
        }
        if indexPath.row == 0 { // 가방 선택
            DataManager.shared.backPackList[indexPath.section].opened.toggle()
            let sections = IndexSet.init(integer: indexPath.section)

            // 어째선지 cellForRowAt으로 넘어갈때 선택한 섹션번호랑 섹션이가진 "row수"가 넘어감;
            // 그래서 row == 0 으로 노트를 갱신하던게 안되서 여기서 갱신해주자 ^_^;
            // DataManager.shared.fetchNote(backPackName: DataManager.shared.backPackList[indexPath.section].name)
            tableView.reloadSections(sections, with: .none)
            tableView.cellForRow(at: indexPath)?.isSelected = false // 가방 선택 안되도록하기
            
            // 가방을 여는 경우, 기존에 선택되있던 노트 선택하기
            if DataManager.shared.backPackList[indexPath.section].opened == true {
                if !bpBoolList[indexPath.section].isEmpty {
                    for i in 1...bpBoolList[indexPath.section].count {
                        if bpBoolList[indexPath.section][i - 1] == true {
                            tableView.selectRow(at: IndexPath(row: i, section: indexPath.section), animated: true, scrollPosition: .top)
                        }
                    }
                }
            }
        } else { // 노트 선택
            let selectedCell = tableView.cellForRow(at: indexPath) as! NoteCell_Test
            // 가능한 문제 수 설정
            if bpBoolList[indexPath.section][indexPath.row - 1] {
                testableNumLabel.text = String((Int(testableNumLabel.text!) ?? 0) - Int(DataManager.shared.noteList[indexPath.section][indexPath.row - 1].numberOfQ))
                selectedCell.checkImage.isHidden = true
            } else {
                testableNumLabel.text = String((Int(testableNumLabel.text!) ?? 0) + Int(DataManager.shared.noteList[indexPath.section][indexPath.row - 1].numberOfQ))
                selectedCell.checkImage.isHidden = false
            }
            bpBoolList[indexPath.section][indexPath.row - 1].toggle()
        }
    }
}

extension TestSettingViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {// 캬 완벽~
        if Int(textField.text!) ?? 0 > Int(testableNumLabel.text!) ?? 0 {
            textField.text = testableNumLabel.text!
        }
        textField.text = String(Int(textField.text!) ?? 0)
    }
}
