//
//  AlermViewController.swift
//  Nemo
//
//  Created by 박영호 on 2020/11/17.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class AlermViewController: UIViewController {
    let titleLabel = UILabel().then{
        $0.text = "알림설정"
        $0.font = UIFont(name: "NotoSansKannada-Bold", size: 34)
    }
    let alermLabel = UILabel().then {
        $0.text = "네모 알람"
        $0.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        $0.font = UIFont.handNormal()
    }
    let tableView = UITableView().then {
        $0.register(AlermCell.self, forCellReuseIdentifier: "AlermCell")
        $0.backgroundColor = UIColor.clear
        $0.separatorColor = UIColor.clear
        $0.tableFooterView = UIView()
        $0.allowsSelection = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
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
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = UIColor.clear

        view.addSubview(titleLabel)
        view.addSubview(alermLabel)
        view.addSubview(tableView)
        
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        alermLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
        }
        tableView.snp.makeConstraints{
            $0.top.equalTo(alermLabel.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension AlermViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "AlermCell", for: indexPath) as! AlermCell
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}

extension AlermViewController: AlermDelegate {
    func clickTimer(_ cell: AlermCell) {
        let dateChooserAlert = UIAlertController(title: "알림 시간 선택", message: nil, preferredStyle: .actionSheet)

        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .countDownTimer
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        datePicker.date = formatter.date(from: cell.timerButton.titleLabel?.text ?? "00:00")!
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        dateChooserAlert.view.addSubview(datePicker)
        dateChooserAlert.view.snp.makeConstraints{
            $0.height.equalTo(350)
        }
        
        // constraint
        datePicker.snp.makeConstraints{
            $0.leading.trailing.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-60)
        }
    
        dateChooserAlert.addAction(UIAlertAction(title: "선택완료", style: .default, handler: { (action) in
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            let date = formatter.string(from: datePicker.date)
            
            /// 설정한 값으로 버튼의 텍스트값 변경
            cell.timerButton.setTitle(date, for: .normal)
            
            /// 설정한 값으로 유저디폴트값 변경
            let calender = Calendar.current
            NotificationManager.shared.setNotiTime(
                hour: calender.component(.hour, from: datePicker.date),
                minute: calender.component(.minute, from: datePicker.date)
            )
            
            /// 알람 설정 되어있면, 지우고 새로 설정
            if cell.toggleButton.isSelected {
                NotificationManager.shared.removeNotification(identifiers: ["ComeBack!"])
                NotificationManager.shared.setNotification()
            }
        }))

        navigationController?.present(dateChooserAlert, animated: true, completion: nil)
    }
    
    func showAlert() {
        alert(message: "알림 권한이 꺼져있습니다. 알림을 받고싶으면 설정에서 Nemo에게 Notification권한을 주세요!")
    }
    
//    func clickToggle(_ cell: AlermCell) {
//        print("toggle")
//        if self?.toggleButton.isSelected ?? true { //켜진걸 끄는경우 = 알람을 끄기
//            NotificationManager.shared.removeNotification(identifiers: ["ComeBack!"])
//        } else {// 켜는 경우 = 알람 설정하기
//            NotificationManager.shared.setNotification()
//        }
//        self?.toggleButton.isSelected.toggle()
//    }
}
