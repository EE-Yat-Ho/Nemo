//
//  IncorrectNoteViewContoller.swift
//  Nemo
//
//  Created by 박영호 on 2020/11/17.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ConfigViewContoller: UIViewController {
    var tableView = UITableView().then {
        $0.register(ConfigCell.self, forCellReuseIdentifier: "ConfigCell")
        $0.backgroundColor = UIColor.clear
        $0.separatorColor = UIColor.clear
        $0.tableFooterView = UIView()
    }
    var titleLabel = UILabel().then{
        $0.text = "설정"
        $0.font = UIFont(name: "NotoSansKannada-Bold", size: 34)
    }
    
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
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.navigationBar.topItem?.title = "설정"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.clear]
        
        loadBanner()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) { // 화면이 전환 될때(나타날때) 호출
        super.viewWillAppear(animated)
        
        tableView.reloadData() // 배열 데이터로 뷰를 업데이트함
    }
    
    
    func setupLayout() {
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background_paper")!)
        tableView.backgroundColor = UIColor.clear
        tableView.separatorColor = UIColor.clear
        
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(banner.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        tableView.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
    }
    
}

extension ConfigViewContoller: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ConfigCell", for: indexPath) as! ConfigCell
        cell.mappingData(index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        switch indexPath.row{
        case 0:
            navigationController?.pushViewController(AlermViewController(), animated: true)
        case 1:
            print("백업미구현")
        case 2:
            navigationController?.pushViewController(ManualPageViewController(), animated: true)
        case 3:
            alert(title: "개발자 이메일", message: "enough6157@naver.com")
        case 4:
            let fontChoice = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            var str = "귀여운 글씨체"
            if Resource.Font.globalFont == FontKind.NanumGoDigANiGoGoDing.rawValue
            { str += " (적용 중)" }
            let choice1 = UIAlertAction(title: str, style: .default) { _ in
                Resource.Font.setGlobalFont(font: .NanumGoDigANiGoGoDing)
                ToastManager.showToast(message: "\"귀여운 글씨체\"가 선택 되었습니다~")
            }
            
            str = "일반 글씨체"
            if Resource.Font.globalFont == FontKind.NotoSansKannada.rawValue
            { str += " (적용 중)" }
            let choice2 = UIAlertAction(title: str, style: .default) { _ in
                Resource.Font.setGlobalFont(font: .NotoSansKannada)
                ToastManager.showToast(message: "문제풀기 좋은 \"일반 글씨체\"가 선택 되었습니다~")
            }
            
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            
            fontChoice.addAction(choice1)
            fontChoice.addAction(choice2)
            fontChoice.addAction(cancel)
            
            present(fontChoice, animated: true)
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}

extension ConfigViewContoller: GADBannerViewDelegate {
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
