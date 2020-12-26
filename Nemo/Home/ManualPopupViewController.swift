//
//  ManualPopupViewController.swift
//  Nemo
//
//  Created by 박영호 on 2020/12/26.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class ManualPopupViewController: UIViewController {
    
    var container = UIView().then {
        $0.backgroundColor = .white
    }
    var appStructManualImage = UIImageView().then {
        $0.image = UIImage(named: "가방노트설명")
        $0.contentMode = .scaleAspectFit
    }
    var manualLabel = UILabel().then {
        $0.text = "가방을 만들고,\n가방 안에 노트를 만들어 넣고,\n노트에 문제를 작성한 후 매일매일 풀어보세요!\n\n포함관계: 가방 ⊃ 노트 ⊃ (문제, 필기)"
        $0.numberOfLines = 0
        $0.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    }
    var doneButton = UIButton().then {
        $0.backgroundColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        $0.setTitle("확인", for: .normal)
        $0.tintColor = .white
        $0.addTarget(self, action: #selector(tapDoneButton), for: .touchUpInside)
    }
    @objc func tapDoneButton() {
        if checkNeverSee.isSelected {
            UserDefaults.standard.setValue(true, forKey: "neverPopupManual")
        }
        dismiss(animated: true, completion: nil)
    }
    
    var checkNeverSee = UIButton().then {
        $0.setTitle("다시 보지 않기", for: .normal)
        $0.setTitleColor(#colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1), for: .normal)
        $0.setImage(UIImage(systemName: "circle"), for: .normal)
        $0.setImage(UIImage(systemName: "checkmark.circle"), for: .selected)
        $0.addTarget(self, action: #selector(tapNeverSeeButton), for: .touchUpInside)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        $0.contentHorizontalAlignment = .leading
    }
    @objc func tapNeverSeeButton() {
        checkNeverSee.isSelected.toggle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    func setupLayout() {
        view.backgroundColor = .clear
        
        view.addSubview(container)
        container.addSubview(appStructManualImage)
        container.addSubview(manualLabel)
        container.addSubview(doneButton)
        container.addSubview(checkNeverSee)
        
        container.snp.makeConstraints{
            $0.top.equalToSuperview().inset(100)
            $0.bottom.equalToSuperview().inset(120)
            $0.leading.trailing.equalToSuperview().inset(35)
        }
        appStructManualImage.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.snp.centerY)
        }
        manualLabel.snp.makeConstraints{
            $0.top.equalTo(appStructManualImage.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        checkNeverSee.snp.makeConstraints{
            $0.top.equalTo(manualLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.height.equalTo(30)
            $0.width.equalTo(150)
        }
        doneButton.snp.makeConstraints{
            $0.top.equalTo(checkNeverSee.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
        
    }

}
