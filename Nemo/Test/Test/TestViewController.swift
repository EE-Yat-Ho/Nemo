//
//  TestViewController.swift
//  BrainSupporter2
//
//  Created by 박영호 on 2020/08/06.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    let timerImage = UIImageView().then {
        $0.image = UIImage(named: "타이머_선택")
    }
    let timerLabel = UILabel().then {
        $0.text = "00:00"
        $0.textColor = UIColor.white
        $0.font = UIFont.handNormal()
    }
    let progressNum = UILabel().then {
        $0.text = "0 / 0"
        $0.textColor = UIColor.white
        $0.font = UIFont.handNormal()
    }
    let progressBar = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
    }
    let progressBarBackground = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    let topView = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    let questionScrollView = UIScrollView()
    let contentView = UIView()
    let question = UITextView().then {
        $0.text = "1 + 1 = ?"
        $0.backgroundColor = UIColor.clear
        $0.isScrollEnabled = false
        $0.isEditable = false
        $0.font = UIFont.handBig()
        //$0.font = UIFont(name: "NotoSansKannada-Regular", size: 24)
    }
    let separator = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 0.5)
    }
    
    let tableView = UITableView().then {
        $0.register(TestAnswerCell.self, forCellReuseIdentifier: "TestAnswerCell")
        $0.separatorStyle = .none
        $0.backgroundColor = UIColor.clear
    }
    let answerInput = UITextField().then {
        //$0.becomeFirstResponder()
        $0.backgroundColor = UIColor.clear
        //$0.font = UIFont(name: "NotoSansKannada-Regular", size: 18)
        $0.contentHorizontalAlignment = .center
        $0.layer.borderWidth = 3
        $0.layer.borderColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 0.5)
        $0.layer.cornerRadius = 12.0
        $0.font = UIFont.handNormal()
        $0.autocorrectionType = UITextAutocorrectionType.no //키보드 상단 자동완성 끄기
        //$0.returnKeyType = UIReturnKeyType.done
        $0.clearButtonMode = UITextField.ViewMode.whileEditing // 지우기 버튼 추가
        //$0.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        $0.leftViewMode = .always
    }
    let nextButton = UIButton().then {
        $0.setTitle("다음문제", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.addTarget(self, action: #selector(clickNextQuestionButton), for: .touchUpInside)
        //$0.backgroundColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        //$0.layer.borderColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        $0.layer.borderWidth = 0
        $0.layer.cornerRadius = 12.0
        $0.titleLabel?.font = UIFont.handBig()
        $0.layer.masksToBounds = true
        $0.setBackgroundColor(color: Resource.buttonNormal, forState: .normal)
        $0.setBackgroundColor(color: Resource.buttonHighLight, forState: .highlighted)
    }
    
    let collectionItemSize: CGFloat = (UIScreen.main.bounds.size.width - 40) / 3
    
    lazy var imageCollectionView = UICollectionView(
        frame: CGRect(x: 0, y: 0, width: 0, height: 0),
        collectionViewLayout: UICollectionViewFlowLayout().then {
            $0.itemSize = CGSize(width: collectionItemSize, height: collectionItemSize)
            $0.minimumInteritemSpacing = 0
            $0.minimumLineSpacing = 0}
        ).then{
            $0.backgroundColor = UIColor.clear//(patternImage: UIImage(named: "배경")!)
            $0.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
            $0.isScrollEnabled = false
        }
    
    var tableHeight: CGFloat = 10
    var collectionHeight: CGFloat = 10

    var nowQuestion = Question()
    var useTime = -1
    var timer = Timer()
    var minute = -1
    var second = -1
    var isCheckList = [Bool]()
    var isExclusionList = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "배경")!)
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        questionScrollView.delegate = self
        navigationController?.navigationBar.isHidden = true
        
        /// 키보드 내리는 제스처 추가 >> 필요없어짐
