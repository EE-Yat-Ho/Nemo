//
//  IncorrectNoteViewContoller.swift
//  Nemo
//
//  Created by 박영호 on 2020/11/17.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class IncorrectNoteViewContoller: UIViewController {
    let downArrow = UIImageView().then {
        $0.image = UIImage(named: "기본아이콘_펼치기")
    }
    let sortButton = UIButton().then {
        $0.setTitle("많이 틀린 순", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.addTarget(self, action: #selector(showPopup), for: .touchUpInside)
    }
    var tableView = UITableView().then {
        $0.register(IncorrectQuestionCell.self, forCellReuseIdentifier: "IncorrectQuestionCell")
        $0.backgroundColor = UIColor.clear
        $0.separatorColor = UIColor.clear
        $0.tableFooterView = UIView()
    }
    var titleLabel = UILabel().then{
        $0.text = "오답노트"
        $0.font = UIFont(name: "NotoSansKannada-Bold", size: 34)
    }
    lazy var editButton = UIBarButtonItem(image: UIImage(named: "기본아이콘_편집"), style: .plain, target: self, action: #selector(clickEditButton))
    var sortKey: SortKey = .failCount
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupLayout()
        //bindingData()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) { // 화면이 전환 될때(나타날때) 호출
        super.viewWillAppear(animated)
        DataManager.shared.fetchQuestionSort(key: .failCount)
        tableView.reloadData() // 배열 데이터로 뷰를 업데이트함
    }
    
//    func bindingData() {
//        DataManager.shared.homeViewTableReloadTrigger
//            .bind(onNext: {[weak self] in
//                    self?.tableView.reloadData()})
//            .disposed(by: rx.disposeBag)
//    }
    
    func setupLayout() {
        view.backgroundColor = UIColor(patternImage: UIImage(named: "배경")!)
        tableView.backgroundColor = UIColor.clear
        tableView.separatorColor = UIColor.clear
        
        navigationItem.rightBarButtonItem = editButton
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        
        view.addSubview(titleLabel)
        view.addSubview(sortButton)
        view.addSubview(downArrow)
        view.addSubview(tableView)
        
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        downArrow.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(25)
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(25)
        }
        sortButton.snp.makeConstraints{
            $0.centerY.equalTo(downArrow)
            $0.leading.equalTo(downArrow.snp.trailing).offset(5)
        }
        tableView.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(sortButton.snp.bottom).offset(10)
        }
    }
    
    // +버튼 눌렀을 때 가방, 노트 만드는 액션시트 띄우는 함수
    @objc func showPopup() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let addBackPackAction = UIAlertAction(title: "많이 틀린 순", style: .default){[weak self] (action) in
            self?.sortButton.setTitle("많이 틀린 순", for: .normal)
            DataManager.shared.fetchQuestionSort(key: .failCount)
            self?.sortKey = .failCount
            self?.tableView.reloadData()
        }
        alert.addAction(addBackPackAction)
        let addNoteAction = UIAlertAction(title: "최근에 틀린 순", style: .default){[weak self] (action) in
            self?.sortButton.setTitle("최근에 틀린 순", for: .normal)
            DataManager.shared.fetchQuestionSort(key: .failDate)
            self?.sortKey = .failDate
            self?.tableView.reloadData()
        }
        alert.addAction(addNoteAction)
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

    @objc func clickEditButton() {
        if tableView.isEditing { // 정상 상태로
            tableView.setEditing(false, animated: true)
            editButton.title = ""
            editButton.image = UIImage(named: "기본아이콘_편집")
        } else { // 편집 모드로
            tableView.setEditing(true, animated: true)
            editButton.title = "완료"
            editButton.image = nil
        }
        tableView.reloadData()
    }
}

extension IncorrectNoteViewContoller: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.sortQuestionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "IncorrectQuestionCell", for: indexPath) as! IncorrectQuestionCell// cell이라는 아이덴티파이어를 가진 놈으로 셀 생성(디자인부분)
        cell.mappingData(index: indexPath.row, key: sortKey)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let makeQuestionViewController = MakeQuestionViewController()
        //makeQuestionViewController.isEnd = true
        makeQuestionViewController.editTarget = DataManager.shared.sortQuestionList[indexPath.row]
        navigationController?.navigationBar.isHidden = false
        navigationController?.pushViewController(makeQuestionViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }

    //삭제 구현
    func tableView(_ tableView: UITableView, editingStyleForRowAt intdexPath: IndexPath) -> UITableViewCell.EditingStyle{
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete { //위에서 리턴한 딜리트 스타일을 처리하는 부분
            if sortButton.title(for: .normal) == "많이 틀린 순" {
                DataManager.shared.sortQuestionList[indexPath.row].failCount = 0
            } else {
                DataManager.shared.sortQuestionList[indexPath.row].failDate = Date(timeIntervalSince1970: 0)
            }
            DataManager.shared.saveContext()
            DataManager.shared.sortQuestionList.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}
