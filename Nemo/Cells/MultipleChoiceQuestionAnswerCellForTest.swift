//
//  MultipleChoiceQuestionAnswerCellForTest.swift
//  Nemo
//
//  Created by 박영호 on 2020/08/19.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class MultipleChoiceQuestionAnswerCellForTest: UITableViewCell {
    @IBOutlet weak var num: UILabel!
    @IBOutlet weak var contents: UILabel!
    @IBOutlet weak var exceptButton: UIButton!
    var isExcepted: Bool! = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
