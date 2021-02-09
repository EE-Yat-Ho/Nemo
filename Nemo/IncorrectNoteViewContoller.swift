//
//  IncorrectNoteViewContoller.swift
//  Nemo
//
//  Created by 박영호 on 2020/11/17.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit
import GoogleMobileAds

class IncorrectNoteViewContoller: UIViewController {
    let downArrow = UIButton().then {
        $0.setImage(UIImage(named: "arrow_down"), for: .normal)
        $0.addTarget(self, action: #selector(showPopup), for: .touchUpInside)
    }
    let sortButton = UIButton().then {
        $0.setTitle("많이 틀린 순", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.addTarget(self, action: #selector(showPopup), for: .touchUpInside)
        $0.titleLabel?.font = UIFont.handNormal()
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
    lazy var editButton = UIBarButtonItem(image: UIImage(named: "sissor"), style: .plain, target: self, action: #selector(clickEditButton))
    var sortKey: SortKey = .failCount
    
    
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
        
        loadBanner()
        setupLayout()
        //bindingData()
        
        if UserDefaults.standard.bool(forKey: "neverIncorrectNotePopup") == false {
            let alert = ManualPopupViewController()
            alert.popupKind = .incorrectNote
            alert.imageView.image = UIImage(named: "incorrect")
            alert.manualLabel.text = "여기는 오답노트에요! \"틀린 횟수\" 혹은 \"최근 틀린 시간\" 순으로 볼 수 있어요.\n여기서 삭제시, 해당 문제의 틀린 횟수와 틀린 시간이 초기화되요!"
            present(alert, animated: true, completion: {
                /// present화면 스크롤 다운 못하게하기
                alert.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
            }) // 완성된 알림창 화면에 띄우기
        }
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
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background_paper")!)
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
            $0.top.equalTo(banner.snp.bottom).offset(20)
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
            editButton.image = UIImage(named: "sissor")
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
            //if sortButton.title(for: .normal) == "많이 틀린 순" {
                DataManager.shared.sortQuestionList[indexPath.row].failCount = 0
            //} else {
                DataManager.shared.sortQuestionList[indexPath.row].failDate = Date(timeIntervalSince1970: 0)
            //}
            DataManager.shared.saveContext()
            DataManager.shared.sortQuestionList.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}

extension IncorrectNoteViewContoller: GADBannerViewDelegate {
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
