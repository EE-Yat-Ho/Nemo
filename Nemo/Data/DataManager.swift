//
//  DataManager.swift
//  BrainSupporter2
//
//  Created by 박영호 on 2020/06/23.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import RxSwift
import RxCocoa
//ios에서 db는 core data를 사용. 프로젝트 생성시 core data 체크했기 때문에 기본적인 파일 있는 상태
//모델 파일 => 디비 설계도 개념
//core data에서는 엔티티를 클래스로 다룸

class DataManager{
    // 싱글톤으로 클래스를 구현하는 방식. 공유인스턴스로 앱 전체에서 하나의 인스턴스 사용가능. 아 정처기 거기있었는데 싱글톤
    static let shared = DataManager()
//    private init(){
//
//    }
    let homeViewTalbeReloadTrigger = PublishRelay<Void>()
    
    // 코어데이터에서 실행하는 대부분 작업은 컨텍스트 객체가 처리. 기본적으로 제공해주긴 하는데 그냥 하나 선언
    var mainContext:NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    var backPackList = [BackPack]() // 디비에서 꺼내올 때 저장할 빈 배열이로구나
    var noteList = [Note]()
    var questionList = [Question]()
    var memoList = [Memo]()
    var imageList = [UIImage]() // 문제, 메모
    var imageList_2 = [UIImage]() // 풀이
    var imageList_MC = [UIImage]() // 객관식 만들기용 ㅡㅡ 하 
    var imageList_MC_2 = [UIImage]()
    
    var nowBackPackName:String?
    var nowNoteName:String?
    
    var testQuestionList = [Question]()
    var testAnswerList = [Answer]()
    var timerTime: Int?
    var nowQNumber: Int? // 문제의 번호
    var nowQAmount: Int? // 풀 문제의 수
    var noteAmount: Int?
    
    // DB에서 데이터를 읽어오는 함수
    func fetchBackPack(){
        let request: NSFetchRequest<BackPack> = BackPack.fetchRequest() // 데이터를 읽어오기 위한 패치 리퀘스트를 만듦
        
        // 코어데이터가 주는 데이터들을 정렬하기 위한 소트 디스크립터를 만듬
        let sortByDateDesc = NSSortDescriptor(key: "order", ascending: false)
        request.sortDescriptors = [sortByDateDesc]
        
        // 패치 리퀘스트를 실행하고 데이터를 가져오는 코드
        // 컨텍스트에서 제공하는 패치 메소드를 사용하며,
        // fetch함수 자동완성 기능을 보면 throws가 적힌게 있는데 이건 오류가 발생할 수 있다는 뜻
        // 그래서 일반적인 호출로는 안되고, do catch문을 사용해야함
        do{
            backPackList = try mainContext.fetch(request)
        } catch {
            print(error)
        }
    }
    
    func fetchNote(backPackName: String?){
        let predicate = NSPredicate(format: "backPackName = %@", backPackName! as CVarArg)
        let request: NSFetchRequest<Note> = Note.fetchRequest() // 데이터를 읽어오기 위한 패치 리퀘스트를 만듦
        request.predicate = predicate
        
        // 코어데이터가 주는 데이터들을 정렬하기 위한 소트 디스크립터를 만듬
        let sortByDateDesc = NSSortDescriptor(key: "order", ascending: false)
        request.sortDescriptors = [sortByDateDesc]
        
        // 패치 리퀘스트를 실행하고 데이터를 가져오는 코드
        // 컨텍스트에서 제공하는 패치 메소드를 사용하며,
        // fetch함수 자동완성 기능을 보면 throws가 적힌게 있는데 이건 오류가 발생할 수 있다는 뜻
        // 그래서 일반적인 호출로는 안되고, do catch문을 사용해야함
        do{
            noteList = try mainContext.fetch(request)
        } catch {
            print(error)
        }
    }
    
