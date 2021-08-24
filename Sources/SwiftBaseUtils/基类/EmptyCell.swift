//
//  EmptyCell.swift
//  ys715
//
//  Created by 宇树科技 on 2021/4/23.
//

import UIKit

class EmptyCell: BaseCell {

    @IBOutlet weak var myContent: UIView!

    @IBOutlet weak var myContentH: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func addMyContentView(_ myView:UIView){
        self.myContent.addSubview(myView)
        myContentH.constant = myView.h
    }
    
}
