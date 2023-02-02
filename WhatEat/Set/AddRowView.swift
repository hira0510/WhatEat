//
//  AddRowView.swift
//  WhatEat
//
//  Created by Hira on 2021/10/1.
//

import UIKit

class AddRowView: UIView {
    
    @IBOutlet var mView: UIView!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var mTextField: UITextField!
    
    var clickAddBtnHandler: ((String) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("AddRowView", owner: self, options: nil)
        addSubview(mView!)
        mView.translatesAutoresizingMaskIntoConstraints = false
        mView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        mView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        mView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        addView.layer.cornerRadius = 10
        mTextField.delegate = self
        removeButton.addTarget(self, action: #selector(clickRemoveBtn), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(clickAddBtn), for: .touchUpInside)
    }
    
    /// 點擊關閉按鈕
    @objc private func clickRemoveBtn() {
        self.removeFromSuperview()
    }
    
    /// 點擊新增按鈕
    @objc private func clickAddBtn() {
        guard let text = mTextField.text, text != "" else { return }
        clickAddBtnHandler?(text)
        mTextField.endEditing(true)
        self.removeFromSuperview()
    }
}

extension AddRowView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        mTextField.endEditing(true)
        return true
    }
}
