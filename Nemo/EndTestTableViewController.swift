//
//  EndTestTableViewController.swift
//  BrainSupporter2
//
//  Created by 박영호 on 2020/08/10.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class EndTestTableViewController: UITableViewController {
    var rightAmount: Int! = 0
    var endingCell: EndingCell!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.nowQAmount! + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            endingCell = tableView.dequeueReusableCell(withIdentifier: "EndingCell", for: indexPath) as? EndingCell
            return endingCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCheckCell", for: indexPath) as! QuestionCheckCell
            cell.Qnum.text = "Q" + String(indexPath.row)
            cell.textView.text = DataManager.shared.testQuestionList[indexPath.row - 1].question!
            cell.textView.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
            cell.textView.layer.borderWidth = 1.0
            cell.textView.layer.cornerRadius = 5.0
            if DataManager.shared.testQuestionList[indexPath.row - 1].isSubjective == true {
                // 주관식 답 체크
                if DataManager.shared.testAnswerList[indexPath.row - 1].subjectiveAnswer == DataManager.shared.testQuestionList[indexPath.row - 1].subjectiveAnswer {
                    cell.OX.image = UIImage(named: "맞은표시")
                    rightAmount += 1
                }
            } else {
                // 객관식 답 체크
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return CGFloat(140)
        } else {
            return CGFloat(190)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 문제 세밀하게 보는 뷰
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == DataManager.shared.nowQAmount { // 한번만 하면 되자너 ^_^ㅜ 다른 좋은 방법이 있을거같긴함..
            endingCell.rightPerAll.text = String(rightAmount) + " / " + String(DataManager.shared.nowQAmount!)
        }
    }
    
    @IBAction func xmarkClick(_ sender: Any) {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popToRootViewController(animated: true)
    }
}
