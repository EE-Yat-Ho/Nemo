//
//  DropDownView.swift
//  BrainSupporter2
//
//  Created by 박영호 on 2020/06/27.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

public class DropDownView: UIView, UITableViewDelegate, UITableViewDataSource {
    var DropDownOption = [String]()
    
    var tableView = UITableView()
    
    var delegate : DropDownProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.backPackList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = DataManager.shared.backPackList[indexPath.row].name
        cell.textLabel?.textColor = UIColor.black
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.DropDownPressed(string: DataManager.shared.backPackList[indexPath.row].name!) // 맨위에 선택한 애를 표시
        self.tableView.deselectRow(at: indexPath, animated: true) // 맨위에꺼 누르면 닫힘
    }
}
 
