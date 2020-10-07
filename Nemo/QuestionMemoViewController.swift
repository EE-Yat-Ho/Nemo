//
//  QuestionMemoViewController.swift
//  BrainSupporter2
//
//  Created by 박영호 on 2020/07/07.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit
import SwiftUI

class QuestionMemoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var questionOpened:Bool? = false
    var memoOpened:Bool? = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationItem.title = DataManager.shared.nowNoteName
        // 테이블 섹션 없는 곳에 seperator 없애기
        self.tableView.tableFooterView = UIView()
    }
    
    // + 눌렀을때 팝업창 띄우기
    @IBAction func showPopUp(_ sender: Any) {
        //20200716 와 액션시트 알게되서 쓸모없게됨;;
//        let popOverVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopupViewController_QM") as! PopUpViewController
//        self.addChild(popOverVC)
//        popOverVC.view.frame = self.view.frame
//        self.view.addSubview(popOverVC.view)
//        popOverVC.didMove(toParent: self)
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let addQuestionAction = UIAlertAction(title: "문제 만들기", style: .default){[weak self] (action) in
            //self?.tabBarController?.tabBar.isHidden = true
            //self?.tabBarController?.tabBar.layer.zPosition = -1
            //self?.tabBarController?.tabBar.items?[0].isEnabled = false
            //self?.tabBarController?.tabBar.items?[1].isEnabled = false
            self?.tabBarController?.tabBar.alpha = 0 //와아ㅏ아아아ㅏㅇㅇ
            let questionTabBarController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QuestionTabBarController") as! QuestionTabBarController
            self?.navigationController?.pushViewController(questionTabBarController, animated: true)
            //let vc = self?.storyboard?.instantiateViewController(withIdentifier: "QuestionTabBarController") as! QuestionTabBarController
            //self?.present(vc, animated: true, completion: nil)
        }
        alert.addAction(addQuestionAction)
        let addMemoAction = UIAlertAction(title: "메모 만들기", style: .default){[weak self] (action) in
            let makeMemoViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MakeMemoViewController") as! MakeMemoViewController
            self?.navigationController?.pushViewController(makeMemoViewController, animated: true)
            
        }
        alert.addAction(addMemoAction)
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) { // 화면이 전환 될때(나타날때) 호출
        super.viewWillAppear(animated)
        
        // 넘어온 지금의 가방과 노트정보가 있으니 문제랑 메모 인출
        DataManager.shared.fetchQuestion()
        DataManager.shared.fetchMemo()
        tabBarController?.tabBar.alpha = 1
        tableView.reloadData() // 배열 데이터로 뷰를 업데이트함
    }

    // 20200712 토큰 나중에 생각 ㄱ
