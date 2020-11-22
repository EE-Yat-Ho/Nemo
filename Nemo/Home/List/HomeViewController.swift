//
//  HomeViewController.swift
//  BrainSupporter2
//
//  Created by 박영호 on 2020/06/23.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit
import SwiftUI
import SnapKit
import Then
import RxSwift
import RxCocoa
import NSObject_Rx
// 헛짓하지말고 옵저버블로 해결하자 ㄱ

class HomeViewController: UIViewController {
    var tableViewEditMode = false
    let emptyImage = UIImageView().then {
        $0.image = UIImage(named: "가방")
    }
    let emptyLabel = UILabel().then {
        $0.text = "가방을 만들어주세요"
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 24)
    }
    let tableView = UITableView().then {
        $0.register(NoteCell.self, forCellReuseIdentifier: "NoteCell")
        $0.register(BackPackCell.self, forCellReuseIdentifier: "BackPackCell")
        $0.tableFooterView = UIView()
    }
    var titleLabel = UILabel().then{
        $0.text = "가방"
        $0.font = UIFont(name: "NotoSansKannada-Bold", size: 34)
    }
    var addButton = UIButton().then{
        $0.setImage(UIImage(named: "가방만들기"), for: .normal)
        $0.addTarget(self, action: #selector(showPopup), for: .touchUpInside)
    }
    lazy var editButton = UIBarButtonItem(image: UIImage(named: "기본아이콘_편집"), style: .plain, target: self, action: #selector(clickEditButton))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupLayout()
        bindingData()
        
        AppInit()
        // 폰트 이름 확인하기
//        for name in UIFont.familyNames {
//            print(name)
//            if let nameString = name as? String
//            {
//                print(UIFont.fontNames(forFamilyName: nameString))
//            }
//        }
    }
    
    func AppInit() {
        // 
        NotificationManager.shared.synchNotiAuth()
        
        //첫 실행시 할 것들
        if UserDefaults.standard.bool(forKey: "didLaunched") == false {
            NotificationManager.shared.getAuthorization()
            NotificationManager.shared.setNotiTime(hour:21, minute:0)
            NotificationManager.shared.setNotification()
            
            /// 권한창에서 선택안하고 껏을 경우, 값이 비어있지않게 하기 위한 조치.
            UserDefaults.standard.setValue(false, forKey: "notiAuth")
            
            UserDefaults.standard.setValue(true, forKey: "didLaunched")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) { // 화면이 전환 될때(나타날때) 호출
        super.viewWillAppear(animated)
        tableView.reloadData() // 배열 데이터로 뷰를 업데이트함
    }
    
    func bindingData() {
        DataManager.shared.homeViewTableReloadTrigger
            .bind(onNext: {[weak self] in
                    self?.tableView.reloadData()})
            .disposed(by: rx.disposeBag)
    }
    
    func setupLayout() {
        view.backgroundColor = UIColor(patternImage: UIImage(named: "배경")!)
        tableView.separatorColor = UIColor.clear
        tableView.backgroundColor = UIColor.clear
        
        // 네비게이션 레이아웃
        navigationItem.rightBarButtonItem = editButton
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        
        // 탭바 레이아웃
        tabBarController?.tabBar.backgroundImage = UIImage(named: "배경")
        let fontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0)]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
        
        // 가방 없을 경우 띄우는거
        view.addSubview(emptyImage)
        view.addSubview(emptyLabel)
        emptyImage.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-30)
            $0.height.width.equalTo(80)
        }
        emptyLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(emptyImage.snp.bottom).offset(20)
        }
        
        // 나머지
        view.addSubview(tableView)
        view.addSubview(titleLabel)
        view.addSubview(addButton)
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        tableView.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom)
        }
        
        addButton.snp.makeConstraints{
            $0.width.equalTo(120)
            $0.height.equalTo(60)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
        }
    }
    
    
    
    // +버튼 눌렀을 때 가방, 노트 만드는 액션시트 띄우는 함수
    @objc func showPopup() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let addBackPackAction = UIAlertAction(title: "가방 만들기", style: .default){[weak self] (action) in
            let vc = MakeBackPackViewController()
            self?.present(vc, animated: true)
        }
        alert.addAction(addBackPackAction)
        let addNoteAction = UIAlertAction(title: "노트 만들기", style: .default){[weak self] (action) in
            self?.present(MakeNoteViewController(), animated: true)
        }
        alert.addAction(addNoteAction)
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

    @IBAction func clickEditButton() {
        if tableView.isEditing { // 정상 상태로
            tableView.setEditing(false, animated: true)
            editButton.title = ""
            editButton.image = UIImage(named: "기본아이콘_편집")
            tableViewEditMode = false
        } else { // 편집 모드로
            tableView.setEditing(true, animated: true)
            editButton.title = "완료"
            editButton.image = nil
            tableViewEditMode = true
        }
        tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        DataManager.shared.fetchBackPack() // 디비에서 배열로 데이터를 가져옴
        DataManager.shared.noteList = [[Note]]()
        for (index, element) in DataManager.shared.backPackList.enumerated() {
            DataManager.shared.noteList.append([Note]())
            DataManager.shared.fetchNote(backPackName: element.name, index: index)
        }
        
        if DataManager.shared.backPackList.count > 0 {
            titleLabel.isHidden = false
            emptyImage.isHidden = true
            emptyLabel.isHidden = true
        } else {
            titleLabel.isHidden = true
            emptyImage.isHidden = false
            emptyLabel.isHidden = false
        }
        return DataManager.shared.backPackList.count
    }
    //테이블 뷰에게 몇개의 셀을 표시하면 되는지 알려주는 부분
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        // 20200621 #18 DB구현에서 대체 return Memo.dummyMemoList.count
        if DataManager.shared.backPackList.count > 0 {
            if(DataManager.shared.backPackList[section].opened == true){
                return Int(DataManager.shared.backPackList[section].numberOfNote) + 1
            } else {
                return 1
            }
        }
        //아무것도 없을때네 이때 로고하면 처리하면 될듯 ㅇㅅㅇ
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0) { // 가방일경우
            let backPackCell = self.tableView.dequeueReusableCell(withIdentifier: "BackPackCell", for: indexPath) as! BackPackCell// cell이라는 아이덴티파이어를 가진 놈으로 셀 생성(디자인부분)
            backPackCell.mappingData(index: indexPath.section, editMode: tableViewEditMode)
            
            return backPackCell
        } else { // 노트일경우
            let noteCell = self.tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteCell
            noteCell.mappingData(indexPath: indexPath, editMode: tableViewEditMode)
            
            return noteCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 { // 가방 선택
            DataManager.shared.backPackList[indexPath.section].opened.toggle()
            let sections = IndexSet.init(integer: indexPath.section)
            
            // 어째선지 cellForRowAt으로 넘어갈때 선택한 섹션번호랑 섹션이가진 "row수"가 넘어감;
            // 그래서 row == 0 으로 노트를 갱신하던게 안되서 여기서 갱신해주자 ^_^;
            tableView.reloadSections(sections, with: .none)
        } else { // 노트 선택
            DataManager.shared.nowBackPackName = DataManager.shared.backPackList[indexPath.section].name
            //DataManager.shared.fetchNote(backPackName: DataManager.shared.backPackList[indexPath.section].name)
            DataManager.shared.nowNoteName = DataManager.shared.noteList[indexPath.section][indexPath.row - 1].name

            DataManager.shared.nowBPN = indexPath
            
            let noteVC = QuestionMemoViewController()
            navigationController?.pushViewController(noteVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }

    //순서바꾸기 허용
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool{
        return true;
    }
    
    //순서바꿀때 배열이랑 디비 조정
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath){
        if sourceIndexPath.row == 0 { // 가방을 옮긴 경우
            let target = DataManager.shared.backPackList[sourceIndexPath.section]
            DataManager.shared.backPackList.remove(at: sourceIndexPath.section) // 원래자리에서 지우고
            DataManager.shared.backPackList.insert(target, at: destinationIndexPath.section) // 새로운 자리에 넣어줌
            if sourceIndexPath.section < destinationIndexPath.section { // 원래자리와 새로운 자리 사이에 있는 애들 전부 리오더링
                for i in sourceIndexPath.section...destinationIndexPath.section {
                    DataManager.shared.backPackList[i].order = Int16(DataManager.shared.backPackList.count - i - 1)
                }
            } else {
                for i in destinationIndexPath.section...sourceIndexPath.section {
                    DataManager.shared.backPackList[i].order = Int16(DataManager.shared.backPackList.count - i - 1)
                }
            }
            //아니 배열만 고치고 세이브하면 되는거였냐고 이걸..ㅠ
            DataManager.shared.saveContext()
        } else { // 노트를 옮긴 경우
            // 노트들의 row값은 맨 위 가방의 row 0 때문에 1 커서 1 빼줘야함
            var ModifiedDestinationIndexPathRow = destinationIndexPath.row - 1
            let ModifiedSourceIndexPathRow = sourceIndexPath.row - 1
            var ModifiedDestinationIndexPathSection = destinationIndexPath.section

            // 노트를 가방에 얹을 경우(row == 0) 위 가방의 맨 밑이라고 생각. 단, 맨위 가방일 경우 조심
            if destinationIndexPath.row == 0 { // 가방 위에 얹었다
                if destinationIndexPath.section == 0 { // 근데 맨 윗가방이네?
                    // 가방은 그냥 두고
                    ModifiedDestinationIndexPathRow = 0 // 어쨋든 가방 위니까 row값 -1에서 0으로 수정해주기
                } else { // 중간 가방인데 가방위에 얹은 경우!! 윗 가방의 맨 밑으로 생각하기
                    ModifiedDestinationIndexPathSection -= 1 // 윗 가방의
                    ModifiedDestinationIndexPathRow = Int(DataManager.shared.backPackList[destinationIndexPath.section - 1].numberOfNote) // 젤 아래
                }
            }

            if sourceIndexPath.section == ModifiedDestinationIndexPathSection { // 한 가방 안에서 옮긴 경우
                //DataManager.shared.fetchNote(backPackName: DataManager.shared.backPackList[sourceIndexPath.section].name)
                let target = DataManager.shared.noteList[sourceIndexPath.section][ModifiedSourceIndexPathRow] // 노트들의 row값은 맨위의 가방때문에 인덱스보다 1 큼
                DataManager.shared.noteList[sourceIndexPath.section].remove(at: ModifiedSourceIndexPathRow) // 원래자리에서 지우고
                DataManager.shared.noteList[sourceIndexPath.section].insert(target, at: ModifiedDestinationIndexPathRow) // 새로운 자리에 넣어줌
                if ModifiedSourceIndexPathRow < ModifiedDestinationIndexPathRow { // 원래자리와 새로운 자리 사이에 있는 애들 전부 리오더링
                    for i in ModifiedSourceIndexPathRow...ModifiedDestinationIndexPathRow {
                        DataManager.shared.noteList[sourceIndexPath.section][i].order = Int16(DataManager.shared.noteList[sourceIndexPath.section].count - i - 1)
                    }
                } else {
                    for i in ModifiedDestinationIndexPathRow...ModifiedSourceIndexPathRow {
                        DataManager.shared.noteList[sourceIndexPath.section][i].order = Int16(DataManager.shared.noteList[sourceIndexPath.section].count - i - 1)
                    }
                }
                DataManager.shared.saveContext()

            } else { // 다른 가방으로 노트를 옮긴 경우
                // 원래 가방에서 노트수 --, 노트 배열에서 제외, 순서 조정, 저장
                //DataManager.shared.fetchNote(backPackName: DataManager.shared.backPackList[sourceIndexPath.section].name)
                let target = DataManager.shared.noteList[sourceIndexPath.section][ModifiedSourceIndexPathRow]
                DataManager.shared.backPackList[sourceIndexPath.section].numberOfNote -= 1
                DataManager.shared.noteList[sourceIndexPath.section].remove(at: ModifiedSourceIndexPathRow) // 원래자리에서 지우고
                for i in 0..<ModifiedSourceIndexPathRow{
                    DataManager.shared.noteList[sourceIndexPath.section][i].order = Int16(DataManager.shared.noteList[sourceIndexPath.section].count - i - 1)
                }
                DataManager.shared.saveContext()

                // 새 가방에 노트수 ++, 노트의 가방 이름 바꾸기, 노트 배열에 추가, 순서 조정, 저장
                //DataManager.shared.fetchNote(backPackName: DataManager.shared.backPackList[ModifiedDestinationIndexPathSection].name)
                target.backPackName = DataManager.shared.backPackList[ModifiedDestinationIndexPathSection].name
                DataManager.shared.backPackList[ModifiedDestinationIndexPathSection].numberOfNote += 1
                DataManager.shared.noteList[ModifiedDestinationIndexPathSection].insert(target, at: ModifiedDestinationIndexPathRow) // 새로운 자리에 넣어줌
                for i in 0...ModifiedDestinationIndexPathRow{ // 추가한 경우에는 0~타겟이 아닌 타겟~끝까지 순서조정해줘야함
                    DataManager.shared.noteList[ModifiedDestinationIndexPathSection][i].order = Int16(DataManager.shared.noteList[ModifiedDestinationIndexPathSection].count - i - 1)
                }
                DataManager.shared.saveContext()
            }
        }
        tableView.reloadData()
    }

    //삭제 구현
    func tableView(_ tableView: UITableView, editingStyleForRowAt intdexPath: IndexPath) -> UITableViewCell.EditingStyle{
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete { //위에서 리턴한 딜리트 스타일을 처리하는 부분
            if indexPath.row == 0 { // 가방을 삭제하는 경우
                // 안에 있는 노트와 문제들이 다 삭제된다고 물어보기
                let alert = UIAlertController(title: "알림", message: "들어있는 노트와 문제, 메모가 삭제됩니다. 정말 삭제하시겠습니까?", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default){ [weak self] (action) in
                    // 확인 눌렀을 때 하는 소스
                    // 디비에서 노트 다 삭제
                    //DataManager.shared.fetchNote(backPackName: DataManager.shared.backPackList[indexPath.section].name)
                    for targetNote in DataManager.shared.noteList[indexPath.section] {
                        DataManager.shared.deleteNote(targetNote)
                    }

                    // 삭제할 가방 지정
                    let targetBackPack = DataManager.shared.backPackList[indexPath.section]

                    // 배열에서 가방 삭제
                    DataManager.shared.backPackList.remove(at: indexPath.section)

                    // 가방들 순서 조정
                    for i in 0..<indexPath.section{
                        DataManager.shared.backPackList[i].order = Int16(DataManager.shared.backPackList.count - i - 1)
                    }

                    // 디비에서 가방 삭제
                    DataManager.shared.deleteBackPack(targetBackPack)

                    // 테이블 뷰에서 섹션을 삭제하는 함수
                    tableView.deleteSections(IndexSet([indexPath.section]), with: .fade)
                }
                alert.addAction(okAction)
                let cancelAction = UIAlertAction(title: "취소", style: .cancel){ [weak self] (action) in
                    // 취소 눌렀을 때 하는 소스
                    // 암거도 안함 dd
                }
                alert.addAction(cancelAction)
                // 알림창 띄우기
                present(alert, animated: true, completion: nil)

            } else { // 노트를 삭제하는 경우
                // 안에 있는 문제들이 다 삭제된다고 물어보기
                let alert = UIAlertController(title: "알림", message: "들어있는 문제, 메모가 삭제됩니다. 정말 삭제하시겠습니까?", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default){ [weak self] (action) in
                    // 확인 눌렀을 때 하는 소스
                    // 노트 배열 로딩
                    //DataManager.shared.fetchNote(backPackName: DataManager.shared.backPackList[indexPath.section].name)
                    // 타겟 노트 지정
                    let targetNote = DataManager.shared.noteList[indexPath.section][indexPath.row - 1]
                    // 배열에서 노트 삭제
                    DataManager.shared.noteList[indexPath.section].remove(at: indexPath.row - 1)
                    // 노트들 순서 조정
                    for i in 0..<indexPath.row - 1{
                       DataManager.shared.noteList[indexPath.section][i].order = Int16(DataManager.shared.noteList[indexPath.section].count - i - 1)
                    }
                    // 가방에서 노트 수 하나 빼기
                    DataManager.shared.backPackList[indexPath.section].numberOfNote -= 1
                    // 디비에서 노트 삭제
                    DataManager.shared.deleteNote(targetNote)

                    tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: indexPath.section)], with: .fade)
                    tableView.reloadRows(at: [IndexPath(row: 0, section: indexPath.section)], with: .fade)
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
}
