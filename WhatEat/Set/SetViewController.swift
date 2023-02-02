//
//  OtherViewController.swift
//  WhatEat
//
//  Created by  on 2021/9/29.
//

import UIKit

class SetViewController: UIViewController {

    @IBOutlet var views: SetViews!

    private let viewModel = SetViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "设置(上限16笔)"
        setupUI()
        editBtnAction()
    }

    func setupUI() {
        let tables: [UITableView] = [views.eatTableView, views.whoTableView]
        tables.forEach { table in
            table.delegate = self
            table.dataSource = self
            table.allowsSelection = false
            table.setEditing(true, animated: true)
            table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
            table.reloadData()
        }
        views.selectEatButton.addTarget(self, action: #selector(clickEatBtn), for: .touchUpInside)
        views.selectWhoButton.addTarget(self, action: #selector(clickWhoBtn), for: .touchUpInside)
    }

    // 新增資料
    @objc func addBtnAction() {
        let tableView: UITableView = views.eatView.isHidden ? views.whoTableView : views.eatTableView
        let key = tableView == views.eatTableView ? "eatArray" : "whoArray"
        guard var model = UserDefaults.standard.stringArray(forKey: key), model.count < 16 else { return }
        let mView = AddRowView(frame: self.view.frame)
        mView.clickAddBtnHandler = { str in
            model.insert(str, at: 0)
            UserDefaults.standard.setValue(model, forKey: key)

            // 新增 cell 在第一筆 row
            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            tableView.endUpdates()
        }
        self.view.addSubview(mView)
    }

    @objc func editBtnAction() {
        let tableView: UITableView = views.eatView.isHidden ? views.whoTableView : views.eatTableView
        tableView.setEditing(!tableView.isEditing, animated: true)
        if !tableView.isEditing {
            // 顯示編輯按鈕
            self.navigationItem.leftBarButtonItem =
                UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editBtnAction))
            // 顯示新增按鈕
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBtnAction))
        } else {
            // 顯示編輯完成按鈕
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editBtnAction))
            // 隱藏新增按鈕
            self.navigationItem.rightBarButtonItem = nil
        }
    }

    @objc private func clickEatBtn() {
        let eatTitleColor = #colorLiteral(red: 0.2039215686, green: 0.2392156863, blue: 0.6705882353, alpha: 1)
        let whoTitleColor = #colorLiteral(red: 0.0862745098, green: 0.1529411765, blue: 0.3411764706, alpha: 1)
        views.selectEatButton.setTitleColor(eatTitleColor, for: .normal)
        views.selectWhoButton.setTitleColor(whoTitleColor, for: .normal)
        views.selectEatButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        views.selectWhoButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        views.selectEatLine.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.2392156863, blue: 0.6705882353, alpha: 1)
        views.selectWhoLine.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        views.eatTableView.reloadData()
        views.eatTableView.setEditing(false, animated: true)
        views.eatView.isHidden = false
        views.whoView.isHidden = true
        // 顯示編輯按鈕
        self.navigationItem.leftBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editBtnAction))
        // 顯示新增按鈕
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBtnAction))
    }

    @objc private func clickWhoBtn() {
        let eatTitleColor = #colorLiteral(red: 0.0862745098, green: 0.1529411765, blue: 0.3411764706, alpha: 1)
        let whoTitleColor = #colorLiteral(red: 0.2039215686, green: 0.2392156863, blue: 0.6705882353, alpha: 1)
        views.selectEatButton.setTitleColor(eatTitleColor, for: .normal)
        views.selectWhoButton.setTitleColor(whoTitleColor, for: .normal)
        views.selectEatButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        views.selectWhoButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        views.selectEatLine.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        views.selectWhoLine.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.2392156863, blue: 0.6705882353, alpha: 1)
        views.whoTableView.reloadData()
        views.whoTableView.setEditing(false, animated: true)
        views.eatView.isHidden = true
        views.whoView.isHidden = false
        // 顯示編輯按鈕
        self.navigationItem.leftBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editBtnAction))
        // 顯示新增按鈕
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBtnAction))
    }
}

extension SetViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == views.eatTableView {
            return UserDefaults.standard.stringArray(forKey: "eatArray")?.count ?? 0
        } else {
            return UserDefaults.standard.stringArray(forKey: "whoArray")?.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        let key = tableView == views.eatTableView ? "eatArray" : "whoArray"
        guard let model = UserDefaults.standard.stringArray(forKey: key), model.count > indexPath.row else { return cell }
        cell.textLabel?.text = model[indexPath.row]
        cell.textLabel?.textColor = #colorLiteral(red: 0.0862745098, green: 0.1529411765, blue: 0.3411764706, alpha: 1)
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // 刪除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let key = tableView == views.eatTableView ? "eatArray" : "whoArray"
        guard var model = UserDefaults.standard.stringArray(forKey: key) else { return }

        if editingStyle == .delete {
            model.remove(at: indexPath.row)
            UserDefaults.standard.setValue(model, forKey: key)

            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // 移動
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        var tempArr: [String] = []
        let key = tableView == views.eatTableView ? "eatArray" : "whoArray"
        guard let model = UserDefaults.standard.stringArray(forKey: key) else { return }

        if sourceIndexPath.row > destinationIndexPath.row {
            // 排在後的往前移動
            for (index, value) in model.enumerated() {
                if index < destinationIndexPath.row || index > sourceIndexPath.row {
                    tempArr.append(value)
                } else if index == destinationIndexPath.row {
                    tempArr.append(model[sourceIndexPath.row])
                } else if index <= sourceIndexPath.row {
                    tempArr.append(model[index - 1])
                }
            }
        } else if (sourceIndexPath.row < destinationIndexPath.row) {
            // 排在前的往後移動
            for (index, value) in model.enumerated() {
                if index < sourceIndexPath.row || index > destinationIndexPath.row {
                    tempArr.append(value)
                } else if index < destinationIndexPath.row {
                    tempArr.append(model[index + 1])
                } else if index == destinationIndexPath.row {
                    tempArr.append(model[sourceIndexPath.row])
                }
            }
        } else {
            tempArr = model
        }

        UserDefaults.standard.setValue(tempArr, forKey: key)
    }
}
