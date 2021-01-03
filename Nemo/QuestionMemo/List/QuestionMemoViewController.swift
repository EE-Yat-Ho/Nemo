//
//  QuestionMemoViewController.swift
//  BrainSupporter2
//
//  Created by 박영호 on 2020/07/07.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit
import SwiftUI
import SnapKit
import Then
import GoogleMobileAds

class QuestionMemoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var questionOpened:Bool? = false
    var memoOpened:Bool? = false
    var tableView = UITableView().then{
        $0.register(QuestionCell.self, forCellReuseIdentifier: "QuestionCell")
        $0.register(QuestionOpenCell.self, forCellReuseIdentifier: "QuestionOpenCell")
        $0.register(MemoCell.self, forCellReuseIdentifier: "MemoCell")
        $0.register(MemoOpenCell.self, forCellReuseIdentifier: "MemoOpenCell")
        $0.tableFooterView = UIView()
        $0.showsVerticalScrollIndicator = false
    }
    var titleLabel = UILabel().then{
        $0.text = DataManager.shared.nowNoteName
        $0.font = UIFont(name: "NotoSansKannada-Bold", size: 34)
    }
    var addButton = UIButton().then{
        $0.setImage(UIImage(named: "필기하기"), for: .normal)
        $0.addTarget(self, action: #selector(showPopup), for: .touchUpInside)
    }
    //clickEditButton가 생성된 후 만들어야하므로 lazy
    lazy var editButton = UIBarButtonItem(image: UIImage(named: "기본아이콘_편집"), style: .plain, target: self, action: #selector(clickEditButton))
    
    
    var banner: GADBannerView!
    func loadBanner() {
        banner = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        banner.adUnitID = "ca-app-pub-9616604463157917/3905009278"
        banner.rootViewController = self
        let req: GADRequest = GADRequest()
        banner.load(req)
        banner.delegate = self
        
        view.addSubview(banner)
        
        banner.snp.makeConstraints{
            //$0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.centerX.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clear
        tableView.backgroundColor = UIColor.clear
        
        navigationItem.rightBarButtonItem = editButton
        loadBanner()
        setupLayout()
        
        if UserDefaults.standard.bool(forKey: "neverNotePopup") == false {
            let alert = ManualPopupViewController()
            alert.popupKind = .note
            alert.imageView.image = UIImage(named: "필기문제설명")
            alert.manualLabel.text = "처음 노트를 생성했을 때는 아무런 필기도 문제도 없어요. 우측 하단 버튼으로 생성해주실래요?"
            present(alert, animated: true, completion: {
                /// present화면 스크롤 다운 못하게하기
                alert.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
            }) // 완성된 알림창 화면에 띄우기
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        DataManager.shared.imageList = []
        super.viewDidAppear(animated)
        navigationController?.navigationBar.topItem?.title = DataManager.shared.nowNoteName
    }
    
    func setupLayout() {
        view.backgroundColor = UIColor(patternImage: UIImage(named: "배경")!)
        
        //navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.clear]
        
        view.addSubview(tableView)
        view.addSubview(titleLabel)
        view.addSubview(addButton)
        
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(banner.snp.bottom).offset(20)
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
            $0.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
        }
        
    }
    
    // 우측 상단 버튼 조정
    @objc public func clickEditButton() {
        if tableView.isEditing {// 정상으로
            tableView.setEditing(false, animated: true)
            editButton.title = ""
            editButton.image = UIImage(named: "기본아이콘_편집")
        } else { // 편집모드로
            tableView.setEditing(true, animated: true)
            editButton.title = "완료"
            editButton.image = nil
        }
    }
    
    // + 눌렀을때 팝업창 띄우기
    @objc func showPopup() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let addMemoAction = UIAlertAction(title: "필기 만들기", style: .default){[weak self] (action) in
            let makeMemoViewController = MakeMemoViewController()
            self?.navigationController?.pushViewController(makeMemoViewController, animated: true)
            
        }
        alert.addAction(addMemoAction)
        let addQuestionAction = UIAlertAction(title: "문제 만들기", style: .default){[weak self] (action) in
            
            let makeQuestionViewController = MakeQuestionViewController()
            self?.navigationController?.pushViewController(makeQuestionViewController, animated: true)
 
        }
        alert.addAction(addQuestionAction)
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

    //섹션 수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //섹션당 로우 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            if memoOpened == true {
                return DataManager.shared.memoList.count + 1
            }
        } else {
            if questionOpened == true { // 열려있으면 문제수 + 1
                return DataManager.shared.questionList.count + 1
            }
        } // 닫혀있으면 그냥 1이지 ㅇㅇ
        return 1
    }
        
    // 가장 중요한 메소드
    // 셀을 가져와서 필요한 데이터를 채운 뒤 리턴하는 메소드
    // 테이블 뷰에게 어떤 디자인으로 어떤 데이터를 표시하면 되는지 알려주는 부분
    // 셀 하나당 한번씩 호출. indexPath로 목록내의 해당 순서의 셀을 접근
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 { // 필기들
            if indexPath.row == 0 {
                let memoOpenCell = self.tableView.dequeueReusableCell(withIdentifier: "MemoOpenCell", for: indexPath) as! MemoOpenCell
                memoOpenCell.numberOfMemo.text = String(DataManager.shared.memoList.count)
                if memoOpened == true {
                    memoOpenCell.rightImage.image = UIImage(named: "기본아이콘_펼치기")
                } else {
                    memoOpenCell.rightImage.image = UIImage(named: "편집_뒤로가기")
                }
                return memoOpenCell
            } else {
                let memoCell = self.tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath) as! MemoCell
                memoCell.memoTitle.text = DataManager.shared.memoList[indexPath.row - 1].content
                return memoCell
            }
        }
        else { // 문제들
            if indexPath.row == 0 {
                let questionOpenCell = self.tableView.dequeueReusableCell(withIdentifier: "QuestionOpenCell", for: indexPath) as! QuestionOpenCell// cell이라는 아이덴티파이어를 가진 놈으로 셀 생성(디자인부분)
                questionOpenCell.numberOfQuestion.text = String(DataManager.shared.questionList.count)
                if questionOpened == true {
                    questionOpenCell.rightImage.image = UIImage(named: "기본아이콘_펼치기")
                } else {
                    questionOpenCell.rightImage.image = UIImage(named: "편집_뒤로가기")
                }
                return questionOpenCell
            } else {
                let questionCell = self.tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
                questionCell.questionTitle.text = DataManager.shared.questionList[indexPath.row - 1].question
                return questionCell
            }
        }
    }
    
    // 눌러졌을때 할일
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 { // 필기보기, 문제보기 눌러짐
            if indexPath.section == 0 { // 필기보기 눌러짐
                memoOpened?.toggle()
            } else { // 메모보기 눌러짐
                questionOpened?.toggle()
            }
            let sections = IndexSet.init(integer: indexPath.section) // 아 바로 밑에쓰이니 지우지말라고 ㅋㅋ
            tableView.reloadSections(sections, with: .none)
        } else {
            if indexPath.section == 0 { // 필기
                let makeMemoViewController = MakeMemoViewController()
                makeMemoViewController.editTarget = DataManager.shared.memoList[indexPath.row - 1]
                self.navigationController?.pushViewController(makeMemoViewController, animated: true)
            } else { // 문제
                let makeQuestionViewController = MakeQuestionViewController()
                makeQuestionViewController.editTarget = DataManager.shared.questionList[indexPath.row - 1]
                self.navigationController?.pushViewController(makeQuestionViewController, animated: true)
            }
        }
    }


    //순서바꾸기 허용
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool{
        if indexPath.row == 0{
            return false
        }
        return true
    }

    //순서바꿀때 배열이랑 디비 조정
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath){
        if sourceIndexPath.row == 0 { // 오픈메뉴를 옮긴 경우
            // 여기서 노트는 row == 0이 아닌 것들이기 떄문에 문제, 필기 모두 해당됨
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
                    ModifiedDestinationIndexPathRow = Int(DataManager.shared.questionList.count - 1) // 젤 아래
                }
            }
            if sourceIndexPath.section == 0 && destinationIndexPath.section == 1 { // 문제들에서 보기들로 내려버린 경우
                ModifiedDestinationIndexPathSection = 0 // 위 섹션으로 고쳐버리고
                ModifiedDestinationIndexPathRow = Int(DataManager.shared.memoList.count - 1) // 젤 밑으로 봄
            } else if sourceIndexPath.section == 1 && destinationIndexPath.section == 0 { // 보기들에서 문제로 올려버린 경우
                ModifiedDestinationIndexPathSection = 1 // 아래 섹션으로 고쳐버리고
                ModifiedDestinationIndexPathRow = 0 // 맨 위라고 봄
            }
            
            
            if sourceIndexPath.section == ModifiedDestinationIndexPathSection { // 한 섹션 안에서 옮긴 경우
                if sourceIndexPath.section != 0 { // 문제 보기에서 옮김
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
            if indexPath.row == 0 { // 보기를 삭제하는 경우 = 불가능
                
            } else { // 필기나 문제 삭제
                let alert = UIAlertController(title: "정말 삭제하시겠습니까?", message: "", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default){ [weak self] (action) in
                    // 확인 눌렀을 때 하는 소스
                    if indexPath.section != 0 { // 문제 삭제
                        let target = DataManager.shared.questionList[indexPath.row - 1]
                        DataManager.shared.questionList.remove(at: indexPath.row - 1)
                        for i in 0..<indexPath.row - 1{
                           DataManager.shared.questionList[i].order = Int16(DataManager.shared.questionList.count - i - 1)
                        }
                        // 노트에서 문제 수 하나 빼기
//                        for i in DataManager.shared.noteList{
//                            if i.name == DataManager.shared.nowNoteName{
//                                i.numberOfQ -= 1
//                            }
//                        }
                        DataManager.shared.noteList[DataManager.shared.nowBPN!.section][DataManager.shared.nowBPN!.row - 1].numberOfQ -= 1
                        // 디비에서 문제 삭제
                        DataManager.shared.deleteQuestion(target)
                    } else { // 메모 삭제
                        let target = DataManager.shared.memoList[indexPath.row - 1]
                        DataManager.shared.memoList.remove(at: indexPath.row - 1)
                        for i in 0..<indexPath.row - 1{
                           DataManager.shared.memoList[i].order = Int16(DataManager.shared.memoList.count - i - 1)
                        }
                        // 노트에서 문제 수 하나 빼기
//                        for i in DataManager.shared.noteList{
//                            if i.name == DataManager.shared.nowNoteName{
//                                i.numberOfM -= 1
//                            }
//                        }
                        DataManager.shared.noteList[DataManager.shared.nowBPN!.section][DataManager.shared.nowBPN!.row - 1].numberOfM -= 1
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
}

extension QuestionMemoViewController: GADBannerViewDelegate {
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
    }
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
}
