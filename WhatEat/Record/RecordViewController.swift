//
//  RecordViewController.swift
//  WhatEat
//
//  Created by  on 2021/9/29.
//

import UIKit

enum RecordType {
    case eat
    case who
}

class RecordViewController: UIViewController {

    @IBOutlet var views: RecordViews!

    private let viewModel = RecordViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.eatRecord = calculatePercent(UserDefaults.standard.stringArray(forKey: "eatRecord") ?? [])
        viewModel.whoRecord = calculatePercent(UserDefaults.standard.stringArray(forKey: "whoRecord") ?? [])

        //送回donutView，加入view
        let frame = 170 / 375 * self.view.frame.width
        views.eatView.addSubview(createDonutView(type: .eat, donutCenter: CGPoint(x: frame / 2, y: frame / 2)))
        views.whoView.addSubview(createDonutView(type: .who, donutCenter: CGPoint(x: frame / 2, y: frame / 2)))
    }

    /// 計算份數
    private func calculatePercent(_ model: [String]) -> [String: CGFloat] {
        var tempD: [String: CGFloat] = [:]
        for value in model {
            if tempD[value] == nil {
                tempD[value] = 1
            } else {
                tempD[value]! += 1
            }
        }
        return more10Data(tempD)
    }

    /// 大於10份時所做的事
    private func more10Data(_ model: [String: CGFloat]) -> [String: CGFloat] {
        // value由大到小排序
        let sortedByValue = model.sorted { firstDictionary, secondDictionary in
            return firstDictionary.1 > secondDictionary.1
        }
        
        var moreTempD: [String: CGFloat] = [:]
        for (i, values) in sortedByValue.enumerated() {
            if i >= 9 {
                if moreTempD["其他"] == nil {
                    moreTempD["其他"] = values.value
                } else {
                    moreTempD["其他"]! += values.value
                }
            } else {
                moreTempD[values.key] = values.value
            }
        }
        return moreTempD
    }

    //甜甜圈view
    private func createDonutView(type: RecordType, donutCenter: CGPoint) -> UIView {
        var startDegree: CGFloat = 270
        let model: [String: CGFloat] = type == .eat ? viewModel.eatRecord : viewModel.whoRecord
        let arrayKey = [String](model.keys)
        let arrayValue = [CGFloat](model.values)
        // 一等分的百分比 ex: 25% = 25
        let onePercent: CGFloat = 100 / CGFloat(arrayValue.reduce(0, +))
        let donutView = UIView()

        for i in 0..<arrayKey.count {
            // 某標籤的總百分比 ex: 25% = 25
            let aValuePercent: CGFloat = onePercent * arrayValue[i]
            let endDegree = startDegree + 360 * aValuePercent / 100
            let fractionPath = UIBezierPath(arcCenter: donutCenter,
                radius: viewModel.donutRadius,
                startAngle: .pi / 180 * startDegree,
                endAngle: .pi / 180 * endDegree,
                clockwise: true)

            let fractionLayer = CAShapeLayer()
            fractionLayer.path = fractionPath.cgPath
            fractionLayer.strokeColor = viewModel.mColor[i].cgColor
            fractionLayer.lineWidth = viewModel.donutLineWidth
            fractionLayer.fillColor = UIColor.clear.cgColor
            donutView.layer.addSublayer(fractionLayer)

            //加入目前fraction的百分比標籤
            donutView.addSubview(viewModel.createDonutLabel(model: arrayKey[i], percentage: aValuePercent, startDegree: startDegree, labelCenter: donutCenter))
            startDegree = endDegree

            let mLabel: UILabel = type == .eat ? views.eatLabel : views.whoLabel
            mLabel.text = (mLabel.text ?? "") + "\(arrayKey[i]): \(Int(aValuePercent))%\n"
        }
        return donutView
    }
}
