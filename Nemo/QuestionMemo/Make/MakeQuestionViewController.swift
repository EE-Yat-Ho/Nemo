//
//  MakeMultipleChoiceQuestionViewController.swift
//  BrainSupporter2
//
//  Created by 박영호 on 2020/06/28.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class MakeQuestionViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    var editTarget: Question?
    var isSubjective: Bool = false
    
    let multipleChoiceQuestionButton = UIButton().then{
        $0.setTitle("객관식", for: .normal)
        $0.setTitleColor(UIColor.systemBlue, for: .normal)
        $0.addTarget(self, action: #selector(setMCQ), for: .touchUpInside)
        $0.titleLabel?.font = UIFont.handNormal()
    }
    let subjectQuestionButton = UIButton().then{
        $0.setTitle("주관식", for: .normal)
        $0.setTitleColor(UIColor.systemBlue, for: .normal)
        $0.addTarget(self, action: #selector(setSQ), for: .touchUpInside)
        $0.titleLabel?.font = UIFont.handNormal()
    }
    let separateView = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
    }
    let separateView2 = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    }
    let containerView = UIView()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    // MARK:- Question
    let questionLabel = UILabel().then {
        $0.text = "문제의 질문을 써주세요!"
        $0.adjustsFontSizeToFitWidth = true
    }
    lazy var questionCamera = UIButton().then {
        $0.setImage(UIImage(named: "image"), for: .normal)
        $0.addTarget(self, action: #selector(addQuestionImage), for: .touchUpInside)
        $0.setTitle("사진 추가", for: .normal)
        $0.titleLabel?.font = UIFont.handNormal()
        $0.setTitleColor(#colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
    }
    let questionText = UITextView().then {
        $0.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 5.0
        $0.becomeFirstResponder()
        $0.tag = 1
        $0.backgroundColor = UIColor.clear
        //$0.font = UIFont.systemFont(ofSize: 15)
        $0.autocorrectionType = UITextAutocorrectionType.no
        $0.font = UIFont.handNormal()
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
            $0.backgroundColor = UIColor(patternImage: UIImage(named: "background_paper")!)
            $0.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
            $0.tag = 1
        }
    // MARK:- Answer
    let answerLabel = UILabel().then {
        $0.text = "정답은 무엇인가요?"
        $0.textColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        $0.adjustsFontSizeToFitWidth = true
    }
    let answerTextField = UITextField().then {
        $0.placeholder = "입력해주세요."
        //$0.font = UIFont.systemFont(ofSize: 15)
        $0.borderStyle = UITextField.BorderStyle.roundedRect
        $0.autocorrectionType = UITextAutocorrectionType.no
        $0.keyboardType = UIKeyboardType.default
        $0.returnKeyType = UIReturnKeyType.done
        $0.clearButtonMode = UITextField.ViewMode.whileEditing
        $0.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 5
        $0.layer.borderColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        $0.backgroundColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 0.2)
        $0.font = UIFont.handNormal()
    }
    
    let wrongLabel = UILabel().then {
        $0.text = "보기에 섞을 오답들..!"
        $0.textColor = UIColor.red
        $0.adjustsFontSizeToFitWidth = true
    }
    let plusButton = UIButton().then {
        $0.setImage(UIImage(named: "plus"), for: .normal)
        $0.addTarget(self, action: #selector(plusButtonClick), for: .touchUpInside)
        $0.setTitle("답안 추가", for: .normal)
        $0.titleLabel?.font = UIFont.handNormal()
        $0.setTitleColor(#colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
    let answerTable = UITableView().then{
        $0.register(QuestionAnswerCell.self, forCellReuseIdentifier: "QuestionAnswerCell")
        $0.separatorStyle = .none
        $0.backgroundColor = UIColor.clear
        $0.isScrollEnabled = false
        $0.allowsSelection = false
    }
    
    // MARK:- Explanation
    let explanationLabel = UILabel().then {
        $0.text = "일목요연한 풀이를 적어주세요."
        $0.adjustsFontSizeToFitWidth = true
    }
    let explanationCamera = UIButton().then {
        $0.setImage(UIImage(named: "image"), for: .normal)
        $0.addTarget(self, action: #selector(addExplanationImage), for: .touchUpInside)
        $0.setTitle("사진 추가", for: .normal)
        $0.titleLabel?.font = UIFont.handNormal()
        $0.setTitleColor(#colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
    }
    let explanationText = UITextView().then {
        $0.text = "풀이 입력"
        $0.textColor = UIColor.lightGray
        $0.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 5.0
        $0.tag = 3
        $0.backgroundColor = UIColor.clear
        //$0.font = UIFont.systemFont(ofSize: 15)
        $0.autocorrectionType = UITextAutocorrectionType.no
        $0.font = UIFont.handNormal()
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
            $0.backgroundColor = UIColor(patternImage: UIImage(named: "background_paper")!)
            $0.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
            $0.tag = 3
        }
    // MARK:- ETC Views
    let completeButton = UIButton().then{
        //$0.backgroundColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        $0.setTitle("완료", for: .normal)
        $0.addTarget(self, action: #selector(clickCompleteButton), for: .touchUpInside)
        //$0.layer.borderColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        $0.layer.borderWidth = 0.0
        $0.layer.cornerRadius = 5.0
        $0.titleLabel?.font = UIFont.handBig()
        $0.layer.masksToBounds = true
        $0.setBackgroundColor(color: Resource.buttonNormal, forState: .normal)
        $0.setBackgroundColor(color: Resource.buttonHighLight, forState: .highlighted)
    }
    let touchesBeganButton = UIButton().then {
        $0.setImage(nil, for: .normal)
        $0.addTarget(self, action: #selector(keyBoardDown), for: .touchUpInside)
    }
    
    @objc func keyBoardDown() {
        self.view.endEditing(true)
    }
    
    
    // MARK:- Properties
    let collectionItemSize: CGFloat = (UIScreen.main.bounds.size.width - 40) / 3
    var questionCollectionHeight: CGFloat = 10.0
    var answerTableHeight: CGFloat! = 44 * 3
    var explanationCollectionHeight: CGFloat = 10.0
    
    var imageButtonTag: Int!
    let imagePicker = UIImagePickerController()
    
    
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setupLayout()
        editProcessor()
        isEdited = false
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "완료", style: UIBarButtonItem.Style.plain, target: self,
                            action: #selector(clickCompleteButton(_:)))
        
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(title: "《 " + (DataManager.shared.nowNoteName ?? "오답노트"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancel))
    }
   
    
    override func viewWillAppear(_ animated: Bool) {
        questionImages.reloadData()
        explanationImages.reloadData()
        
        tabBarController?.tabBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(KeyBoardwillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
                       
        NotificationCenter.default.addObserver(self, selector: #selector(KeyBoardwillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    var isEnd = false
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        if !isEnd {
            tabBarController?.tabBar.isHidden = false
        } else {
            navigationController?.navigationBar.isHidden = true
        }
    }
    
    func configure() {
        questionImages.delegate = self
        questionImages.dataSource = self
        explanationImages.delegate = self
        explanationImages.dataSource = self
        answerTable.delegate = self
        answerTable.dataSource = self
        scrollView.delegate = self
        
        // 텍스트 필드에 초기값 회색으로 넣는거
        questionText.delegate = self
        explanationText.delegate = self
        answerTextField.delegate = self
    }
    @objc func KeyBoardwillShow(_ noti : Notification ){
        let keyboardHeight = ((noti.userInfo as! NSDictionary).value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.height
        UserDefaults.standard.setValue(keyboardHeight, forKey: "keyboardHeight")
        containerView.snp.updateConstraints{
            $0.bottom.equalToSuperview().offset(-keyboardHeight)
        }
    }
    @objc func KeyBoardwillHide(_ noti : Notification ){
        containerView.snp.updateConstraints{
            $0.bottom.equalToSuperview()
        }
    }
    func setupLayout() {
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background_paper")!)
        //contentView.backgroundColor = UIColor.clear
        
        containerView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(questionLabel)
        contentView.addSubview(questionCamera)
        contentView.addSubview(questionText)
        contentView.addSubview(questionImages)
        contentView.addSubview(answerLabel)
        contentView.addSubview(answerTextField)
        contentView.addSubview(wrongLabel)
        contentView.addSubview(plusButton)
        contentView.addSubview(answerTable)
        contentView.addSubview(explanationLabel)
        contentView.addSubview(explanationCamera)
        contentView.addSubview(explanationText)
        contentView.addSubview(explanationImages)
        contentView.addSubview(completeButton)
        
        /// ㅋㅋㅋㅋ 키보드 내리는거 결국 이캐하네
        contentView.addSubview(touchesBeganButton)
        touchesBeganButton.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        contentView.sendSubviewToBack(touchesBeganButton)
        /// 굳
        
        //아래는 합치는 작업들
        view.addSubview(multipleChoiceQuestionButton)
        view.addSubview(subjectQuestionButton)
        view.addSubview(separateView)
        view.addSubview(separateView2)
        view.addSubview(containerView)
        
        multipleChoiceQuestionButton.snp.makeConstraints{
            $0.top.leading.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(35)
            $0.width.equalTo(UIScreen.main.bounds.size.width / 2)
        }
        subjectQuestionButton.snp.makeConstraints{
            $0.top.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(35)
            $0.width.equalTo(UIScreen.main.bounds.size.width / 2)
        }
        separateView.snp.makeConstraints{
            $0.top.equalTo(multipleChoiceQuestionButton.snp.bottom)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(UIScreen.main.bounds.size.width / 2 - 40)
            $0.height.equalTo(3)
        }
        separateView2.snp.makeConstraints{
            $0.top.equalTo(separateView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        containerView.snp.makeConstraints{
            $0.top.equalTo(separateView2.snp.bottom)
            $0.bottom.trailing.leading.equalToSuperview()
        }
        //위에는 합치는 작업들
        
        
        scrollView.snp.makeConstraints{ $0.edges.equalToSuperview() }
        
        contentView.snp.makeConstraints{
            $0.edges.equalToSuperview()
            //$0.top.bottom.trailing.leading.equalToSuperview()
            $0.width.equalTo(scrollView.frameLayoutGuide.snp.width) }
        
        questionLabel.snp.makeConstraints{
            $0.top.equalTo(contentView.snp.top).inset(20)
            $0.trailing.equalTo(questionCamera.snp.leading)
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(20)
        }
        questionCamera.snp.makeConstraints{
            $0.top.equalTo(contentView.snp.top).inset(20)
            //$0.leading.equalTo(questionLabel.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(20)
            $0.width.equalTo(110)
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
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(20)
        }
        answerTextField.snp.makeConstraints{
            $0.top.equalTo(answerLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-65)
        }
        
        wrongLabel.snp.makeConstraints{
            $0.top.equalTo(answerTextField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(plusButton.snp.leading)
            $0.height.equalTo(20)
        }
        plusButton.snp.makeConstraints{
            $0.top.equalTo(answerTextField.snp.bottom).offset(20)
            //$0.leading.equalTo(wrongLabel.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(20)
            $0.width.equalTo(115)
        }
        answerTable.snp.makeConstraints{
            $0.top.equalTo(wrongLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(44 * 3)
        }
        
        explanationLabel.snp.makeConstraints{
            $0.top.equalTo(answerTable.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(explanationCamera.snp.leading)
            $0.height.equalTo(20)
        }
        explanationCamera.snp.makeConstraints{
            $0.top.equalTo(answerTable.snp.bottom).offset(20)
            //$0.leading.equalTo(questionLabel.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(20)
            $0.width.equalTo(110)
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
        }
        
        completeButton.snp.makeConstraints{
            $0.top.equalTo(explanationImages.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(50)
            $0.height.equalTo(40)
        }
    }
    
    func editProcessor() {
        guard let editTarget = self.editTarget else {
            DataManager.shared.answerList = ["","",""]
            DataManager.shared.imageList.removeAll()
            DataManager.shared.imageList2.removeAll()
            return
        }
        questionText.text = editTarget.question
        questionText.textColor = UIColor.black
        explanationText.text = editTarget.explanation
        explanationText.textColor = UIColor.black
        
        DataManager.shared.imageList = []
        for i in editTarget.questionImages ?? [Data]() {
            DataManager.shared.imageList.append(UIImage(data: i)!)
        }
        
        questionCollectionHeight = collectionItemSize * CGFloat((DataManager.shared.imageList.count + 2) / 3)
        if questionCollectionHeight == 0.0 { questionCollectionHeight = 10.0 }
        if questionCollectionHeight > collectionItemSize * 2.5 { questionCollectionHeight = collectionItemSize * 2.5}
        questionImages.snp.updateConstraints{
            $0.height.equalTo(questionCollectionHeight)
        }
        
        DataManager.shared.imageList2 = []
        for i in editTarget.explanationImages ?? [Data]() {
            DataManager.shared.imageList2.append(UIImage(data: i)!)
        }
        explanationCollectionHeight = collectionItemSize * CGFloat((DataManager.shared.imageList2.count + 2) / 3)
        if explanationCollectionHeight == 0.0 { explanationCollectionHeight = 10.0 }
        if explanationCollectionHeight > collectionItemSize * 2.5 { explanationCollectionHeight = collectionItemSize * 2.5}
        explanationImages.snp.updateConstraints{
            $0.height.equalTo(explanationCollectionHeight)
        }
        
        DataManager.shared.answerList = editTarget.answers!
        answerTextField.text = editTarget.answer
            
        answerTableHeight = CGFloat(DataManager.shared.answerList.count) * 44
        answerTable.snp.updateConstraints{
            $0.height.equalTo(answerTableHeight)
        }
        
        if editTarget.isSubjective {
            setSQ()
        } else {
            setMCQ()
        }
    }
    @objc func setMCQ() {
        if !isSubjective { return }
        isEdited = true
        isSubjective.toggle()
        answerTable.reloadData()
        
        wrongLabel.text = "보기에 섞을 오답들..!"
        wrongLabel.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
        separateView.snp.updateConstraints{
            $0.leading.equalToSuperview().offset(20)
        }
    }
    
    @objc func setSQ() {
        if isSubjective { return }
        isEdited = true
        isSubjective.toggle()
        answerTable.reloadData()
        
        wrongLabel.text = "주관식은 답이 여러개일 수 있죠!"
        wrongLabel.textColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        
        separateView.snp.updateConstraints{
            $0.leading.equalToSuperview().offset(UIScreen.main.bounds.size.width / 2 + 20 )
        }
    }
    
    // MARK:- Methods
    @objc func plusButtonClick() {
        if DataManager.shared.answerList.count > 4 {
            // 팝업
            alert(message: "답안은 5개까지만 가능해요..ㅠㅠ")
            return
        }
        DataManager.shared.answerList.append("")
        
        answerTableHeight = CGFloat(DataManager.shared.answerList.count) * 44
        answerTable.snp.updateConstraints{
            $0.height.equalTo(answerTableHeight)
        }
        isEdited = true
        answerTable.reloadData()
    }
   
    ///20210101 그냥 나갈때 저장할지 물어보기
    var isEdited = false
    @objc func cancel() {
        if editTarget == nil { // 새로 만드는 경우, 뭐든 처음과 다르면 수정된 것이라 여김
            for string in DataManager.shared.answerList {
                if string != "" {
                    isEdited = true
                    break
                }
            }
        } else { // 이미 만든 경우
            // 정답들의 갯수가 다를 경우 볼것도 없이 수정한 것.
            if editTarget?.answers?.count != DataManager.shared.answerList.count {
                isEdited = true
            } else { // 정답들의 갯수가 같으면 스트링 비교.
                for i in 0...DataManager.shared.answerList.count - 1 {
                    if DataManager.shared.answerList[i] != editTarget?.answers?[i]  {
                        isEdited = true
                        break
                    }
                }
            }
        }
        
        /// 변경사항이 있다
        if isEdited {
            let alert = UIAlertController(title: "저장할까요!?", message: "", preferredStyle: .alert)
            let justOut = UIAlertAction(title: "그냥 나가기", style: .destructive, handler: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            alert.addAction(justOut)
            let saveAndOut = UIAlertAction(title: "저장 후 나가기", style: .cancel, handler: clickCompleteButton(_:))
            alert.addAction(saveAndOut)
            let cancel = UIAlertAction(title: "취소", style: .default, handler: nil)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }
        else {
            navigationController?.popViewController(animated: true)
        }
    }

    @objc func clickCompleteButton(_ sender: Any) {
        //메모 갈아거 0이면 메모 입력하세요 띄우기
        if questionText.text.count < 1 || questionText.text == "질문 입력" {
            questionText.becomeFirstResponder()
            alert(message: "질문을 입력해주세요!")
            return
        }
        if explanationText.text.count < 1 || explanationText.text == "풀이 입력" {
            explanationText.becomeFirstResponder()
            alert(message: "풀이를 입력해주세요!")
            return
        }
        
        /// 20210101 빈 답 불가
        if answerTextField.text == "" {
            answerTextField.becomeFirstResponder()
            alert(message: "답을 입력해주세요!")
            return
        }
        for (index, string) in DataManager.shared.answerList.enumerated() {
            if string == "" {
                (answerTable.cellForRow(at: IndexPath(row: index,section: 0)) as! QuestionAnswerCell).contents.becomeFirstResponder()
                alert(message: "답을 입력해주세요!")

                return
            }
        }
        
        /// 20210101 중복 답 불가
        for (index, string) in DataManager.shared.answerList.enumerated() {
            if answerTextField.text == string {
                (answerTable.cellForRow(at: IndexPath(row: index,section: 0)) as! QuestionAnswerCell).contents.becomeFirstResponder()
                alert(message: "중복된 답을 제거해주세요!")

                return
            }
        }
        let answersSize = DataManager.shared.answerList.count
        if answersSize > 1 {
            for i in 0...answersSize - 2 {
                for j in i + 1...answersSize - 1 {
                    if DataManager.shared.answerList[i] == DataManager.shared.answerList[j] {
                        (answerTable.cellForRow(at: IndexPath(row: j,section: 0)) as! QuestionAnswerCell).contents.becomeFirstResponder()
                        alert(message: "중복된 답을 제거해주세요!")
                        
                        return
                    }
                }
            }
        }
        
        if editTarget == nil { // 새로만드는 경우
            DataManager.shared.addNewQuestion(question: questionText.text, answer: answerTextField.text,explanation: explanationText.text, isSubjective: isSubjective)
        } else { // 편집인 경우
            editTarget?.question = questionText.text
            editTarget?.explanation = explanationText.text
            editTarget?.answer = answerTextField.text
            editTarget?.answers = DataManager.shared.answerList
            editTarget?.questionImages = DataManager.shared.imageList.map{ $0.jpegData(compressionQuality: 0.01)!}
            editTarget?.explanationImages = DataManager.shared.imageList2.map{ $0.jpegData(compressionQuality: 0.01)!}
            editTarget?.isSubjective = isSubjective
            editTarget?.date = Date()
            
            DataManager.shared.saveContext()
        }
        navigationController?.popViewController(animated: true)
    }
}

extension MakeQuestionViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    //20200720 사진을 고르는 화면 구현
    @objc func addQuestionImage() {
        if DataManager.shared.imageList.count > 5 {
            let alert = UIAlertController(title: "사진은 6개까지만 가능해요.", message: "", preferredStyle: .alert)
        
            let okAction = UIAlertAction(title: "확인",  style: .default)
            alert.addAction(okAction) // 알림창에 버튼 객체 추가
        
            present(alert, animated: true, completion: nil) // 완
            return
        }
        
        imageButtonTag = 1
        self.openImagePicker()
    }
    @objc func addExplanationImage() {
        if DataManager.shared.imageList2.count > 5 {
            let alert = UIAlertController(title: "사진은 6개까지만 가능해요.", message: "", preferredStyle: .alert)
        
            let okAction = UIAlertAction(title: "확인",  style: .default)
            alert.addAction(okAction) // 알림창에 버튼 객체 추가
        
            present(alert, animated: true, completion: nil) // 완
            return
        }
        
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
            isEdited = true
            if imageButtonTag == 1 {
                DataManager.shared.imageList.append(img)
                questionImages.reloadData()
                questionCollectionHeight = collectionItemSize * CGFloat((DataManager.shared.imageList.count + 2) / 3)
                if questionCollectionHeight == 0.0 { questionCollectionHeight = 10.0 }
                if questionCollectionHeight > collectionItemSize * 2.5 { questionCollectionHeight = collectionItemSize * 2.5}
                questionImages.snp.updateConstraints{
                    $0.height.equalTo(questionCollectionHeight)
                }
            } else {
                DataManager.shared.imageList2.append(img)
                explanationImages.reloadData()
                explanationCollectionHeight = collectionItemSize * CGFloat((DataManager.shared.imageList2.count + 2) / 3)
                if explanationCollectionHeight == 0.0 { explanationCollectionHeight = 10.0 }
                if explanationCollectionHeight > collectionItemSize * 2.5 { explanationCollectionHeight = collectionItemSize * 2.5}
                explanationImages.snp.updateConstraints{
                    $0.height.equalTo(explanationCollectionHeight)
                }
            }
        }
    }
}

extension MakeQuestionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.answerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.answerTable.dequeueReusableCell(withIdentifier: "QuestionAnswerCell", for: indexPath) as! QuestionAnswerCell
        cell.delegate = self
        cell.mappingData(index: indexPath.row, isSubjective: isSubjective)
        return cell
    }
}

    
extension MakeQuestionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // 20200720 올린 사진을 보여줄 콜랙션뷰 구현
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return DataManager.shared.imageList.count
        } else {
            return DataManager.shared.imageList2.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.delegate = self
        cell.mappingData(index: indexPath.row, tag: collectionView.tag)

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        collectionView.deselectItem(at: indexPath, animated: true)
        let imageViewController = ImageViewController()
        if collectionView.tag == 1 {
            imageViewController.imageView.image = DataManager.shared.imageList[indexPath.row]
        } else {
            imageViewController.imageView.image = DataManager.shared.imageList2[indexPath.row]
        }
        imageViewController.tag = collectionView.tag
        imageViewController.index = indexPath.row
        self.navigationController?.pushViewController(imageViewController, animated: true)
    }
}

    
extension MakeQuestionViewController: UITextViewDelegate {
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
        if textView.text == "\n" {
            textView.resignFirstResponder()
        }
        isEdited = true
        return true
    }
}



extension MakeQuestionViewController: QuestionAnswerDelegate {
    func clickXButton(_ cell: QuestionAnswerCell) {
        DataManager.shared.answerList.remove(at: cell.index)
        answerTableHeight = CGFloat(DataManager.shared.answerList.count) * 44
        answerTable.snp.updateConstraints{
            $0.height.equalTo(answerTableHeight)
        }
        answerTable.reloadData()
        isEdited = true
    }
    
    func textFieldDidChangeSelection(_ cell: QuestionAnswerCell) {
       
        if cell.index < DataManager.shared.answerList.count {
            DataManager.shared.answerList[cell.index] = cell.contents.text!
            //isEdited = true 얘는 처음부터 트루 박아버려서 안됨
        }
    }
}
extension MakeQuestionViewController: CollectionDelegate {
    func clickXButton(_ cell: CollectionViewCell) {
        isEdited = true
        if cell.collectionTag == 1 {
            DataManager.shared.imageList.remove(at: cell.index)
            questionCollectionHeight = collectionItemSize * CGFloat((DataManager.shared.imageList.count + 2) / 3)
            if questionCollectionHeight == 0.0 { questionCollectionHeight = 10.0 }
            if questionCollectionHeight > collectionItemSize * 2.5 { questionCollectionHeight = collectionItemSize * 2.5}
            questionImages.snp.updateConstraints{
                $0.height.equalTo(questionCollectionHeight)
            }
            questionImages.reloadData()
        } else {
            DataManager.shared.imageList2.remove(at: cell.index)
            explanationCollectionHeight = collectionItemSize * CGFloat((DataManager.shared.imageList2.count + 2) / 3)
            if explanationCollectionHeight == 0.0 { explanationCollectionHeight = 10.0 }
            if explanationCollectionHeight > collectionItemSize * 2.5 { explanationCollectionHeight = collectionItemSize * 2.5}
            explanationImages.snp.updateConstraints{
                $0.height.equalTo(explanationCollectionHeight)
            }
            explanationImages.reloadData()
        }
    }
}

extension MakeQuestionViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        isEdited = true
    }
}
