//
//  MakeMemoViewController.swift
//  BrainSupporter2
//
//  Created by 박영호 on 2020/07/12.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class MakeMemoViewController: UIViewController {
    var editTarget: Memo?
    
    var memoLabel = UILabel().then{
        $0.text = "메모 내용"
    }
    var cameraButton = UIButton().then{
        $0.setImage(UIImage(named: "이미지"), for: .normal)
    }
    var memoContent = UnderlinedTextView().then{
        $0.tag = 1
        $0.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 5.0
        $0.becomeFirstResponder()
    }
    lazy var collectionView = UICollectionView(
        frame: CGRect(x: 0, y: 0, width: 0, height: 0),
        collectionViewLayout: layout).then{
        $0.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 5.0
        $0.backgroundColor = UIColor(patternImage: UIImage(named: "배경")!)
    }
    var collectionViewHeight: CGFloat! = 10.0
    var collectionViewHeightAnchor: NSLayoutConstraint?
    let layout = UICollectionViewFlowLayout().then{
        $0.itemSize = CGSize(width: 110, height: 110)
        $0.minimumLineSpacing = 0
    }
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        memoContent.delegate = self
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "완료", style: UIBarButtonItem.Style.plain, target: nil,
                            action: #selector(save(_:)))
        navigationController?.navigationItem.title = "필기 만들기"
        
        setupLayout()
        dataLoad()
    }
    
    func setupLayout() {
        view.backgroundColor = UIColor(patternImage: UIImage(named: "배경")!)
        
        view.addSubview(memoLabel)
        view.addSubview(cameraButton)
        view.addSubview(memoContent)
        view.addSubview(collectionView)
        
        
        memoLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(20)
        }
        cameraButton.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.leading.equalTo(memoLabel.snp.trailing).offset(10)
            $0.height.width.equalTo(20)
        }
        memoContent.snp.makeConstraints{
            $0.top.equalTo(memoLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(135)
        }
        collectionView.snp.makeConstraints{
            $0.top.equalTo(memoContent.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(10)
        }
    }
    
    func dataLoad() {
        guard let editTarget = editTarget else {return}
        
        memoContent.text = editTarget.content
        
        DataManager.shared.imageList.removeAll()
        for i in editTarget.images ?? [Data]() {
            DataManager.shared.imageList.append(UIImage(data: i)!)
        }
        collectionViewHeight = CGFloat((DataManager.shared.imageList.count + 2) / 3) * 110
        if collectionViewHeight == 0.0 { collectionViewHeight = 10.0 }
        if collectionViewHeight > 270.0 { collectionViewHeight = 270.0}
        collectionView.snp.updateConstraints{
            $0.height.equalTo(collectionViewHeight)
        }
    }
    @objc func cancel() {
        navigationController?.popViewController(animated: true)
    }
    @objc private func save(_ sender: Any) {
        //메모 갈아거 0이면 메모 입력하세요 띄우기
        if memoContent.text.count == 0 || memoContent.text == "메모 내용 입력" {
           alert(message: "메모 내용을 입력하세요.")
           return
        }

        if editTarget == nil {
            DataManager.shared.addNewMemo(content: memoContent.text) // 20200621 #19 db구현2. 위에것들 주석처리하고, 새로 작성한 디비 저장함수 실행
            //NotificationCenter.default.post(name:MakeBackPackViewController.newBackPackDidInsert, object: nil) // 앱의 모든 객체에게 노티피케이션을 전달
        } else {
            editTarget?.content = memoContent.text
            
            var dataList = [Data]()
            for i in DataManager.shared.imageList {
                dataList.append(i.jpegData(compressionQuality: 0.01)!)
            }
            editTarget?.images = dataList
            DataManager.shared.saveContext()
        }
        navigationController?.popViewController(animated: true)
    }
    
    
}

extension MakeMemoViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    //20200720 사진을 고르는 화면 구현
    @IBAction func addImageToQuestion(_ sender: UIButton) {
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
            DataManager.shared.imageList.append(img)
            self.collectionView.reloadData()
            collectionViewHeight = CGFloat(((DataManager.shared.imageList.count + 2) / 3) * 110)
            if collectionViewHeight == 0 { collectionViewHeight = 10 }
            if collectionViewHeight > 270 { collectionViewHeight = 270 }
            collectionView.snp.updateConstraints{
                $0.height.equalTo(collectionViewHeight)
            }
        }
    }
}

extension MakeMemoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // 20200720 올린 사진을 보여줄 콜랙션뷰 구현
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            collectionView.deselectItem(at: indexPath, animated: true)
            print("You tapped me")
        }
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return DataManager.shared.imageList.count
        }
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell

            cell.imageView?.image = DataManager.shared.imageList[indexPath.row]
         
            cell.imageView?.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
            cell.imageView?.layer.borderWidth = 1.0
            cell.imageView?.layer.cornerRadius = 5.0
            
            cell.imageView?.backgroundColor = UIColor.black
            return cell
        }
}


extension MakeMemoViewController: UITextViewDelegate {
    // 텍스트뷰가 편집되기 시작하면
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "메모 내용 입력" {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "메모 내용 입력"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text == "\n"{
            textView.resignFirstResponder()
        }
        return true
    }
}
