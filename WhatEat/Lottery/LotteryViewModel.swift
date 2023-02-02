//
//  LotteryViewModel.swift
//  WhatEat
//
//  Created by  on 2021/9/30.
//

import UIKit

class LotteryViewModel: NSObject {
    /// 半徑
    public var radius: CGFloat = 150
    /// 使用者選擇
    public var lotteryArray: [String] = UserDefaults.standard.stringArray(forKey: "eatArray") ?? []
    /// 顏色
    public let mColor: [UIColor] = [#colorLiteral(red: 0.8470588235, green: 0.9921568627, blue: 0.9254901961, alpha: 1), #colorLiteral(red: 0.600962072, green: 0.8392156959, blue: 0.8470588235, alpha: 1), #colorLiteral(red: 0.6778142969, green: 0.8940964279, blue: 0.9921568627, alpha: 1), #colorLiteral(red: 0.662745098, green: 0.9843137255, blue: 0.8431372549, alpha: 1), #colorLiteral(red: 0.6980392157, green: 0.8941176471, blue: 0.8588235294, alpha: 1), #colorLiteral(red: 0.6901960784, green: 0.7764705882, blue: 0.8078431373, alpha: 1), #colorLiteral(red: 0.5764705882, green: 0.5450980392, blue: 0.631372549, alpha: 1), #colorLiteral(red: 0.9254901961, green: 0.9725490196, blue: 0.9725490196, alpha: 1), #colorLiteral(red: 0.9333333333, green: 0.8941176471, blue: 0.8823529412, alpha: 1), #colorLiteral(red: 0.9058823529, green: 0.8470588235, blue: 0.7882352941, alpha: 1), #colorLiteral(red: 0.9019607843, green: 0.7450980392, blue: 0.6823529412, alpha: 1), #colorLiteral(red: 0.6980392157, green: 0.5882352941, blue: 0.4901960784, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.7252248484, blue: 0.808701095, alpha: 1), #colorLiteral(red: 0.4548510571, green: 0.597141506, blue: 0.8352941176, alpha: 1), #colorLiteral(red: 0.6747680877, green: 0.5694728398, blue: 0.7857549707, alpha: 1), #colorLiteral(red: 0.5832147131, green: 0.611672995, blue: 0.8251092017, alpha: 1)]
    /// 旋轉的z軸
    public var zValue: Double = 0
    /// 轉盤view
    public var lotteryView = UIView()
    
    //個別占比標籤
    public func createDonutLabel(str: String, startDegree: CGFloat, labelRadius: CGFloat, labelCenter: CGPoint) -> UILabel {
        let percentage: CGFloat = 100 / CGFloat(lotteryArray.count)
        let textCenterDegree = startDegree + 360 * percentage / 100 / 2

        //只是為了標一個點
        let textPath = UIBezierPath(arcCenter: labelCenter,
                                    radius: labelRadius,
                                    startAngle: CGFloat.pi / 180  * textCenterDegree,
                                    endAngle: CGFloat.pi / 180  * textCenterDegree,
                                    clockwise: true)

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        label.center = textPath.currentPoint
        label.textAlignment = .center
        label.text = str
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }
    
    /// 動畫效果
    func randomAnimate(_ vc: LotteryViewController) -> CABasicAnimation {
        let value = Double.random(in: 60...99)
        zValue = 3 * Double.pi + value
        //這一段是Z搖晃
        let mAnimationZ = CABasicAnimation(keyPath: "transform.rotation.z")
        mAnimationZ.duration = 5
        mAnimationZ.byValue = zValue
        mAnimationZ.isRemovedOnCompletion = false
        mAnimationZ.fillMode = .forwards
        mAnimationZ.repeatCount = 1
        mAnimationZ.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        mAnimationZ.delegate = vc
        return mAnimationZ
    }
}