    func fetchQuestion(){
        let predicate = NSPredicate(format: "(backPackName = %@) AND (noteName = %@)", nowBackPackName! as CVarArg, nowNoteName! as CVarArg)
        let request: NSFetchRequest<Question> = Question.fetchRequest() // 데이터를 읽어오기 위한 패치 리퀘스트를 만듦
        request.predicate = predicate
        
        // 코어데이터가 주는 데이터들을 정렬하기 위한 소트 디스크립터를 만듬
        let sortByDateDesc = NSSortDescriptor(key: "order", ascending: false)
        request.sortDescriptors = [sortByDateDesc]
        
        // 패치 리퀘스트를 실행하고 데이터를 가져오는 코드
        // 컨텍스트에서 제공하는 패치 메소드를 사용하며,
        // fetch함수 자동완성 기능을 보면 throws가 적힌게 있는데 이건 오류가 발생할 수 있다는 뜻
        // 그래서 일반적인 호출로는 안되고, do catch문을 사용해야함
        do{
            questionList = try mainContext.fetch(request)
        } catch {
            print(error)
        }
    }
    
    func fetchMemo(){
        let predicate = NSPredicate(format: "(backPackName = %@) AND (noteName = %@)", nowBackPackName! as CVarArg, nowNoteName! as CVarArg)
        let request: NSFetchRequest<Memo> = Memo.fetchRequest() // 데이터를 읽어오기 위한 패치 리퀘스트를 만듦
        request.predicate = predicate
        
        // 코어데이터가 주는 데이터들을 정렬하기 위한 소트 디스크립터를 만듬
        let sortByDateDesc = NSSortDescriptor(key: "order", ascending: false)
        request.sortDescriptors = [sortByDateDesc]
        
        // 패치 리퀘스트를 실행하고 데이터를 가져오는 코드
        // 컨텍스트에서 제공하는 패치 메소드를 사용하며,
        // fetch함수 자동완성 기능을 보면 throws가 적힌게 있는데 이건 오류가 발생할 수 있다는 뜻
        // 그래서 일반적인 호출로는 안되고, do catch문을 사용해야함
        do{
            memoList = try mainContext.fetch(request)
        } catch {
            print(error)
        }
    }
    
    func safetyBackPackOverLap(name: String?) -> Bool{
        for i in backPackList{
            if i.name == name {
                return false
            }
        }
        return true
    }
    
    func safetyNoteOverLap(name: String?) -> Bool{
        for i in noteList{
            if i.name == name {
                return false
            }
        }
        return true
    }
    
    func addNewBackPack(name: String?){
        let newBackPack = BackPack(context: mainContext)// db에 메모를 저장하기 위한 비어있는 인스턴스 생성
        newBackPack.name = name // 파라미터로 넘겨받은 내용과
        newBackPack.order = Int16(backPackList.count) // 순서
        newBackPack.numberOfNote = 0
        newBackPack.opened = false
        
        backPackList.insert(newBackPack, at: 0) // 디비에 넣고, 다시 전부 리로드하는 방식은 충분히 가능은 하지만 좀더 효율적으로 하기위해, 디비에도 저장하고, 리로드할때 쓰는 배열에도 추가한다잇
        saveContext() // 코어 데이터가 지원하는 함수로, 메인 컨텍스트에 저장되어있는 내용을 디비에 저장하는 함수
    }
    
    func addNewNote(noteName: String?, backPackName: String?){
        fetchNote(backPackName: backPackName)
        
        let newNote = Note(context: mainContext)// db에 메모를 저장하기 위한 비어있는 인스턴스 생성
        newNote.name = noteName // 파라미터로 넘겨받은 내용과
        newNote.backPackName = backPackName
        newNote.order = Int16(noteList.count) // 순서
        newNote.numberOfQ = 0
        newNote.numberOfM = 0
            
        for i in backPackList{
            if i.name == backPackName{
                i.numberOfNote += 1
            }
        }
        
        saveContext() // 코어 데이터가 지원하는 함수로, 메인 컨텍스트에 저장되어있는 내용을 디비에 저장하는 함수
    }
    
