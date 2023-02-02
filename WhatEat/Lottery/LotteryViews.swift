//
//  LotteryViews.swift
//  WhatEat
//
//  Created by  on 2021/9/30.
//

import UIKit

class LotteryViews: NSObject {
    
    @IBOutlet weak var layerBgView: UIView!
    @IBOutlet weak var chooseImgV: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var selectControl: UISegmentedControl!
    @IBOutlet weak var retryButton: UIButton! {
        didSet {
            retryButton.clipsToBounds = true
            retryButton.layer.cornerRadius = 20
        }
    }
}
