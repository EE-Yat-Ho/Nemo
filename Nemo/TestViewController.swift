//
//  TestViewController.swift
//  BrainSupporter2
//
//  Created by 박영호 on 2020/08/06.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    @IBOutlet weak var contentCollectionView: UICollectionView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var QnumLabel: UILabel!
    @IBOutlet weak var QuestionContents: UILabel!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var AnswerInput: UITextView!
    var nowQNumber: Int!
    var nowQ: Question!
    var answer = Answer()
    
    var useTime: Int!
    var timer: Timer!
    var minite: Int!
    var second: Int!
    var cell: ContentsCollectionViewCell!
    
    var TableHeight: CGFloat!
    var TableHeightAnchor: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "배경")!)
        contentCollectionView.delegate = self
        contentCollectionView.dataSource = self
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        TableView.delegate = self
        TableView.dataSource = self
        navigationController?.navigationBar.isHidden = true
        
        contentCollectionView.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        contentCollectionView.layer.borderWidth = 1.0
        contentCollectionView.layer.cornerRadius = 5.0
        
        TableView.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        TableView.layer.borderWidth = 1.0
        TableView.layer.cornerRadius = 5.0
        
        AnswerInput.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        AnswerInput.layer.borderWidth = 1.0
        AnswerInput.layer.cornerRadius = 5.0
        
        imageCollectionView.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        imageCollectionView.layer.borderWidth = 1.0
        imageCollectionView.layer.cornerRadius = 5.0
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: contentCollectionView.frame.width, height: 75)
        contentCollectionView.collectionViewLayout = layout
        
        nowQNumber = DataManager.shared.nowQNumber!
        nowQ = DataManager.shared.testQuestionList[nowQNumber - 1]
        QnumLabel.text = "Q" + String(nowQNumber) + "."
        QuestionContents.text = nowQ.question
        
        TableView.translatesAutoresizingMaskIntoConstraints = false
        if TableHeightAnchor != nil {
            TableHeightAnchor.isActive = false
        }
        
        if nowQ.isSubjective == true { // 주관식
            AnswerInput.alpha = 1.0
            TableHeight = 0.0
        } else { // 객관식
            AnswerInput.alpha = 0.0
            TableHeight = CGFloat(nowQ.multipleChoiceAnswers!.count + nowQ.multipleChoiceWrongAnswers!.count) * 43.5
        }
        TableHeightAnchor = TableView.heightAnchor.constraint(equalToConstant: TableHeight)
        TableHeightAnchor.isActive = true
        
        AnswerInput.text = ""
        
        if timer != nil {
            timer.invalidate()
        }
        useTime = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
        
        contentCollectionView.tag = 1
        imageCollectionView.tag = 2
        
        DataManager.shared.imageList.removeAll()
        for i in nowQ.questionImages ?? [Data]() {
            DataManager.shared.imageList.append(UIImage(data: i)!)
        }
        let layout2 = UICollectionViewFlowLayout()
        layout2.itemSize = CGSize(width: 110, height: 110)
        layout2.minimumLineSpacing = 0
        
        imageCollectionView.reloadData()
        imageCollectionView.collectionViewLayout = layout2
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        var imageCollectionViewHeight = CGFloat((nowQ.questionImages!.count + 2) / 3) * 110
        if imageCollectionViewHeight == 0 { imageCollectionViewHeight = 10.0 }
        if imageCollectionViewHeight > 270.0 { imageCollectionViewHeight = 270.0}
        let imageCollectionViewHeightAnchor = imageCollectionView.heightAnchor.constraint(equalToConstant: imageCollectionViewHeight)
        imageCollectionViewHeightAnchor.isActive = true
        
        self.TableView.tableFooterView = UIView()
    }
    
    
    @objc func timerCallback(){
        useTime += 1
        if useTime == DataManager.shared.timerTime {
            self.NextQuestionButtonClick(AnyClass.self) // 뭐냐 이 애니클래스는
        }
        minite = useTime / 60
        second = useTime % 60
        if minite < 10 {
            cell.timerLabel.text = "0"
        } else {
            cell.timerLabel.text = ""
        }
        cell.timerLabel.text! += String(minite) + ":"
        if second < 10 {
            cell.timerLabel.text! += "0"
        }
        cell.timerLabel.text! += String(second)
    }
    
    @IBAction func NextQuestionButtonClick(_ sender: Any) {
        cell.timerLabel.text = "00:00"
        if nowQ.isSubjective == true {
            answer.subjectiveAnswer = AnswerInput.text
        } else {
            //answer.multipleChoiceAnswer =
        }
        DataManager.shared.testAnswerList.append(answer)
        
        if nowQNumber < DataManager.shared.nowQAmount!{
            DataManager.shared.nowQNumber! += 1
            TableView.alpha = 0.1
            AnswerInput.alpha = 0.1
            contentCollectionView.alpha = 0.1
            QnumLabel.alpha = 0.1
            QuestionContents.alpha = 0.1
            UIView.animate(withDuration: 1.0, animations: {() -> Void in
                self.TableView.alpha = 1.0
                self.AnswerInput.alpha = 1.0
                self.contentCollectionView.alpha = 1.0
                self.QnumLabel.alpha = 1.0
                self.QuestionContents.alpha = 1.0
                self.viewDidLoad()
                self.contentCollectionView.reloadData()
            })
        } else {
            //마지막 화면
            timer.invalidate()
            let endTestTableViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EndTestTableViewController") as! EndTestTableViewController
            self.navigationController?.pushViewController(endTestTableViewController, animated: true)
        }
    }
}

extension TestViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 { // 맨위 타이머
            return 1
        } else { // 사진 콜렉션 뷰
            return nowQ.questionImages!.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 { // 맨 위 타이머
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentsCollectionViewCell", for: indexPath) as? ContentsCollectionViewCell
            cell.cellDidLoad() // 이게되네 ㅋㅋㅋㅋ
            return cell
        } else { // 사진 콜렉션 뷰
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
            cell.imageView.image = DataManager.shared.imageList[indexPath.row]

            return cell
        }
    }
}

extension TestViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.TableView.dequeueReusableCell(withIdentifier: "MultipleChoiceQuestionAnswerCellForTest", for: indexPath) as! MultipleChoiceQuestionAnswerCellForTest
        cell.num.text = String(indexPath.row + 1)
        return cell
    }
    
    
}
