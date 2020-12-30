//
//  AlermCell.swift
//  Nemo
//
//  Created by 박영호 on 2020/11/17.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// 오 굳이 VC에서 처리할거 아니면 델리게이트 안써도됨
protocol AlermDelegate {
    func clickTimer(_ cell: AlermCell)
   // func clickToggle(_ cell: AlermCell)
    func showAlert()
}

class AlermCell: UITableViewCell {
    var delegate: AlermDelegate!
    var disposeBag = DisposeBag()
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    let label = UILabel().then {
        $0.text = "문제풀기 알람"
        $0.font = UIFont.handNormal()
    }
    let timerButton = UIButton().then {
        $0.semanticContentAttribute = .forceRightToLeft// 타이틀이 먼저오게
        
        $0.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -30)
        
        $0.setImage(UIImage(named:"위로화살표"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.imageEdgeInsets = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 0)
    }
    
    let toggleButton = UIButton().then {
        $0.imageView?.contentMode = .scaleAspectFit
        $0.setImage(UIImage(named:"꺼진스위치"), for: .normal)
        $0.setImage(UIImage(named:"켜진스위치"), for: .selected)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        binding()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    let datePicker = UIDatePicker().then {
        $0.datePickerMode = .time
    }
    func binding() {
        timerButton.rx.tap.bind{ [weak self] in
            self?.delegate.clickTimer(self!)
        }.disposed(by: disposeBag)

        toggleButton.rx.tap.bind{ [weak self] in
           // self?.delegate.clickToggle(self!)
            print("toggle")
            if self?.toggleButton.isSelected ?? true { //켜진걸 끄는경우 = 알람을 끄기
                NotificationManager.shared.removeNotification(identifiers: ["ComeBack!"])
                UserDefaults.standard.setValue(false, forKey: "notiAuth")
                self?.toggleButton.isSelected = false
            } else {// 켜는 경우 = 알람 설정하기
                NotificationManager.shared.setNotification()
                UserDefaults.standard.setValue(true, forKey: "notiAuth")
                self?.toggleButton.isSelected = true
                UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { settings in
                    switch settings.alertSetting {
                    case .enabled:
                        UserDefaults.standard.setValue(true, forKey: "notiAuth")
                    default:
                        DispatchQueue.main.async {
                            UserDefaults.standard.setValue(false, forKey: "notiAuth")
                            NotificationManager.shared.removeNotification(identifiers: ["ComeBack!"])
                            // 쓰레드 문제 ㅠ
                            self?.toggleButton.isSelected = false
                            self?.delegate.showAlert()
                        }
                    }
                })
            }
        }.disposed(by: disposeBag)
    }
    
    func setupLayout() {
        backgroundColor = UIColor.clear
        
        var title = ""
        if UserDefaults.standard.integer(forKey: "notiHour") < 10 {
            title += "0"
        }
        title += String(UserDefaults.standard.integer(forKey: "notiHour")) + ":"
        if UserDefaults.standard.integer(forKey: "notiMinute") < 10 {
            title += "0"
        }
        title += String(UserDefaults.standard.integer(forKey: "notiMinute"))
        timerButton.setTitle(title, for: .normal)
        
        toggleButton.isSelected = UserDefaults.standard.bool(forKey: "notiAuth")
        
        contentView.addSubview(label)
        contentView.addSubview(timerButton)
        contentView.addSubview(toggleButton)
        
        label.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        toggleButton.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(32)
            $0.width.equalTo(55)
        }
        timerButton.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(toggleButton.snp.leading).offset(-10)
            $0.height.equalTo(30)
            $0.width.equalTo(80)
        }
        timerButton.layer.borderWidth = 0.5
        timerButton.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 0.5327750428)
        timerButton.layer.cornerRadius = 15
    }
}
