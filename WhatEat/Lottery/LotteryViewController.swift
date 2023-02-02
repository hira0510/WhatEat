//
//  ViewController.swift
//  WhatEat
//
//  Created by  on 2021/9/29.
//

import UIKit
import MediaPlayer

class LotteryViewController: UIViewController {

    @IBOutlet var views: LotteryViews!
    private var soundEffectsPlayer: AVPlayer?

    private let viewModel = LotteryViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.stringArray(forKey: "eatArray") == nil {
            UserDefaults.standard.setValue(["炸鸡", "炒面", "炒饭", "火锅", "乌龙面", "粥", "烤肉", "铁板烧", "披萨", "水饺", "面", "泰式", "日式", "炸物", "咖喱", "牛排"], forKey: "eatArray")
        }
        if UserDefaults.standard.stringArray(forKey: "whoArray") == nil {
            UserDefaults.standard.setValue(["A", "B"], forKey: "whoArray")
        }
        
        views.retryButton.addTarget(self, action: #selector(didClickRetryBtn), for: .touchUpInside)
        views.selectControl.addTarget(self, action: #selector(didClickSelectControl), for: .valueChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        didClickSelectControl()
    }

    //重置view
    private func resetView() {
        viewModel.lotteryView.removeFromSuperview()
        viewModel.lotteryView = UIView(frame: views.layerBgView.bounds)
        viewModel.lotteryView.backgroundColor = .clear
    }
    
    /// 效果音
    private func playTheSoundEffects(forResource: String) {
        if let url = Bundle.main.url(forResource: forResource, withExtension: "mp3") {
            soundEffectsPlayer = AVPlayer(url: url)
            self.soundEffectsPlayer?.play()
        }
    }

    //Pie view
    private func createPieView(pieCenter: CGPoint) {
        var startDegree: CGFloat = 270
        let percentages: CGFloat = 100 / CGFloat(viewModel.lotteryArray.count)

        for i in 0..<viewModel.lotteryArray.count {
            let endDegree = startDegree + 360 * percentages / 100
            let fractionPath = UIBezierPath()
            fractionPath.move(to: pieCenter)
            fractionPath.addArc(withCenter: pieCenter,
                radius: viewModel.radius,
                startAngle: .pi / 180 * startDegree,
                endAngle: .pi / 180 * endDegree,
                clockwise: true)

            let fractionLayer = CAShapeLayer()
            fractionLayer.path = fractionPath.cgPath
            fractionLayer.fillColor = viewModel.mColor[i].cgColor
            viewModel.lotteryView.layer.addSublayer(fractionLayer)

            //加入目前百分比標籤
            viewModel.lotteryView.addSubview(viewModel.createDonutLabel(str: viewModel.lotteryArray[i], startDegree: startDegree, labelRadius: viewModel.radius * 2 / 2.5, labelCenter: pieCenter))

            startDegree = endDegree
        }
    }

    /// 點擊選擇器
    @objc private func didClickSelectControl() {
        resetView()
        self.navigationController?.navigationBar.topItem?.title = views.selectControl.selectedSegmentIndex == 0 ? "餐点抽签": "人员抽签"
        viewModel.lotteryArray = views.selectControl.selectedSegmentIndex == 0 ? UserDefaults.standard.stringArray(forKey: "eatArray") ?? []: UserDefaults.standard.stringArray(forKey: "whoArray") ?? []
        let frame = 300 / 375 * self.view.frame.width
        createPieView(pieCenter: CGPoint(x: frame / 2, y: frame / 2))
        views.layerBgView.addSubview(viewModel.lotteryView)
        views.layerBgView.bringSubviewToFront(views.chooseImgV)
    }

    /// 點擊抽籤
    @objc private func didClickRetryBtn() {
        
        DispatchQueue.main.async() {
            self.playTheSoundEffects(forResource: "ufo")
        }
        views.selectControl.isUserInteractionEnabled = false
        views.retryButton.isUserInteractionEnabled = false
        views.chooseImgV.layer.add(viewModel.randomAnimate(self), forKey: "randomAnimate")
        views.resultLabel.text = "抽签结果：\n"
    }
}

extension LotteryViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if anim == views.chooseImgV.layer.animation(forKey: "randomAnimate") {
            let percentage: Double = 360 / Double(viewModel.lotteryArray.count)
            let value = viewModel.zValue.truncatingRemainder(dividingBy: Double.pi * 2)
            let degree = value * 180 / Double.pi
            for index in 0..<viewModel.lotteryArray.count {
                if (Double((index + 1)) * percentage) > degree && degree > (Double(index) * percentage) {
                    views.resultLabel.text = "抽签结果：\n" + viewModel.lotteryArray[index]
                    let key = views.selectControl.selectedSegmentIndex == 0 ? "eatRecord" : "whoRecord"
                    let model: [String] = (UserDefaults.standard.stringArray(forKey: key) ?? []) + [viewModel.lotteryArray[index]]
                    UserDefaults.standard.setValue(model, forKey: key)
                    break
                }
            }
            playTheSoundEffects(forResource: "surprise")
            views.selectControl.isUserInteractionEnabled = true
            views.retryButton.isUserInteractionEnabled = true
        }
    }
}
