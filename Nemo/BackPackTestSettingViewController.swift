//
//  BackPackTestSettingViewController.swift
//  BrainSupporter2
//
//  Created by 박영호 on 2020/07/31.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class BackPackTestSettingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var testableQuestionLabel: UILabel!
    @IBOutlet weak var testableQuestionNumLabel: UILabel!
    @IBOutlet weak var wantTestQuestionLabel: UILabel!
    @IBOutlet weak var wantTestQuestionTextField: UITextField!
    @IBOutlet weak var testReadyButton: UIButton!
    //var testableQuestionNum: Int! = 0
    //var wantTestQuestionNum: Int! = 0
    var boolListForCheck = [[Bool]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "배경")!)
        
        tableView.delegate = self
        tableView.dataSource = self
        // 테이블 섹션 없는 곳에 seperator 없애기
        self.tableView.tableFooterView = UIView()
        // 테이블 테두리 설정
        tableView.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        tableView.layer.borderWidth = 1.0
        tableView.layer.cornerRadius = 5.0
        // 상단 4개 컨텐츠 테두리 설정
        testableQuestionLabel.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        testableQuestionLabel.layer.borderWidth = 1.0
        testableQuestionLabel.layer.cornerRadius = 5.0
        testableQuestionLabel.layer.masksToBounds = true
        testableQuestionNumLabel.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        testableQuestionNumLabel.layer.borderWidth = 1.0
        testableQuestionNumLabel.layer.cornerRadius = 5.0
        testableQuestionNumLabel.layer.masksToBounds = true
        wantTestQuestionLabel.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        wantTestQuestionLabel.layer.borderWidth = 1.0
        wantTestQuestionLabel.layer.cornerRadius = 5.0
        wantTestQuestionLabel.layer.masksToBounds = true
        wantTestQuestionTextField.layer.borderColor = UIColor.systemBlue.cgColor
        wantTestQuestionTextField.layer.borderWidth = 1.0
        wantTestQuestionTextField.layer.cornerRadius = 5.0
        wantTestQuestionTextField.layer.masksToBounds = true
        // 시험 준비 버튼 테두리 설정
        testReadyButton.layer.borderColor = UIColor.systemBlue.cgColor
        testReadyButton.layer.borderWidth = 1.0
        testReadyButton.layer.cornerRadius = 5.0
        testReadyButton.layer.masksToBounds = true
        // 가능한 문제 수 설정
        testableQuestionNumLabel.text = "0"
        // 풀고싶은 문제 수 설정
        wantTestQuestionTextField.text = "0"
        // delegate
        wantTestQuestionTextField.delegate = self
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return DataManager.shared.backPackList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if DataManager.shared.backPackList.count > 0 {
            if DataManager.shared.backPackList[section].opened == true {
                return Int(DataManager.shared.backPackList[section].numberOfNote) + 1
            } else {
                return 1
            }
        }
        // 일단 걍 다 열어놓죠 ㅎㅎ; ㄴㄴ
        // return Int(DataManager.shared.backPackList[section].numberOfNote) + 1
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0) { // 가방일경우
            DataManager.shared.fetchNote(backPackName: DataManager.shared.backPackList[indexPath.section].name)
            // bool list 관리 (생성)
            boolListForCheck.append(Array(repeating: false, count: DataManager.shared.noteList.count))
            
            let backPackCell = self.tableView.dequeueReusableCell(withIdentifier: "backPackCell", for: indexPath) as! BackPackCell// cell이라는 아이덴티파이어를 가진 놈으로 셀 생성(디자인부분)
            backPackCell.backPackName.text = DataManager.shared.backPackList[indexPath.section].name
            backPackCell.numberOfNote.text = String(DataManager.shared.backPackList[indexPath.section].numberOfNote)
            if DataManager.shared.backPackList[indexPath.section].opened == true {
                backPackCell.rightImage.image = UIImage(named: "down")
            } else {
                backPackCell.rightImage.image = UIImage(named: "left")
            }
            return backPackCell
        } else { // 노트일경우
            let noteCell = self.tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteCell
            noteCell.noteName.text = DataManager.shared.noteList[indexPath.row - 1].name
            noteCell.numberOfQuestion.text = String(DataManager.shared.noteList[indexPath.row - 1].numberOfQ)
            noteCell.numberOfMemo.text = String(DataManager.shared.noteList[indexPath.row - 1].numberOfM)
            noteCell.isSelected = true // 이거 왜 안먹음?...
            return noteCell
        }
        // 나중에 선택할 경우 체크 표시로 바꾸기 위한 체크상태 색 변경 cell.selectedBackgroundView = bgColorView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 { // 가방 선택
            DataManager.shared.backPackList[indexPath.section].opened.toggle()
            let sections = IndexSet.init(integer: indexPath.section)

            // 어째선지 cellForRowAt으로 넘어갈때 선택한 섹션번호랑 섹션이가진 "row수"가 넘어감;
            // 그래서 row == 0 으로 노트를 갱신하던게 안되서 여기서 갱신해주자 ^_^;
            DataManager.shared.fetchNote(backPackName: DataManager.shared.backPackList[indexPath.section].name)
            tableView.reloadSections(sections, with: .none)
            tableView.cellForRow(at: indexPath)?.isSelected = false // 가방 선택 안되도록하기
            
            // 가방을 여는 경우, 기존에 선택되있던 노트 선택하기
            if DataManager.shared.backPackList[indexPath.section].opened == true {
                for i in 1...boolListForCheck[indexPath.section].count {
                    if boolListForCheck[indexPath.section][i - 1] == true {
                        tableView.selectRow(at: IndexPath(row: i, section: indexPath.section), animated: true, scrollPosition: .top)
                    }
                }
            }
        } else { // 노트 선택
            let selectedCell = tableView.cellForRow(at: indexPath) as! NoteCell
            // 가능한 문제 수 설정
            testableQuestionNumLabel.text = String((Int(testableQuestionNumLabel.text!) ?? 0) + (Int(selectedCell.numberOfQuestion.text!) ?? 0))
            boolListForCheck[indexPath.section][indexPath.row - 1] = true
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 { //가방 선택해제부분
            //for i in
        } else { // 노트 선택
            let selectedCell = tableView.cellForRow(at: indexPath) as! NoteCell
            // 가능한 문제 수 설정
            testableQuestionNumLabel.text = String((Int(testableQuestionNumLabel.text!) ?? 0) - (Int(selectedCell.numberOfQuestion.text!) ?? 0))
            boolListForCheck[indexPath.section][indexPath.row - 1] = false
            if Int(testableQuestionNumLabel.text!) ?? 0 < Int(wantTestQuestionTextField.text!) ?? 0 {
                wantTestQuestionTextField.text = testableQuestionNumLabel.text
            }
        }
    }
    
    @IBAction func ClickTestReadyButton(_ sender: Any) {
        if (Int(testableQuestionNumLabel.text!) ?? 0) == 0 {
            let alert = UIAlertController(title: "알림", message: "가능한 문제가 없습니다. 문제가 들어있는 노트를 선택해주세요!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            alert.addAction(okAction)
            // 알림창 띄우기
            present(alert, animated: true, completion: nil)
        }
        
        if (Int(wantTestQuestionTextField.text!) ?? 0) == 0 {
            let alert = UIAlertController(title: "알림", message: "풀고 싶은 문제 수를 1개 이상 입력해주세요!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            alert.addAction(okAction)
            // 알림창 띄우기
            present(alert, animated: true, completion: nil)
        }
        
        DataManager.shared.testQuestionList.removeAll()
        DataManager.shared.noteAmount = 0
        for i in 0..<DataManager.shared.backPackList.count {
            // 일단, 백팩단위로 노트 패치해주시고요
            DataManager.shared.fetchNote(backPackName: DataManager.shared.backPackList[i].name)
            for j in 0..<DataManager.shared.noteList.count {
                // 체크한
                if boolListForCheck[i][j] == true {
                    DataManager.shared.nowBackPackName = DataManager.shared.backPackList[i].name
                    DataManager.shared.nowNoteName = DataManager.shared.noteList[j].name
                    DataManager.shared.fetchQuestion()
                    DataManager.shared.testQuestionList += DataManager.shared.questionList
                    DataManager.shared.noteAmount! += 1
                }
            }
        }
        
        DataManager.shared.nowQAmount = Int(wantTestQuestionTextField.text!) ?? 0
    }
}

extension BackPackTestSettingViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {// 캬 완벽~
        if Int(textField.text!) ?? 0 > Int(testableQuestionNumLabel.text!) ?? 0 {
            textField.text = testableQuestionNumLabel.text!
        }
        textField.text = String(Int(textField.text!) ?? 0)
    }
}
