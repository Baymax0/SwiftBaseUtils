//
//  ViewControllerCell.swift
//  BaseUtilsDemo
//
//  Created by 李志伟 on 2020/12/11.
//  Copyright © 2020 yimi. All rights reserved.
//

import UIKit

class ViewControllerCell: BaseCell {
    
    static let cellH:CGFloat = 75
    
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var detailLab: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
