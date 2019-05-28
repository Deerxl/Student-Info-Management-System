//
//  StuInfoDetailTableViewCell.swift
//  FinalWork
//
//  Created by alu on 2019/5/24.
//  Copyright © 2019年 alu. All rights reserved.
//

import UIKit

class StuInfoDetailTableViewCell: UITableViewCell {

    var delegate: CouponTableViewCellDelegate!
    
    @IBAction func UpdateBtnPressed(_ sender: Any) {
        delegate.couponBtnClick(couponID: 1)
    }
    
    @IBAction func DeleteBtnPressed(_ sender: Any) {
        delegate.couponBtnClick(couponID: 2)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

protocol CouponTableViewCellDelegate {
    func couponBtnClick(couponID:Int!)
}
