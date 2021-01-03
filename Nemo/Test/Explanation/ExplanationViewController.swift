//
//  ExplanationViewController.swift
//  Nemo
//
//  Created by 박영호 on 2020/08/18.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class ExplanationViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let rightImage = UIImageView()
    let questionTV = UITextView().then {
        //$0.text = "1 + 1 = ?"
        $0.backgroundColor = UIColor.clear
        $0.isScrollEnabled = false
        $0.isEditable = false
        $0.font = UIFont.handBig()
    }
    
    let collectionItemSize: CGFloat = (UIScreen.main.bounds.size.width - 40) / 3
    
    lazy var questionCollectionView = UICollectionView(
        frame: CGRect(x: 0, y: 0, width: 0, height: 0),
        collectionViewLayout: UICollectionViewFlowLayout().then {
            $0.itemSize = CGSize(width: collectionItemSize, height: collectionItemSize)
            $0.minimumInteritemSpacing = 0
            $0.minimumLineSpacing = 0}
        ).then{
            $0.backgroundColor = UIColor.clear//(patternImage: UIImage(named: "배경")!)
            $0.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
            $0.isScrollEnabled = false
            $0.tag = 0
        }
    
    let myChoiceTableView = UITableView().then { // 객관식에서만
        $0.register(TestAnswerCell.self, forCellReuseIdentifier: "TestAnswerCell")
        $0.separatorStyle = .none
        $0.backgroundColor = UIColor.clear
        $0.isScrollEnabled = false
        $0.tag = 0
    }
    var index = 0
    var question: Question!
    let myChoiceLabel = UILabel().then {
        $0.font = UIFont.handNormal()
    }
    let rightAnswerLabel = UILabel().then {
        $0.font = UIFont.handNormal()
        $0.setContentHuggingPriority(UILayoutPriority(1000), for: .horizontal)
    }
    let rightAnswerTable = UITableView().then { // 주관식에서만
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        $0.separatorStyle = .none
        $0.backgroundColor = UIColor.clear
        $0.tag = 1
        $0.isScrollEnabled = false
        $0.isUserInteractionEnabled = false
    }
    
    let explanationLabel = UILabel().then {
        $0.text = "플이!  "
        $0.font = UIFont.handNormal()
        $0.setContentHuggingPriority(UILayoutPriority(1000), for: .horizontal)
    }
    let explanationTV = UITextView().then {
        $0.backgroundColor = UIColor.clear
        $0.isScrollEnabled = false
        $0.isEditable = false
        $0.textColor = .black
        $0.font = UIFont.handNormal()
    }
    lazy var explanationCollectionView = UICollectionView(
        frame: CGRect(x: 0, y: 0, width: 0, height: 0),
        collectionViewLayout: UICollectionViewFlowLayout().then {
            $0.itemSize = CGSize(width: collectionItemSize, height: collectionItemSize)
            $0.minimumInteritemSpacing = 0
            $0.minimumLineSpacing = 0}
        ).then{
            $0.backgroundColor = UIColor.clear//(patternImage: UIImage(named: "배경")!)
            $0.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
            $0.isScrollEnabled = false
            $0.tag = 1
        }
    
    let separator1 = UIView().then {
        $0.backgroundColor = .lightGray
    }
    let separator2 = UIView().then {
        $0.backgroundColor = .lightGray
    }
    let separator3 = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    
    var tableHeight: CGFloat = 10
    var collectionHeight: CGFloat = 10
    override func viewDidLoad() {
        super.viewDidLoad()
        myChoiceTableView.delegate = self
        myChoiceTableView.dataSource = self
        rightAnswerTable.delegate = self
        rightAnswerTable.dataSource = self
        questionCollectionView.delegate = self
        questionCollectionView.dataSource = self
        explanationCollectionView.delegate = self
        explanationCollectionView.dataSource = self
        setupLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    func setupLayout() {
        view.backgroundColor = UIColor(patternImage: UIImage(named: "배경")!)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(rightImage)
        contentView.addSubview(questionTV)
        contentView.addSubview(questionCollectionView)
        contentView.addSubview(myChoiceTableView)
        contentView.addSubview(separator1)
        contentView.addSubview(myChoiceLabel)
        contentView.addSubview(separator2)
        contentView.addSubview(rightAnswerLabel)
        contentView.addSubview(rightAnswerTable)
        contentView.addSubview(separator3)
        contentView.addSubview(explanationLabel)
        contentView.addSubview(explanationTV)
        contentView.addSubview(explanationCollectionView)
        
        scrollView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.leading.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints{
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide.snp.width) }
        
        rightImage.snp.makeConstraints{
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.width.equalTo(80)
        }
        questionTV.snp.makeConstraints{
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        questionCollectionView.snp.makeConstraints{
            $0.top.equalTo(questionTV.snp.bottom).offset(20)
            $0.height.equalTo(collectionHeight)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        myChoiceTableView.snp.makeConstraints{
            $0.top.equalTo(questionCollectionView.snp.bottom).offset(20)
            $0.height.equalTo(100)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        separator1.snp.makeConstraints{
            $0.top.equalTo(myChoiceTableView.snp.bottom).offset(20)
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        myChoiceLabel.snp.makeConstraints{
            $0.top.equalTo(separator1.snp.bottom).offset(20)
            //$0.height.equalTo(100)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        separator2.snp.makeConstraints{
            $0.top.equalTo(myChoiceLabel.snp.bottom).offset(20)
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        rightAnswerLabel.snp.makeConstraints{
            $0.top.equalTo(separator2.snp.bottom).offset(20)
            //$0.height.equalTo(100)
            $0.leading.equalToSuperview().inset(20)
        }
        rightAnswerTable.snp.makeConstraints{
            $0.top.equalTo(separator2.snp.bottom).offset(20)
            $0.height.equalTo(100)
            $0.leading.equalTo(rightAnswerLabel.snp.trailing)
            $0.trailing.equalToSuperview().inset(20)
        }
        if question.isSubjective {
            separator3.snp.makeConstraints{
                $0.top.equalTo(rightAnswerTable.snp.bottom).offset(20)
                $0.height.equalTo(1)
                $0.leading.trailing.equalToSuperview().inset(20)
            }
        } else {
            separator3.snp.makeConstraints{
                $0.top.equalTo(rightAnswerLabel.snp.bottom).offset(20)
                $0.height.equalTo(1)
                $0.leading.trailing.equalToSuperview().inset(20)
            }
        }
        explanationLabel.snp.makeConstraints{
            $0.top.equalTo(separator3.snp.bottom).offset(20)
            //$0.height.equalTo(100)
            $0.leading.equalToSuperview().inset(20)
        }
        explanationTV.snp.makeConstraints{
            $0.top.equalTo(separator3.snp.bottom).offset(10)
            //$0.height.equalTo(100)
            $0.leading.equalTo(explanationLabel.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(20)
        }
        explanationCollectionView.snp.makeConstraints{
            $0.top.equalTo(explanationTV.snp.bottom).offset(20)
            $0.height.equalTo(100)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-50)
        }
        
        /// 콜렉션 높이 수정
        collectionHeight = collectionItemSize * CGFloat((question.questionImages!.count + 2) / 3)
        questionCollectionView.snp.updateConstraints{
            $0.height.equalTo(collectionHeight)
        }
        collectionHeight = collectionItemSize * CGFloat((question.explanationImages!.count + 2) / 3)
        explanationCollectionView.snp.updateConstraints{
            $0.height.equalTo(collectionHeight)
        }
        
        /// 테이블 높이 수정
        tableHeight = 43.5 * CGFloat(DataManager.shared.orderingAnswers[index].count)
        if question.isSubjective == false {// 객관식
            myChoiceTableView.snp.updateConstraints{
                $0.height.equalTo(tableHeight)
            }
            rightAnswerTable.snp.updateConstraints{
                $0.height.equalTo(0)
            }
        } else { //주관식
            myChoiceTableView.snp.updateConstraints{
                $0.height.equalTo(0)
            }
            rightAnswerTable.snp.updateConstraints{
                $0.height.equalTo(tableHeight / 2)
            }
        }
    }
    func mappingData(index: Int, isRight: Bool) {
        self.index = index
        question = DataManager.shared.testQuestionList[index]
        questionTV.text = "\(index+1)." + (question.question ?? "")
        
        /// 전체폰트 + 부분폰트 지정
        let bigNumFont = UIFont.boldSystemFont(ofSize: 30)
        let normalFont = UIFont.handBig()
        
        let attributedStr = NSMutableAttributedString(string: questionTV.text)
        attributedStr.addAttribute(.font,
                                   value: normalFont,
                                   range: (questionTV.text! as NSString).range(of: questionTV.text))
        attributedStr.addAttribute(.font,
                                   value: bigNumFont,
                                   range: (questionTV.text! as NSString).range(of: "\(index + 1)."))
        questionTV.attributedText = attributedStr
        
        
        
        if isRight {
            rightImage.image = UIImage(named: "맞은표시-파랑")
        } else {
            rightImage.image = UIImage(named: "틀린표시")
        }
        
        if question.isSubjective {
            myChoiceLabel.text = "내가 쓴 답은?  " + DataManager.shared.testAnswerList[index]
            rightAnswerLabel.text = "정답들은?!  "
        } else {
            myChoiceLabel.text = "내가 고른 답은?  " + DataManager.shared.testAnswerList[index]
            rightAnswerLabel.text = "정답은?!  " + (question.answer ?? "")
            rightAnswerTable.isHidden = true
        }
        explanationTV.text = question.explanation
    }
}

extension ExplanationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 0 { // 문제 보기 테이블
            return 43.5
        } else {
            return 43.5 / 2
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tableView.tag == 0 {
//            return question.answers!.count + 1
//        } else {
//            return question.answers!.count
//        }
        return question.answers!.count + 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0 { // 문제 보기 테이블
            let cell = tableView.dequeueReusableCell(withIdentifier: "TestAnswerCell", for: indexPath) as! TestAnswerCell
            var isCheck = false
            if DataManager.shared.testAnswerList[index] == DataManager.shared.orderingAnswers[index][indexPath.row] {
                isCheck = true
            }
            cell.setupLayout()
            cell.checkImage.isHidden = !isCheck
            cell.cancelLine.isHidden = true
            cell.xButton.isHidden = true
            
            cell.numImage.image = UIImage(systemName: String(indexPath.row + 1) + ".circle")
            cell.label.text = DataManager.shared.orderingAnswers[index][indexPath.row]
            
            return cell
        } else { // 주관식 답들 테이블
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
            if indexPath.row == 0 { // answer 로 세팅
                cell.textLabel?.text = question.answer
            } else { // answers로 세팅
                cell.textLabel?.text = question.answers?[indexPath.row - 1]
            }
            cell.textLabel?.textColor = UIColor.black
            cell.textLabel?.font = UIFont.handNormal()
            cell.backgroundColor = UIColor.clear
            return cell
        }
    }
}

extension ExplanationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 { // 문제 이미지들
            return question.questionImages!.count
        } else {
            return question.explanationImages!.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 사진 콜렉션 뷰
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        if collectionView.tag == 0 { // 문제 이미지들
            cell.imageView.image = UIImage(data: (question.questionImages?[indexPath.row])!)
        } else { // 풀이 이미지들
            cell.imageView.image = UIImage(data: (question.explanationImages?[indexPath.row])!)
        }
        cell.xButton.isHidden = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let imageViewController = ImageViewControllerForTest()
        if collectionView.tag == 0 { // 문제 이미지들
            imageViewController.imageView.image = UIImage(data: (question.questionImages?[indexPath.row])!)
        } else {
            imageViewController.imageView.image = UIImage(data: (question.explanationImages?[indexPath.row])!)
        }
        imageViewController.leftButton.addTarget(self, action: #selector(clickLeftButton), for: .touchUpInside)
        present(imageViewController, animated: true, completion: nil)
    }
    @objc func clickLeftButton() {
        dismiss(animated: true, completion: nil)
    }
}
