//
//  ManualPopupViewController.swift
//  Nemo
//
//  Created by 박영호 on 2020/12/26.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

enum PopupKind {
    case home
    case note
    case setTest
    case timer
    case incorrectNote
}

class ManualPopupViewController: UIViewController {
    var popupKind: PopupKind!
    var container = UIView().then {
        $0.backgroundColor = .white
    }
    var imageView = UIImageView().then {
        $0.image = UIImage(named: "backpack_note")
        $0.contentMode = .scaleAspectFit
    }
    var manualLabel = UILabel().then {
        $0.text = "가방을 만들고,\n가방 안에 노트를 만들어 넣고,\n노트에 문제를 작성한 후 매일매일 풀어보세요!\n\n포함관계: 가방 ⊃ 노트 ⊃ (문제, 필기)"
        $0.numberOfLines = 0
        $0.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        $0.font = UIFont.handNormal()
    }
    var doneButton = UIButton().then {
        $0.backgroundColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        $0.setTitle("확인", for: .normal)
        $0.tintColor = .white
        $0.addTarget(self, action: #selector(tapDoneButton), for: .touchUpInside)
        $0.titleLabel?.font = UIFont.handNormal()
    }
    @objc func tapDoneButton() {
        if checkNeverSee.isSelected {
            switch popupKind {
            case .home:
                UserDefaults.standard.setValue(true, forKey: "neverHomePopup")
            case .note:
                UserDefaults.standard.setValue(true, forKey: "neverNotePopup")
            case .setTest:
                UserDefaults.standard.setValue(true, forKey: "neverSetTestPopup")
            case .timer:
                UserDefaults.standard.setValue(true, forKey: "neverTimerPopup")
            case .incorrectNote:
                UserDefaults.standard.setValue(true, forKey: "neverIncorrectNotePopup")
            case .none:
                return
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    var checkNeverSee = UIButton().then {
        $0.setTitle("다시 보지 않기", for: .normal)
        $0.setTitleColor(#colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1), for: .normal)
        $0.setImage(UIImage(systemName: "circle"), for: .normal)
        $0.setImage(UIImage(systemName: "checkmark.circle"), for: .selected)
        $0.addTarget(self, action: #selector(tapNeverSeeButton), for: .touchUpInside)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 5, right: 0)
        $0.contentHorizontalAlignment = .leading
        $0.titleLabel?.font = UIFont.handNormal16()
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
        container.layer.borderWidth = 0
        container.layer.borderColor = UIColor.clear.cgColor
        container.layer.cornerRadius = 15
        container.layer.masksToBounds = true
        
        view.addSubview(container)
        container.addSubview(imageView)
        container.addSubview(manualLabel)
        container.addSubview(doneButton)
        container.addSubview(checkNeverSee)
        
        container.snp.makeConstraints{
            $0.top.equalToSuperview().inset(100)
            $0.bottom.equalTo(doneButton.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(35)
        }
        imageView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.snp.centerY)
        }
        manualLabel.snp.makeConstraints{
            $0.top.equalTo(imageView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        checkNeverSee.snp.makeConstraints{
            $0.top.equalTo(manualLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(5)
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
