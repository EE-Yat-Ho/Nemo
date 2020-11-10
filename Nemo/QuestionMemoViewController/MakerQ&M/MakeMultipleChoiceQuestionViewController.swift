//
//  MakeMultipleChoiceQuestionViewController.swift
//  BrainSupporter2
//
//  Created by 박영호 on 2020/06/28.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class MakeMultipleChoiceQuestionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    var editTarget: Question?
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    // MARK:- Question
    let questionLabel = UILabel().then {
        $0.text = "질문"
    }
    lazy var questionCamera = UIButton().then {
        $0.setImage(UIImage(named: "이미지"), for: .normal)
        $0.addTarget(self, action: #selector(addQuestionImage), for: .touchUpInside)
    }
    let questionText = UITextView().then {
        $0.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 5.0
        $0.becomeFirstResponder()
    }
    
    lazy var questionImages = UICollectionView(
        frame: CGRect(x: 0, y: 0, width: 0, height: 0),
        collectionViewLayout: UICollectionViewFlowLayout().then {
            $0.itemSize = CGSize(width: collectionItemSize, height: collectionItemSize)
            $0.minimumInteritemSpacing = 0
            $0.minimumLineSpacing = 0}
        ).then{
            $0.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
            $0.layer.borderWidth = 1.0
            $0.layer.cornerRadius = 5.0
            $0.backgroundColor = UIColor(patternImage: UIImage(named: "배경")!)
            $0.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
            $0.tag = 1
        }
    // MARK:- Answer
    let answerTable = UITableView().then{
        $0.register(MultipleChoiceQuestionAnswerCell.self, forCellReuseIdentifier: "MultipleChoiceQuestionAnswerCell")
    }
    let answerLabel = UILabel().then {
        $0.text = "정답"
    }
    let plusButton = UIButton().then {
        $0.setImage(UIImage(named: "플러스"), for: .normal)
        $0.addTarget(self, action: #selector(plusButtonClick), for: .touchUpInside)
    }
    
    // MARK:- Explanation
    let explanationLabel = UILabel().then {
        $0.text = "풀이"
    }
    let explanationCamera = UIButton().then {
        $0.setImage(UIImage(named: "이미지"), for: .normal)
        $0.addTarget(self, action: #selector(addExplanationImage), for: .touchUpInside)
    }
    let explanationText = UITextView().then {
        $0.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 5.0
        $0.becomeFirstResponder()
    }
    lazy var explanationImages = UICollectionView(
        frame: CGRect(x: 0, y: 0, width: 0, height: 0),
        collectionViewLayout: UICollectionViewFlowLayout().then {
            $0.itemSize = CGSize(width: collectionItemSize, height: collectionItemSize)
            $0.minimumInteritemSpacing = 0
            $0.minimumLineSpacing = 0}
        ).then{
            $0.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
            $0.layer.borderWidth = 1.0
            $0.layer.cornerRadius = 5.0
            $0.backgroundColor = UIColor(patternImage: UIImage(named: "배경")!)
            $0.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
            $0.tag = 3
        }
    // MARK:- ETC Views
    let completeButton = UIButton().then{
        $0.setImage(UIImage(named: "완료버튼"), for: .normal)
    }
    
    
    // MARK:- Properties
    let collectionItemSize: CGFloat = (UIScreen.main.bounds.size.width - 40) / 3
    var questionCollectionHeight: CGFloat = 10.0
    var questionCollectionHeightAnchor: NSLayoutConstraint?
    var answerTableHeight: CGFloat! = 43.5 * 3
    var explanationCollectionHeight: CGFloat = 10.0
    var explanationCollectionHeightAnchor: NSLayoutConstraint?
    
    var listAmount: Int! = 3
    
    var imageButtonTag: Int!
    let imagePicker = UIImagePickerController()
    
    
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setupLayout()
        editCheck()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        questionImages.reloadData()
        explanationImages.reloadData()
    }
    
    func configure() {
        questionImages.delegate = self
        questionImages.dataSource = self
        explanationImages.delegate = self
        explanationImages.dataSource = self
        answerTable.delegate = self
        answerTable.dataSource = self
        scrollView.delegate = self
        
        DataManager.shared.answerList = ["","",""]
        DataManager.shared.rightList = [true,true,true]
        
        DataManager.shared.imageList_MC.removeAll()
        DataManager.shared.imageList_MC_2.removeAll()
        
        // 텍스트 필드에 초기값 회색으로 넣는거
        questionText.delegate = self
        explanationText.delegate = self
        
        questionText.tag = 1
        explanationText.tag = 3
    }
    
    func setupLayout() {
        view.backgroundColor = UIColor(patternImage: UIImage(named: "배경")!)
        contentView.backgroundColor = UIColor.clear
        
        additionalSafeAreaInsets.top = 43.5 // 위 탭바부분만큼 세이프 영역 내려버러기
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(questionLabel)
        contentView.addSubview(questionCamera)
        contentView.addSubview(questionText)
        contentView.addSubview(questionImages)
        contentView.addSubview(answerLabel)
        contentView.addSubview(plusButton)
        contentView.addSubview(answerTable)
        contentView.addSubview(explanationLabel)
        contentView.addSubview(explanationCamera)
        contentView.addSubview(explanationText)
        contentView.addSubview(explanationImages)
        contentView.addSubview(completeButton)
        
        
        scrollView.snp.makeConstraints{ $0.edges.equalTo(self.view.safeAreaLayoutGuide) }
        
        contentView.snp.makeConstraints{
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide.snp.width) }
        
        questionLabel.snp.makeConstraints{
            $0.top.equalTo(contentView.snp.top).inset(20)
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(20)
        }
        questionCamera.snp.makeConstraints{
            $0.top.equalTo(contentView.snp.top).inset(20)
            $0.leading.equalTo(questionLabel.snp.trailing).offset(10)
            $0.height.width.equalTo(20)
        }
        questionText.snp.makeConstraints{
            $0.top.equalTo(questionLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(135)
        }
        questionImages.snp.makeConstraints{
            $0.top.equalTo(questionText.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(10)
        }
        
        answerLabel.snp.makeConstraints{
            $0.top.equalTo(questionImages.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(20)
        }
        plusButton.snp.makeConstraints{
            $0.top.equalTo(questionImages.snp.bottom).offset(20)
            $0.leading.equalTo(answerLabel.snp.trailing).offset(10)
            $0.height.width.equalTo(20)
        }
        answerTable.snp.makeConstraints{
            $0.top.equalTo(answerLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(43.5 * 3)
        }
        
        explanationLabel.snp.makeConstraints{
            $0.top.equalTo(answerTable.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(20)
        }
        explanationCamera.snp.makeConstraints{
            $0.top.equalTo(answerTable.snp.bottom).offset(20)
            $0.leading.equalTo(questionLabel.snp.trailing).offset(10)
            $0.height.width.equalTo(20)
        }
        explanationText.snp.makeConstraints{
            $0.top.equalTo(explanationLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(135)
        }
        explanationImages.snp.makeConstraints{
            $0.top.equalTo(explanationText.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(10)
            $0.bottom.equalToSuperview().inset(100)
        }
        
        completeButton.snp.makeConstraints{
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(60)
        }
        
        // 텍스트 필드 테두리(border)설정
        questionText.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        questionText.layer.borderWidth = 1.0
        questionText.layer.cornerRadius = 5.0
        explanationText.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        explanationText.layer.borderWidth = 1.0
        explanationText.layer.cornerRadius = 5.0
        // 20200720 콜랜션 뷰 테두리 설정
        questionImages.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        questionImages.layer.borderWidth = 1.0
        questionImages.layer.cornerRadius = 5.0
        
        explanationImages.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        explanationImages.layer.borderWidth = 1.0
        explanationImages.layer.cornerRadius = 5.0
        // 20200728 확인버튼 테두리 설정
        completeButton.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        completeButton.layer.borderWidth = 1.0
        completeButton.layer.cornerRadius = 15.0
        
        answerTable.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        answerTable.layer.borderWidth = 1.0
        answerTable.layer.cornerRadius = 5.0
        
        questionCamera.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        questionCamera.layer.borderWidth = 1.0
        questionCamera.layer.cornerRadius = 5.0
        explanationCamera.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        explanationCamera.layer.borderWidth = 1.0
        explanationCamera.layer.cornerRadius = 5.0
        plusButton.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        plusButton.layer.borderWidth = 1.0
        plusButton.layer.cornerRadius = 5.0
    }
    
    func editCheck() {
        editTarget = (parent as! MakeQuestionViewController).editTarget
        if editTarget != nil { // 문제 편집일 경우
            questionText.text = editTarget?.question
            questionText.textColor = UIColor.black
            explanationText.text = editTarget?.explanation
            explanationText.textColor = UIColor.black
            
            for i in editTarget?.questionImages ?? [Data]() {
                DataManager.shared.imageList_MC.append(UIImage(data: i)!)
            }
            
            questionCollectionHeight = collectionItemSize * CGFloat((DataManager.shared.imageList.count + 2) / 3)
            if questionCollectionHeight == 0.0 { questionCollectionHeight = 10.0 }
            if questionCollectionHeight > collectionItemSize * 2.5 { questionCollectionHeight = collectionItemSize * 2.5}
            questionImages.snp.updateConstraints{
                $0.height.equalTo(questionCollectionHeight)
            }
            
            for i in editTarget?.explanationImages ?? [Data]() {
                DataManager.shared.imageList_MC_2.append(UIImage(data: i)!)
            }
            explanationCollectionHeight = collectionItemSize * CGFloat((DataManager.shared.imageList.count + 2) / 3)
            if explanationCollectionHeight == 0.0 { explanationCollectionHeight = 10.0 }
            if explanationCollectionHeight > collectionItemSize * 2.5 { explanationCollectionHeight = collectionItemSize * 2.5}
            explanationImages.snp.updateConstraints{
                $0.height.equalTo(explanationCollectionHeight)
            }
            
            if editTarget!.isSubjective == false {
                listAmount = (editTarget?.multipleChoiceWrongAnswers!.count)! + (editTarget?.multipleChoiceAnswers!.count)!
                DataManager.shared.answerList = (editTarget?.multipleChoiceAnswers)! + (editTarget?.multipleChoiceWrongAnswers)!
                DataManager.shared.rightList = [Bool](repeating: true, count: (editTarget?.multipleChoiceAnswers!.count)!) + [Bool](repeating: false, count: (editTarget?.multipleChoiceWrongAnswers!.count)!)
                
                answerTableHeight = CGFloat(listAmount) * 43.5
                answerTable.snp.updateConstraints{
                    $0.height.equalTo(answerTableHeight)
                }
            }
        }
    }
    
    
    // MARK:- Methods
    @objc func plusButtonClick() {
        if listAmount > 6 {
            
        }
        listAmount += 1
        answerTableHeight = CGFloat(listAmount) * 43.5
        answerTable.snp.updateConstraints{
            $0.height.equalTo(answerTableHeight)
        }
        
        DataManager.shared.answerList.append("")
        DataManager.shared.rightList.append(true)
        answerTable.reloadData()
    }
    @objc func OXbuttonClick(_ sender: UIButton) {
        let cell = sender.superview?.superview as! MultipleChoiceQuestionAnswerCell
        let indexPath = answerTable.indexPath(for: cell)! as IndexPath
        if cell.right == true {
            cell.OX.layer.borderColor = UIColor.systemRed.cgColor
            cell.OX.setTitleColor(UIColor.systemRed, for: .normal)
            cell.OX.setTitle("오답", for: .normal)
        } else {
            cell.OX.layer.borderColor = UIColor.systemGreen.cgColor
            cell.OX.setTitleColor(UIColor.systemGreen, for: .normal)
            cell.OX.setTitle("정답", for: .normal)
        }
        cell.right.toggle()
        DataManager.shared.rightList[indexPath.row].toggle()
    }
    @objc func xButtonClick(_ sender: UIButton) {
        let cell = sender.superview?.superview as! MultipleChoiceQuestionAnswerCell
        let indexPath = answerTable.indexPath(for: cell)! as IndexPath
        listAmount -= 1
        if listAmount < 0 { listAmount = 0 }
        answerTableHeight = CGFloat(listAmount) * 43.5
        answerTable.snp.updateConstraints{
            $0.height.equalTo(answerTableHeight)
        }
        DataManager.shared.answerList.remove(at: indexPath.row)
        DataManager.shared.rightList.remove(at: indexPath.row)
        answerTable.reloadData()
    }
    
    @objc func CompleteButtonClick() {
        //메모 갈아거 0이면 메모 입력하세요 띄우기
        if questionText.text.count < 1 || questionText.text == "질문 입력" {
            alert(message: "질문을 입력하세요")
            return
        }
        if explanationText.text.count < 1 || explanationText.text == "풀이 입력" {
            alert(message: "풀이를 입력하세요")
            return
        }
        if editTarget == nil { // 새로만드는 경우
            DataManager.shared.addNewQuestion(question: questionText.text, explanation: explanationText.text)
        } else { // 편집인 경우
            var dataList = [Data]()
            var dataList_2 = [Data]()
            editTarget?.questionImages?.removeAll()
            
            editTarget?.question = questionText.text
            editTarget?.explanation = explanationText.text
            editTarget?.isSubjective = true
            
            for i in DataManager.shared.imageList_MC {
                dataList.append(i.jpegData(compressionQuality: 0.01)!)
            }
            editTarget?.questionImages = dataList
            
            for i in DataManager.shared.imageList_MC_2 {
                dataList_2.append(i.jpegData(compressionQuality: 0.01)!)
            }
            editTarget?.explanationImages = dataList_2
            
            DataManager.shared.saveContext()
        }
        navigationController?.popViewController(animated: true)
    }
}

extension MakeMultipleChoiceQuestionViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    //20200720 사진을 고르는 화면 구현
    @objc func addQuestionImage() {
        imageButtonTag = 1
        self.openImagePicker()
    }
    @objc func addExplanationImage() {
        imageButtonTag = 3
        self.openImagePicker()
    }
    func openImagePicker(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey :Any]){
        dismiss(animated: true, completion: nil)
        if let img = info[.originalImage] as? UIImage{
            if imageButtonTag == 1 {
                DataManager.shared.imageList_MC.append(img)
                self.questionImages.reloadData()
                questionCollectionHeight = collectionItemSize * CGFloat((DataManager.shared.imageList_MC.count + 2) / 3)
                if questionCollectionHeight == 0.0 { questionCollectionHeight = 10.0 }
                if questionCollectionHeight > collectionItemSize * 2.5 { questionCollectionHeight = collectionItemSize * 2.5}
                questionImages.snp.updateConstraints{
                    $0.height.equalTo(questionCollectionHeight)
                }
            } else {
                DataManager.shared.imageList_MC_2.append(img)
                explanationCollectionHeight = collectionItemSize * CGFloat((DataManager.shared.imageList_MC_2.count + 2) / 3)
                if explanationCollectionHeight == 0.0 { explanationCollectionHeight = 10.0 }
                if explanationCollectionHeight > collectionItemSize * 2.5 { explanationCollectionHeight = collectionItemSize * 2.5}
                explanationImages.snp.updateConstraints{
                    $0.height.equalTo(explanationCollectionHeight)
                }
            }
        }
    }
}
    
extension MakeMultipleChoiceQuestionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // 20200720 올린 사진을 보여줄 콜랙션뷰 구현
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("imageList_MC.count = \(DataManager.shared.imageList_MC.count)")
        if collectionView.tag == 1 {
            return DataManager.shared.imageList_MC.count
        } else {
            return DataManager.shared.imageList_MC_2.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        print("indexPath.row = \(indexPath.row)" )
        
        if collectionView.tag == 1 {
            cell.imageView.image = DataManager.shared.imageList_MC[indexPath.row]
        } else {
            cell.imageView.image = DataManager.shared.imageList_MC_2[indexPath.row]
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        collectionView.deselectItem(at: indexPath, animated: true)
        print("You tapped me")
        let imageViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
        if collectionView.tag == 1 {
            imageViewController.img = DataManager.shared.imageList_MC[indexPath.row]
            imageViewController.tag = 1
        } else {
            imageViewController.img = DataManager.shared.imageList_MC_2[indexPath.row]
            imageViewController.tag = 2
        }
        imageViewController.idxPath = indexPath
        self.navigationController?.pushViewController(imageViewController, animated: true)
    }
}

    
extension MakeMultipleChoiceQuestionViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.tag == 1 {
            if textView.text == "질문 입력"{
                textView.text = ""
                textView.textColor = UIColor.black
            }
        } else {
            if textView.text == "풀이 입력"{
                textView.text = ""
                textView.textColor = UIColor.black
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.tag == 1 {
            if textView.text == ""{
                textView.text = "질문 입력"
                textView.textColor = UIColor.lightGray
            }
        } else {
            if textView.text == ""{
                textView.text = "풀이 입력"
                textView.textColor = UIColor.lightGray
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text == "\n"{
            textView.resignFirstResponder()
        }
        return true
    }
}

extension MakeMultipleChoiceQuestionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listAmount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.answerTable.dequeueReusableCell(withIdentifier: "MultipleChoiceQuestionAnswerCell", for: indexPath) as! MultipleChoiceQuestionAnswerCell
//        cell.num.text = String(indexPath.row + 1)
//        cell.contents.delegate = self
//        cell.contents.text = DataManager.shared.answerList[indexPath.row]
//        cell.right = DataManager.shared.rightList[indexPath.row]
//        cell.OX.layer.borderWidth = 1.0
//        cell.OX.layer.cornerRadius = 5.0
//        if cell.right == true {
//            cell.OX.layer.borderColor = UIColor.systemGreen.cgColor
//            cell.OX.setTitleColor(UIColor.systemGreen, for: .normal)
//            cell.OX.setTitle("정답", for: .normal)
//        } else {
//            cell.OX.layer.borderColor = UIColor.systemRed.cgColor
//            cell.OX.setTitleColor(UIColor.systemRed, for: .normal)
//            cell.OX.setTitle("오답", for: .normal)
//        }
        return cell
    }
}

extension MakeMultipleChoiceQuestionViewController: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {// 캬 완벽~
        let cell = textField.superview?.superview as! MultipleChoiceQuestionAnswerCell
        let indexPath = answerTable.indexPath(for: cell)
        DataManager.shared.answerList[indexPath!.row] = textField.text!
    }
}
