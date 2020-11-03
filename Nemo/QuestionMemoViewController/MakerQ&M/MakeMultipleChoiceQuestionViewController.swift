//
//  MakeMultipleChoiceQuestionViewController.swift
//  BrainSupporter2
//
//  Created by 박영호 on 2020/06/28.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class MakeMultipleChoiceQuestionViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    var editTarget: Question?
    @IBOutlet weak var QuestionInput: UITextView!
    @IBOutlet weak var AnswerTable: UITableView!
    @IBOutlet weak var ExplanationInput: UITextView!
    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var CollectionView_2: UICollectionView!
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var CompleteButton: UIButton!
    @IBOutlet weak var camera1: UIButton!
    @IBOutlet weak var camera2: UIButton!
    @IBOutlet weak var plus: UIButton!
    
    var CollectionViewHeightAnchor: NSLayoutConstraint?
    var CollectionView_2HeightAnchor: NSLayoutConstraint?
    var AnswerTableHeightAnchor: NSLayoutConstraint?
    var ContentViewHeightAnchor: NSLayoutConstraint?
    var CollectionViewHeight: CGFloat! = 10.0
    var CollectionView_2Height: CGFloat! = 10.0
    var AnswerTableHeight: CGFloat! = 43.5 * 5
    
    var listAmount: Int! = 5
    
    @IBAction func cancel(_ sender: Any) {
        //모달 방식은 디스미스 메소드 첫 파라미터가 트루면 전환 에니메이션 제공
        dismiss(animated: true, completion: nil)
    }
    @IBAction func save(_ sender: Any) {
        
    }
    @IBAction func CompleteButtonClick(_ sender: Any) {
        //메모 갈아거 0이면 메모 입력하세요 띄우기
        if QuestionInput.text.count < 1 || QuestionInput.text == "질문 입력" {
            alert(message: "질문을 입력하세요")
            return
        }
        if ExplanationInput.text.count < 1 || ExplanationInput.text == "풀이 입력" {
            alert(message: "풀이를 입력하세요")
            return
        }
        if editTarget == nil { // 새로만드는 경우
            DataManager.shared.addNewQuestion(question: QuestionInput.text, explanation: ExplanationInput.text)
        } else { // 편집인 경우
            var dataList = [Data]()
            var dataList_2 = [Data]()
            editTarget?.questionImages?.removeAll()
            
            editTarget?.question = QuestionInput.text
            editTarget?.explanation = ExplanationInput.text
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
        // 20200731 tabbarController 는 dismiss로 안사라짐. 네비게이션에서 팝해버리면됨.
        navigationController?.popViewController(animated: true)
        //dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            additionalSafeAreaInsets.top = 43.5 // 위 탭바부분만큼 세이프 영역 내려버러기
        } else {
            // Fallback on earlier versions
        }
        navigationController?.navigationBar.barTintColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        tabBarController?.tabBar.barTintColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        CollectionView.delegate = self
        CollectionView.dataSource = self
        CollectionView_2.delegate = self
        CollectionView_2.dataSource = self
        AnswerTable.delegate = self
        AnswerTable.dataSource = self
        // 텍스트 필드에 초기값 회색으로 넣는거
        QuestionInput.delegate = self
        ExplanationInput.delegate = self
        
        QuestionInput.tag = 1
        ExplanationInput.tag = 3
        
        // 텍스트 필드 테두리(border)설정
        QuestionInput.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        QuestionInput.layer.borderWidth = 1.0
        QuestionInput.layer.cornerRadius = 5.0
        ExplanationInput.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        ExplanationInput.layer.borderWidth = 1.0
        ExplanationInput.layer.cornerRadius = 5.0
        // 20200720 콜랜션 뷰 테두리 설정
        CollectionView.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        CollectionView.layer.borderWidth = 1.0
        CollectionView.layer.cornerRadius = 5.0
        
        CollectionView_2.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        CollectionView_2.layer.borderWidth = 1.0
        CollectionView_2.layer.cornerRadius = 5.0
        // 20200728 확인버튼 테두리 설정
        CompleteButton.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        CompleteButton.layer.borderWidth = 1.0
        CompleteButton.layer.cornerRadius = 15.0
        
        AnswerTable.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        AnswerTable.layer.borderWidth = 1.0
        AnswerTable.layer.cornerRadius = 15.0
        
        camera1.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        camera1.layer.borderWidth = 1.0
        camera1.layer.cornerRadius = 5.0
        camera2.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        camera2.layer.borderWidth = 1.0
        camera2.layer.cornerRadius = 5.0
        plus.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        plus.layer.borderWidth = 1.0
        plus.layer.cornerRadius = 5.0
        
        CompleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        // 20200721 콜렉션 뷰 레이아웃 지정이라는데.. 이거 안하니까 사진 한장일때 가운데 정렬되버림; 뭐 이상함..
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 110, height: 110)
        layout.minimumLineSpacing = 0
        let layout2 = UICollectionViewFlowLayout() // 도대체 왜 또만들어야하는지 ㅋㅋ ㅠ 내부 구현이 궁금하네 ㅠ
        layout2.itemSize = CGSize(width: 110, height: 110)
        layout2.minimumLineSpacing = 0

        CollectionView.collectionViewLayout = layout
        CollectionView_2.collectionViewLayout = layout2
        
        CollectionView.translatesAutoresizingMaskIntoConstraints = false
        CollectionViewHeightAnchor = CollectionView.heightAnchor.constraint(equalToConstant: CollectionViewHeight)
        CollectionViewHeightAnchor!.isActive = true
        
        CollectionView_2.translatesAutoresizingMaskIntoConstraints = false
        CollectionView_2HeightAnchor = CollectionView_2.heightAnchor.constraint(equalToConstant: CollectionViewHeight)
        CollectionView_2HeightAnchor!.isActive = true
        
        AnswerTable.translatesAutoresizingMaskIntoConstraints = false
        AnswerTableHeightAnchor = AnswerTable.heightAnchor.constraint(equalToConstant: AnswerTableHeight)
        AnswerTableHeightAnchor!.isActive = true
        
        ScrollView.delegate = self
        
        DataManager.shared.answerList = ["","","","",""]
        DataManager.shared.rightList = [true,true,true,true,true]
        self.AnswerTable.tableFooterView = UIView()
        
        DataManager.shared.imageList_MC.removeAll()
        DataManager.shared.imageList_MC_2.removeAll()
        let tabbarCR = self.tabBarController as! QuestionTabBarController
        editTarget = tabbarCR.editTarget
        if editTarget != nil { // 문제 편집일 경우
            QuestionInput.text = editTarget?.question
            QuestionInput.textColor = UIColor.black
            ExplanationInput.text = editTarget?.explanation
            ExplanationInput.textColor = UIColor.black
            
            for i in editTarget?.questionImages ?? [Data]() {
                DataManager.shared.imageList_MC.append(UIImage(data: i)!)
            }
            CollectionViewHeight = CGFloat((DataManager.shared.imageList_MC.count + 2) / 3) * 110
            if CollectionViewHeight == 0.0 { CollectionViewHeight = 10.0 }
            if CollectionViewHeight > 270.0 { CollectionViewHeight = 270.0}
            CollectionViewHeightAnchor?.isActive = false
            CollectionViewHeightAnchor = CollectionView.heightAnchor.constraint(equalToConstant: CollectionViewHeight)
            CollectionViewHeightAnchor?.isActive = true
            
            for i in editTarget?.explanationImages ?? [Data]() {
                DataManager.shared.imageList_MC_2.append(UIImage(data: i)!)
            }
            CollectionView_2Height = CGFloat((DataManager.shared.imageList_MC_2.count + 2) / 3) * 110
            if CollectionView_2Height == 0.0 { CollectionView_2Height = 10.0 }
            if CollectionView_2Height > 270.0 { CollectionView_2Height = 270.0}
            CollectionView_2HeightAnchor?.isActive = false
            CollectionView_2HeightAnchor = CollectionView_2.heightAnchor.constraint(equalToConstant: CollectionView_2Height)
            CollectionView_2HeightAnchor?.isActive = true
            
            if editTarget!.isSubjective == false {
                listAmount = (editTarget?.multipleChoiceWrongAnswers!.count)! + (editTarget?.multipleChoiceAnswers!.count)!
                DataManager.shared.answerList = (editTarget?.multipleChoiceAnswers)! + (editTarget?.multipleChoiceWrongAnswers)!
                DataManager.shared.rightList = [Bool](repeating: true, count: (editTarget?.multipleChoiceAnswers!.count)!) + [Bool](repeating: false, count: (editTarget?.multipleChoiceWrongAnswers!.count)!)
                
                AnswerTableHeight = CGFloat(listAmount) * 43.5
                AnswerTableHeightAnchor?.isActive = false
                AnswerTableHeightAnchor = AnswerTable.heightAnchor.constraint(equalToConstant: AnswerTableHeight)
                AnswerTableHeightAnchor?.isActive = true
            }
        }
        ContentView.translatesAutoresizingMaskIntoConstraints = false
        
        ContentViewHeightAnchor?.isActive = false
        ContentViewHeightAnchor = ContentView.heightAnchor.constraint(equalToConstant: 620 + CollectionViewHeight + CollectionView_2Height + AnswerTableHeight)
        ContentViewHeightAnchor!.isActive = true
        
        qImageButton.tag = 1
        eImageButton.tag = 2
        CollectionView.tag = 1
        CollectionView_2.tag = 2
        
    }
    
    override func viewWillAppear(_ animated: Bool) { 
        CollectionView.reloadData()
        CollectionView_2.reloadData()
    }
    
    //20200720 사진을 고르는 화면 구현
    @IBOutlet weak var qImageButton: UIButton! // tag = 1
    @IBOutlet weak var eImageButton: UIButton! // tag = 2
    var imageButtonTag: Int!
    let imagePicker = UIImagePickerController()
    @IBAction func addImageToQuestion(_ sender: UIButton) {
        imageButtonTag = sender.tag
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
                self.CollectionView.reloadData()
                CollectionViewHeight = CGFloat(((DataManager.shared.imageList_MC.count + 2) / 3) * 110)
                if CollectionViewHeight == 0 { CollectionViewHeight = 10 }
                if CollectionViewHeight > 270.0 { CollectionViewHeight = 270.0}
                CollectionViewHeightAnchor?.isActive = false
                CollectionViewHeightAnchor = CollectionView.heightAnchor.constraint(equalToConstant: CollectionViewHeight)
                CollectionViewHeightAnchor?.isActive = true
            } else {
                DataManager.shared.imageList_MC_2.append(img)
                self.CollectionView_2.reloadData()
                CollectionView_2Height = CGFloat(((DataManager.shared.imageList_MC_2.count + 2) / 3) * 110)
                if CollectionView_2Height == 0 { CollectionView_2Height = 10 }
                if CollectionView_2Height > 270.0 { CollectionView_2Height = 270.0}
                CollectionView_2HeightAnchor?.isActive = false
                CollectionView_2HeightAnchor = CollectionView_2.heightAnchor.constraint(equalToConstant: CollectionView_2Height)
                CollectionView_2HeightAnchor?.isActive = true
            }
            
            ContentViewHeightAnchor?.isActive = false
            ContentViewHeightAnchor = ContentView.heightAnchor.constraint(equalToConstant: 620 + CollectionViewHeight + CollectionView_2Height + AnswerTableHeight)
            ContentViewHeightAnchor?.isActive = true
            
        }
    }
    
    // 20200720 올린 사진을 보여줄 콜랙션뷰 구현
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
    @IBAction func plusButtonClick(_ sender: Any) {
        if listAmount > 6 {
            
        }
        listAmount += 1
        AnswerTableHeight = CGFloat(listAmount) * 43.5
        AnswerTableHeightAnchor?.isActive = false
        AnswerTableHeightAnchor = AnswerTable.heightAnchor.constraint(equalToConstant: AnswerTableHeight)
        AnswerTableHeightAnchor?.isActive = true
        
        ContentViewHeightAnchor?.isActive = false
        ContentViewHeightAnchor = ContentView.heightAnchor.constraint(equalToConstant: 620 + CollectionViewHeight + CollectionView_2Height + AnswerTableHeight)
        ContentViewHeightAnchor?.isActive = true
        
        DataManager.shared.answerList.append("")
        DataManager.shared.rightList.append(true)
        AnswerTable.reloadData()
    }
    @IBAction func OXbuttonClick(_ sender: UIButton) {
        let cell = sender.superview?.superview as! MultipleChoiceQuestionAnswerCell
        let indexPath = AnswerTable.indexPath(for: cell)! as IndexPath
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
    @IBAction func xButtonClick(_ sender: UIButton) {
        let cell = sender.superview?.superview as! MultipleChoiceQuestionAnswerCell
        let indexPath = AnswerTable.indexPath(for: cell)! as IndexPath
        listAmount -= 1
        if listAmount < 0 { listAmount = 0 }
        AnswerTableHeight = CGFloat(listAmount) * 43.5
        AnswerTableHeightAnchor?.isActive = false
        AnswerTableHeightAnchor = AnswerTable.heightAnchor.constraint(equalToConstant: AnswerTableHeight)
        AnswerTableHeightAnchor?.isActive = true
        
        ContentViewHeightAnchor?.isActive = false
        ContentViewHeightAnchor = ContentView.heightAnchor.constraint(equalToConstant: 620 + CollectionViewHeight + CollectionView_2Height + AnswerTableHeight)
        ContentViewHeightAnchor?.isActive = true
        
        DataManager.shared.answerList.remove(at: indexPath.row)
        DataManager.shared.rightList.remove(at: indexPath.row)
        AnswerTable.reloadData()
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
        let cell = self.AnswerTable.dequeueReusableCell(withIdentifier: "MultipleChoiceQuestionAnswerCell", for: indexPath) as! MultipleChoiceQuestionAnswerCell
        cell.num.text = String(indexPath.row + 1)
        cell.contents.delegate = self
        cell.contents.text = DataManager.shared.answerList[indexPath.row]
        cell.right = DataManager.shared.rightList[indexPath.row]
        cell.OX.layer.borderWidth = 1.0
        cell.OX.layer.cornerRadius = 5.0
        if cell.right == true {
            cell.OX.layer.borderColor = UIColor.systemGreen.cgColor
            cell.OX.setTitleColor(UIColor.systemGreen, for: .normal)
            cell.OX.setTitle("정답", for: .normal)
        } else {
            cell.OX.layer.borderColor = UIColor.systemRed.cgColor
            cell.OX.setTitleColor(UIColor.systemRed, for: .normal)
            cell.OX.setTitle("오답", for: .normal)
        }
        return cell
    }
}

extension MakeMultipleChoiceQuestionViewController: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {// 캬 완벽~
        let cell = textField.superview?.superview as! MultipleChoiceQuestionAnswerCell
        let indexPath = AnswerTable.indexPath(for: cell)
        DataManager.shared.answerList[indexPath!.row] = textField.text!
    }
}