//        let singleTapGestureRecognizerForScrollView = UITapGestureRecognizer(target: self, action: #selector(downKeyboard))
//        singleTapGestureRecognizerForScrollView.numberOfTapsRequired = 1
//        singleTapGestureRecognizerForScrollView.isEnabled = true
//        singleTapGestureRecognizerForScrollView.cancelsTouchesInView = false
//        questionScrollView.addGestureRecognizer(singleTapGestureRecognizerForScrollView)
//
//        let singleTapGestureRecognizerForView = UITapGestureRecognizer(target: self, action: #selector(downKeyboard))
//        singleTapGestureRecognizerForView.numberOfTapsRequired = 1
//        singleTapGestureRecognizerForView.isEnabled = true
//        singleTapGestureRecognizerForView.cancelsTouchesInView = false
//        view.addGestureRecognizer(singleTapGestureRecognizerForView)
        
        setupLayout()
        configure()
        
    }
    @objc func downKeyboard(){
         self.view.endEditing(true)
    }   

    func configure() {
        nowQuestion = DataManager.shared.testQuestionList[DataManager.shared.nowQNumber! - 1]
        answerInput.text = ""
        if nowQuestion.isSubjective == true { // 주관식
            tableView.alpha = 0.0
            //answerInput.alpha = 1.0
            answerInput.isEnabled = true
            answerInput.becomeFirstResponder()
            
        } else { // 객관식
            //answerInput.alpha = 0.0
            tableView.alpha = 1.0
            isCheckList = Array(repeating: false, count: nowQuestion.answers!.count + 1)
            isExclusionList = Array(repeating: false, count: nowQuestion.answers!.count + 1)
            tableView.reloadData()
            answerInput.backgroundColor = .lightGray
            view.endEditing(true)
            answerInput.isEnabled = false
        }
        
        DataManager.shared.imageList.removeAll()
        for i in nowQuestion.questionImages ?? [Data]() {
            DataManager.shared.imageList.append(UIImage(data: i)!)
        }

        imageCollectionView.reloadData()
        collectionHeight = collectionItemSize * CGFloat((DataManager.shared.imageList.count + 2) / 3)
//        if collectionHeight == 0.0 { collectionHeight = 10.0 }
//        if collectionHeight > collectionItemSize * 2.5 { collectionHeight = collectionItemSize * 2.5}
        imageCollectionView.snp.updateConstraints{
            $0.height.equalTo(collectionHeight)
        }

        timer.invalidate()
        useTime = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
        
        //bigNum.text = String(DataManager.shared.nowQNumber!) + "."
        question.text = String(DataManager.shared.nowQNumber!) + "." + DataManager.shared.testQuestionList[DataManager.shared.nowQNumber! - 1].question!
        
        /// 전체폰트 + 부분폰트 지정
        let bigNumFont = UIFont.boldSystemFont(ofSize: 30)
        let normalFont = UIFont.handBig()
        
        let attributedStr = NSMutableAttributedString(string: question.text)
        attributedStr.addAttribute(.font,
                                   value: normalFont,
                                   range: (question.text! as NSString).range(of: question.text))
        attributedStr.addAttribute(.font,
                                   value: bigNumFont,
                                   range: (question.text! as NSString).range(of: String(DataManager.shared.nowQNumber!) + "."))
        question.attributedText = attributedStr
    }
    
    
    
    func setupLayout() {
        progressNum.text = "0 / " + String(DataManager.shared.testQuestionList.count)
        
        topView.addSubview(timerImage)
        topView.addSubview(timerLabel)
        topView.addSubview(progressNum)
        topView.addSubview(progressBar)
        topView.addSubview(progressBarBackground)
        view.addSubview(topView)
        
        contentView.addSubview(question)
        contentView.addSubview(imageCollectionView)
        questionScrollView.addSubview(contentView)
        view.addSubview(questionScrollView)
        
        view.addSubview(separator)
        view.addSubview(tableView)
        view.addSubview(answerInput)
        view.addSubview(nextButton)
        
        topView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
        }
        timerImage.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.width.height.equalTo(20)
        }
        timerLabel.snp.makeConstraints{
            $0.centerY.equalTo(timerImage)
            $0.leading.equalTo(timerImage.snp.trailing).offset(5)
        }
        progressBarBackground.snp.makeConstraints{
            $0.top.equalTo(timerImage.snp.bottom).offset(5)
            $0.leading.equalTo(timerImage)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(topView.snp.bottom).offset(-15)
            $0.height.equalTo(3)
        }
        progressBar.snp.makeConstraints{
            $0.top.height.leading.bottom.equalTo(progressBarBackground)
            $0.width.equalTo(progressBarBackground.snp.width).multipliedBy(0.01)
        }
        progressNum.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(progressBarBackground.snp.top).offset(-8)
        }
        topView.bringSubviewToFront(progressBar)
        
        
        questionScrollView.snp.makeConstraints{
            $0.top.equalTo(topView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(answerInput.snp.top).offset(-10)
        }
        contentView.snp.makeConstraints{
            $0.edges.equalToSuperview()
            $0.width.equalTo(questionScrollView.frameLayoutGuide.snp.width)
        }
        
        question.snp.makeConstraints{
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            //$0.height.equalTo(500)//(135)
        }
        imageCollectionView.snp.makeConstraints{
            $0.top.equalTo(question.snp.bottom).offset(5)
            $0.height.equalTo(collectionHeight)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-10)
        }
        
        separator.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            //$0.centerY.equalToSuperview().offset(50)
            $0.bottom.equalToSuperview().offset(-UserDefaults.standard.double(forKey: "keyboardHeight"))
            $0.height.equalTo(3)
        }
        tableView.snp.makeConstraints{
            $0.top.equalTo(separator.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview()//(nextButton.snp.top)
        }
        answerInput.snp.makeConstraints{
            $0.bottom.equalTo(separator.snp.top).offset(-10)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalTo(nextButton.snp.leading).offset(-10)
            $0.height.equalTo(40)
            //$0.bottom.equalToSuperview()//(nextButton.snp.top).offset(-20)
        }
        nextButton.snp.makeConstraints{
            $0.bottom.equalTo(separator.snp.top).offset(-10)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.height.equalTo(40)
            $0.width.equalTo(100)
        }
    }
        
    @objc func timerCallback(){
        useTime += 1
        if useTime == DataManager.shared.timerTime {
            self.clickNextQuestionButton() // 뭐냐 이 애니클래스는
        }
        minute = useTime / 60
        second = useTime % 60
        if minute < 10 {
            timerLabel.text = "0"
        } else {
            timerLabel.text = ""
        }
        timerLabel.text! += String(minute) + ":"
        if second < 10 {
            timerLabel.text! += "0"
        }
        timerLabel.text! += String(second)
    }
    
    @objc func clickNextQuestionButton() {
        timerLabel.text = "00:00"
        if nowQuestion.isSubjective {
            DataManager.shared.testAnswerList.append(answerInput.text ?? "")
        } else {
            for (index, element) in isCheckList.enumerated() {
                if element == true {
                    DataManager.shared.testAnswerList.append(
                        DataManager.shared.orderingAnswers[DataManager.shared.nowQNumber! - 1][index])
                    break
                }
                
                if index == isCheckList.count - 1{ // 못찾음
                    DataManager.shared.testAnswerList.append("")
                }
            }
        }
        
        if DataManager.shared.nowQNumber! < DataManager.shared.nowQAmount! {
            DataManager.shared.nowQNumber! += 1
            configure()
            
            //tableView.alpha = 0.0
            //answerInput.alpha = 0.0
            imageCollectionView.alpha = 0.1
            //bigNum.alpha = 0.1
            question.alpha = 0.1
            progressBar.snp.remakeConstraints{
                $0.top.height.leading.bottom.equalTo(progressBarBackground)
                $0.width.equalTo(progressBarBackground.snp.width).multipliedBy(CGFloat(DataManager.shared.nowQNumber! - 1) / CGFloat(DataManager.shared.testQuestionList.count))
            }
            progressNum.text = String(DataManager.shared.nowQNumber! - 1) + " / " + String(DataManager.shared.testQuestionList.count)
            UIView.animate(withDuration: 0.3, animations: {[weak self] () -> Void  in
                if self?.nowQuestion.isSubjective == true { // 주관식
                    self?.answerInput.backgroundColor = .clear
                    self?.answerInput.isEnabled = true
                } else { // 객관식
                    self?.tableView.alpha = 1.0
                    self?.tableView.reloadData()
                    self?.answerInput.backgroundColor = .lightGray
                    self?.answerInput.isEnabled = false
                }
                //self?.answerInput.resignFirstResponder()
                self?.imageCollectionView.alpha = 1.0
                //self?.bigNum.alpha = 1.0
                self?.question.alpha = 1.0
               
                self?.imageCollectionView.reloadData()
                
                
            })
        } else {
            //마지막 화면
            timer.invalidate()
            navigationController?.pushViewController(EndTestTableViewController(), animated: true)
        }
    }
}

