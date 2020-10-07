//
//  MultipleChoiceQuestionAnswerCell.swift
//  Nemo
//
//  Created by 박영호 on 2020/08/18.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class MultipleChoiceQuestionAnswerCell: UITableViewCell {
    @IBOutlet weak var num: UILabel!
    @IBOutlet weak var contents: UITextField!
    @IBOutlet weak var OX: UIButton!
    
    var right: Bool! = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
