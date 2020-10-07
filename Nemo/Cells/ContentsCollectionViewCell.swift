//
//  ContentsCollectionViewCell.swift
//  BrainSupporter2
//
//  Created by 박영호 on 2020/08/06.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class ContentsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var gaugeCollectionView: UICollectionView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var leaveQuestionLabel: UILabel!

    @IBAction func ContentsCollectionViewXmarkClick(_ sender: Any) {
        
    }
    
    func cellDidLoad() { // 이게되네 ㅋㅋㅋ
        gaugeCollectionView.delegate = self
        gaugeCollectionView.dataSource = self
        
        gaugeCollectionView.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        gaugeCollectionView.layer.borderWidth = 1.0
        gaugeCollectionView.layer.cornerRadius = 5.0
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (Int(UIScreen.main.bounds.width) - 16) * DataManager.shared.nowQNumber! / DataManager.shared.nowQAmount!, height: 15)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: CGFloat(UIScreen.main.bounds.width) - 16 - layout.itemSize.width)
        gaugeCollectionView.collectionViewLayout = layout
        
        leaveQuestionLabel.text = "\(String(DataManager.shared.nowQNumber!)) / \(String(DataManager.shared.nowQAmount!))"
    }
}

extension ContentsCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GaugeCollectionViewCell", for: indexPath)
        return cell
    }
}