extension TestViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nowQuestion.questionImages!.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 사진 콜렉션 뷰
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.imageView.image = DataManager.shared.imageList[indexPath.row]
        cell.xButton.isHidden = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let imageViewController = ImageViewControllerForTest()
        imageViewController.imageView.image = DataManager.shared.imageList[indexPath.row]
        imageViewController.leftButton.addTarget(self, action: #selector(clickLeftButton), for: .touchUpInside)
        present(imageViewController, animated: true, completion: nil)
    }
    @objc func clickLeftButton() {
        dismiss(animated: true, completion: nil)
    }
}

extension TestViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if nowQuestion.isSubjective { return 0 }
        return (nowQuestion.answers ?? [""]).count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TestAnswerCell", for: indexPath) as! TestAnswerCell
        cell.delegate = self
        cell.mappingDate(index: indexPath.row, isCheck: isCheckList[indexPath.row], isExclusion: isExclusionList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isCheckList[indexPath.row] { // 정답 체크 해놓은 경우
            isCheckList[indexPath.row] = false
        } else { // 안해놓은 경우
            for i in 0..<isCheckList.count {
                if isCheckList[i] == true {
                    isCheckList[i] = false
                    tableView.reloadRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
                }
            }
            isCheckList[indexPath.row] = true
            isExclusionList[indexPath.row] = false
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)// reloadData()
    }
}

extension TestViewController: TestAnswerDelegate {
    func clickXButton(_ cell: TestAnswerCell) {
        if isExclusionList[cell.index] { // 빨간줄 끄여있을 경우
            isExclusionList[cell.index] = false
        } else { // 안끄여 있을 경우
            isCheckList[cell.index] = false
            isExclusionList[cell.index] = true
        }
        tableView.reloadRows(at: [IndexPath(row: cell.index, section: 0)], with: .automatic)//reloadData()
    }
}
