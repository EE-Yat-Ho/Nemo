//
//  ManualViewController.swift
//  Nemo
//
//  Created by 박영호 on 2020/12/26.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class ManualViewController: UIViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    func setupLayout() {
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        view.addSubview(manualLabel)
        
        imageView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.snp.centerY)
        }
        manualLabel.snp.makeConstraints{
            $0.top.equalTo(imageView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }

}