    var dataList = [Data]()
    var dataList_2 = [Data]()
    func addNewQuestion(question: String?, answer: String?, explanation: String?) { // 주관식
        fetchQuestion()
        
        let newQuestion = Question(context: mainContext)// db에 메모를 저장하기 위한 비어있는 인스턴스 생성
        newQuestion.noteName = nowNoteName // 여기존재
        newQuestion.backPackName = nowBackPackName // 여기존재
        newQuestion.order = Int16(questionList.count) // 순서
        newQuestion.question = question // 파라미터
        newQuestion.subjectiveAnswer = answer // 파라미터
        newQuestion.isSubjective = true
        newQuestion.explanation = explanation
        
        for i in imageList {
            dataList.append(i.jpegData(compressionQuality: 0.75)!)
        }
        newQuestion.questionImages = dataList
        for i in imageList_2 {
            dataList_2.append(i.jpegData(compressionQuality: 0.75)!)
        }
        newQuestion.explanationImages = dataList_2
        
        for i in noteList{
            if i.name == nowNoteName{
                i.numberOfQ += 1
            }
        }
        
        saveContext() // 코어 데이터가 지원하는 함수로, 메인 컨텍스트에 저장되어있는 내용을 디비에 저장하는 함수
    }
    
    var answerList = [String]()
    var rightList = [Bool]()
    var mca = [String]()
    var mcwa = [String]()
    func addNewQuestion(question: String?, explanation: String?) { // 객관식
        fetchQuestion()
        
        mca.removeAll()
        mcwa.removeAll()
        let newQuestion = Question(context: mainContext)// db에 메모를 저장하기 위한 비어있는 인스턴스 생성
        newQuestion.noteName = nowNoteName // 여기존재
        newQuestion.backPackName = nowBackPackName // 여기존재
        newQuestion.order = Int16(questionList.count) // 순서
        newQuestion.question = question // 파라미터
        for i in 0..<answerList.count {
            if rightList[i] == true {
                mca.append(answerList[i])
            } else {
                mcwa.append(answerList[i])
            }
        }
        newQuestion.multipleChoiceAnswers = mca
        newQuestion.multipleChoiceWrongAnswers = mcwa
        
        newQuestion.isSubjective = false
        newQuestion.explanation = explanation

        for i in imageList_MC {
            dataList.append(i.jpegData(compressionQuality: 0.75)!)
        }
        newQuestion.questionImages = dataList
        for i in imageList_MC_2 {
            dataList_2.append(i.jpegData(compressionQuality: 0.75)!)
        }
        newQuestion.explanationImages = dataList_2

        for i in noteList{
            if i.name == nowNoteName{
                i.numberOfQ += 1
            }
        }

        saveContext() // 코어 데이터가 지원하는 함수로, 메인 컨텍스트에 저장되어있는 내용을 디비에 저장하는 함수
    }
    
    func addNewMemo(content: String?){
        fetchMemo()
        
        let newMemo = Memo(context: mainContext)// db에 메모를 저장하기 위한 비어있는 인스턴스 생성
        newMemo.noteName = nowNoteName // 파라미터로 넘겨받은 내용과
        newMemo.backPackName = nowBackPackName
        newMemo.order = Int16(questionList.count) // 순서
        newMemo.content = content
            
        for i in noteList{
            if i.name == nowNoteName{
                i.numberOfM += 1
            }
        }
        
        saveContext() // 코어 데이터가 지원하는 함수로, 메인 컨텍스트에 저장되어있는 내용을 디비에 저장하는 함수
    }
    
    //#22 메모삭제구현
    func deleteBackPack(_ backPack: BackPack?){
        if let backPack = backPack { // 가방이 전달된 겨웅에만 삭제
            mainContext.delete(backPack)
            saveContext()
        }
    }
    
    func deleteNote(_ note: Note?){
        if let note = note { // 노트가 전달된 겨웅에만 삭제
            mainContext.delete(note)
            saveContext()
        }
    }
    
    func deleteQuestion(_ question: Question?){
        if let question = question { // 노트가 전달된 겨웅에만 삭제
            mainContext.delete(question)
            saveContext()
        }
    }
    
    func deleteMemo(_ memo: Memo?){
        if let memo = memo { // 노트가 전달된 겨웅에만 삭제
            mainContext.delete(memo)
            saveContext()
        }
    }
    
    
    // MARK: - Core Data stack
    // 코어데이터를 사용하기위한 기본적인 코드들 이걸 그대로 써도되긴하지만 불필요한 애들이 많음
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BrainSupporter2")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

struct Answer {
    var subjectiveAnswer = ""
    var multipleChoiceAnswer = [String]()
}