//    var token: NSObjectProtocol? // 옵저버 해제할때 쓸 객체 보통 토큰이라 부름
//
//    // 소멸자에서 토큰을 이용하여 옵저버 해제
//    deinit {
//        if let token = token {
//            NotificationCenter.default.removeObserver(token)
//        }
//    }
    
    @IBOutlet weak var tableView: UITableView!
    // MARK: - Table view data source
    
    //섹션 수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //섹션당 로우 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            if questionOpened == true { // 열려있으면 문제수 + 1
                return DataManager.shared.questionList.count + 1
            }
        } else {
            if memoOpened == true {
                return DataManager.shared.memoList.count + 1
            }
        } // 닫혀있으면 그냥 1이지 ㅇㅇ
        return 1
    }
        
    // 가장 중요한 메소드
    // 셀을 가져와서 필요한 데이터를 채운 뒤 리턴하는 메소드
    // 테이블 뷰에게 어떤 디자인으로 어떤 데이터를 표시하면 되는지 알려주는 부분
    // 셀 하나당 한번씩 호출. indexPath로 목록내의 해당 순서의 셀을 접근
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 { // 문제들
            if indexPath.row == 0 {
                let questionOpenCell = self.tableView.dequeueReusableCell(withIdentifier: "questionOpenCell", for: indexPath) as! QuestionOpenCell// cell이라는 아이덴티파이어를 가진 놈으로 셀 생성(디자인부분)
                questionOpenCell.numberOfQuestion.text = String(DataManager.shared.questionList.count)
                if questionOpened == true {
                    questionOpenCell.leftDownImage.image = UIImage(named: "down")
                } else {
                    questionOpenCell.leftDownImage.image = UIImage(named: "left")
                }
                //questionOpenCell.leftDownImage.constraints.
                return questionOpenCell
            } else {
                let questionCell = self.tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) as! QuestionCell
                questionCell.questionName.text = DataManager.shared.questionList[indexPath.row - 1].question
                return questionCell
            }
        }
        else { // 메모들
            if indexPath.row == 0{
                let memoOpenCell = self.tableView.dequeueReusableCell(withIdentifier: "memoOpenCell", for: indexPath) as! MemoOpenCell
                memoOpenCell.numberOfMemo.text = String(DataManager.shared.memoList.count)
                if memoOpened == true {
                    memoOpenCell.leftDownImage.image = UIImage(named: "down")
                } else {
                    memoOpenCell.leftDownImage.image = UIImage(named: "left")
                }
                return memoOpenCell
            } else {
                let memoCell = self.tableView.dequeueReusableCell(withIdentifier: "memoCell", for: indexPath) as! MemoCell
                memoCell.memoContent.text = DataManager.shared.memoList[indexPath.row - 1].content
                return memoCell
            }
        }
    }
    
    // 눌러졌을때 할일
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 { // 문제보기, 메모보기 눌러짐
            if indexPath.section == 0 { // 문제보기 눌러짐
                questionOpened?.toggle()
            } else { // 메모보기 눌러짐
                memoOpened?.toggle()
            }
            let sections = IndexSet.init(integer: indexPath.section) // 아 바로 밑에쓰이니 지우지말라고 ㅋㅋ
            tableView.reloadSections(sections, with: .none)
        } else {
            if indexPath.section == 0 { // 문제
                self.tabBarController?.tabBar.alpha = 0 //와아ㅏ아아아ㅏㅇㅇ
                let questionTabBarController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QuestionTabBarController") as! QuestionTabBarController
                questionTabBarController.editTarget = DataManager.shared.questionList[indexPath.row - 1]
                self.navigationController?.pushViewController(questionTabBarController, animated: true)
            } else { // 메모
                let makeMemoViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MakeMemoViewController") as! MakeMemoViewController
                makeMemoViewController.editTarget = DataManager.shared.memoList[indexPath.row - 1]
                self.navigationController?.pushViewController(makeMemoViewController, animated: true)
            }
        }
    }

    // 우측 상단 버튼 조정
    @IBAction func ClickEditButton(_ sender: UIButton) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            //tableView.separatorInset.left = 55
            sender.setTitle("", for: .normal)
            sender.setImage(UIImage(named: "편집 복사본"), for: .normal)
        } else {
            tableView.setEditing(true, animated: true)
            //tableView.separatorInset.left = 100
            sender.setTitle("완료", for: .normal)
            sender.setImage(nil, for: .normal)
        }
    }


    //순서바꾸기 허용
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool{
        return true;
    }

    //순서바꿀때 배열이랑 디비 조정
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath){
        if sourceIndexPath.row == 0 { // 오픈메뉴를 옮긴 경우
            
        } else { // 노트를 옮긴 경우
            // 노트들의 row값은 맨 위 가방의 row 0 때문에 1 커서 1 빼줘야함
            var ModifiedDestinationIndexPathRow = destinationIndexPath.row - 1
            let ModifiedSourceIndexPathRow = sourceIndexPath.row - 1
            var ModifiedDestinationIndexPathSection = destinationIndexPath.section
            
            // 노트를 가방에 얹을 경우(row == 0) 위 가방의 맨 밑이라고 생각. 단, 맨위 가방일 경우 조심
            if destinationIndexPath.row == 0 { // 오픈메뉴 위에 얹었다
                if destinationIndexPath.section == 0 { // 근데 맨 위에 문제보기에 얹었네?
                    ModifiedDestinationIndexPathRow = 0 // row값 -1에서 0으로 수정해주기
                } else { // 메모보기 위에 얹은 경우. 문제보기의 맨 밑으로 생각하기
                    ModifiedDestinationIndexPathSection -= 1 // 1 => 0으로 문제보기로 되고
                    ModifiedDestinationIndexPathRow = Int(DataManager.shared.questionList.count) // 젤 아래
                }
            }
            if sourceIndexPath.section == 0 && destinationIndexPath.section == 1 { // 문제들에서 보기들로 내려버린 경우
                ModifiedDestinationIndexPathSection = 0 // 위 섹션으로 고쳐버리고
                ModifiedDestinationIndexPathRow = Int(DataManager.shared.questionList.count) // 젤 밑으로 봄
            } else if sourceIndexPath.section == 1 && destinationIndexPath.section == 0 { // 보기들에서 문제로 올려버린 경우
                ModifiedDestinationIndexPathSection = 1 // 아래 섹션으로 고쳐버리고
                ModifiedDestinationIndexPathRow = 0 // 맨 위라고 봄
            }
            
            
            if sourceIndexPath.section == ModifiedDestinationIndexPathSection { // 한 섹션 안에서 옮긴 경우
                if sourceIndexPath.section == 0 { // 문제 보기에서 옮김
                    let target = DataManager.shared.questionList[ModifiedSourceIndexPathRow] // 노트들의 row값은 맨위의 가방때문에 인덱스보다 1 큼
                    DataManager.shared.questionList.remove(at: ModifiedSourceIndexPathRow) // 원래자리에서 지우고
                    DataManager.shared.questionList.insert(target, at: ModifiedDestinationIndexPathRow) // 새로운 자리에 넣어줌
                    if ModifiedSourceIndexPathRow < ModifiedDestinationIndexPathRow { // 원래자리와 새로운 자리 사이에 있는 애들 전부 리오더링
                        for i in ModifiedSourceIndexPathRow...ModifiedDestinationIndexPathRow {
                            DataManager.shared.questionList[i].order = Int16(DataManager.shared.questionList.count - i - 1)
                        }
                    } else {
                        for i in ModifiedDestinationIndexPathRow...ModifiedSourceIndexPathRow {
                            DataManager.shared.questionList[i].order = Int16(DataManager.shared.questionList.count - i - 1)
                        }
                    }
                } else { // 메모 보기에서 옮김
                    let target = DataManager.shared.memoList[ModifiedSourceIndexPathRow] // 노트들의 row값은 맨위의 가방때문에 인덱스보다 1 큼
                    DataManager.shared.memoList.remove(at: ModifiedSourceIndexPathRow) // 원래자리에서 지우고
                    DataManager.shared.memoList.insert(target, at: ModifiedDestinationIndexPathRow) // 새로운 자리에 넣어줌
                    if ModifiedSourceIndexPathRow < ModifiedDestinationIndexPathRow { // 원래자리와 새로운 자리 사이에 있는 애들 전부 리오더링
                        for i in ModifiedSourceIndexPathRow...ModifiedDestinationIndexPathRow {
                            DataManager.shared.memoList[i].order = Int16(DataManager.shared.memoList.count - i - 1)
                        }
                    } else {
                        for i in ModifiedDestinationIndexPathRow...ModifiedSourceIndexPathRow {
                            DataManager.shared.memoList[i].order = Int16(DataManager.shared.memoList.count - i - 1)
                        }
                    }
                }
                DataManager.shared.saveContext()
            }
        }
        tableView.reloadData()
    }

    //삭제 구현
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle{
        if indexPath.row == 0 {
            return .none
        }
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete { //위에서 리턴한 딜리트 스타일을 처리하는 부분
            if indexPath.row == 0 { // 가방을 삭제하는 경우
                
            } else { // 노트를 삭제하는 경우
                let alert = UIAlertController(title: "알림", message: "정말 삭제하시겠습니까?", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default){ [weak self] (action) in
                    // 확인 눌렀을 때 하는 소스
                    if indexPath.section == 0 { // 문제 삭제
                        let target = DataManager.shared.questionList[indexPath.row - 1]
                        DataManager.shared.questionList.remove(at: indexPath.row - 1)
                        for i in 0..<indexPath.row - 1{
                           DataManager.shared.questionList[i].order = Int16(DataManager.shared.questionList.count - i - 1)
                        }
                        // 노트에서 문제 수 하나 빼기
                        for i in DataManager.shared.noteList{
                            if i.name == DataManager.shared.nowNoteName{
                                i.numberOfQ -= 1
                            }
                        }
                        // 디비에서 노트 삭제
                        DataManager.shared.deleteQuestion(target)
                    } else { // 메모 삭제
                        let target = DataManager.shared.memoList[indexPath.row - 1]
                        DataManager.shared.memoList.remove(at: indexPath.row - 1)
                        for i in 0..<indexPath.row - 1{
                           DataManager.shared.memoList[i].order = Int16(DataManager.shared.memoList.count - i - 1)
                        }
                        // 노트에서 문제 수 하나 빼기
                        for i in DataManager.shared.noteList{
                            if i.name == DataManager.shared.nowNoteName{
                                i.numberOfM -= 1
                            }
                        }
                        // 디비에서 노트 삭제
                        DataManager.shared.deleteMemo(target)
                    }
                   
                    tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: indexPath.section)], with: .fade)
                    tableView.reloadRows(at: [IndexPath(row: 0, section:indexPath.section)], with: .fade)
                }
                alert.addAction(okAction)
                let cancelAction = UIAlertAction(title: "취소", style: .cancel){ [weak self] (action) in
                    // 취소 눌렀을 때 하는 소스
                    // 암거도 안함 22
                }
                alert.addAction(cancelAction)
                // 알림창 띄우기
                present(alert, animated: true, completion: nil)
            }
        } else if editingStyle == .insert {
        }
    }
    
//    var memo: Memo?
//    var question: Question?
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // 네비게이션 컨트롤러가 관리하는 첫번째 뷰 컨트롤러로 메모가 전달된데요. 그 첫번째 뷰 컨트롤러는 바로 컴포즈 뷰 컨트롤러!
//        if let vc = segue.destination.children.first as? MakeMemoViewController {
//            vc.editTarget = memo
//        }
//        if let vc = segue.destination.children.first as? MakeSubjectiveQuestionViewController {
//            vc.editTarget = question
//        }
//        if let vc = segue.destination.children.first as? MakeMultipleChoiceQuestionViewController {
//            vc.editTarget = question
//        }
//    }
}
