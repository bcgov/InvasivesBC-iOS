//
//  ActivityViewController.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-07-24.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import UIKit

class ActivityViewController: BaseViewController {
    
    var tableCells: [String] = ["SessionDefaultsTableViewCell", "SelectFormTypeTableViewCell"]
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var divider: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        style()
        addListeners()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    deinit {
        removeListeners()
    }
    
    private func removeListeners() {
        NotificationCenter.default.removeObserver(self, name: .InputItemValueChanged, object: nil)
    }
    
    private func addListeners() {
        NotificationCenter.default.removeObserver(self, name: .InputItemValueChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.inputItemValueChanged(notification:)), name: .InputItemValueChanged, object: nil)
    }
    
    @objc func inputItemValueChanged(notification: Notification) {
        guard let item: InputItem = notification.object as? InputItem else {return}
        print(item.value.get(type: item.type) as Any)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func style() {
        tableView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        closeButton.tintColor = UIColor.primary
        titleLabel.font = UIFont.semibold(size: 22)
        titleLabel.textColor = UIColor.primary
        divider.backgroundColor = UIColor.primary
    }
    
}

extension ActivityViewController: UITableViewDataSource, UITableViewDelegate {
    
    private func setUpTable() {
        if self.tableView == nil {return}
        tableView.delegate = self
        tableView.dataSource = self
        for cell in tableCells {
            register(table: cell)
        }
    }
    
    func register(table cellName: String) {
        let nib = UINib(nibName: cellName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellName)
    }
    
    func getSessionDefaultCell(indexPath: IndexPath) -> SessionDefaultsTableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "SessionDefaultsTableViewCell", for: indexPath) as! SessionDefaultsTableViewCell
    }
    
    func getFormTypeCell(indexPath: IndexPath) -> SelectFormTypeTableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "SelectFormTypeTableViewCell", for: indexPath) as! SelectFormTypeTableViewCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let customHeader: CustomHeader = UIView.fromNib()
        switch section {
        case 0:
            customHeader.setup(left: "SessionDefault", right: "", color: .systemPink)
        case 1:
            customHeader.setup(left: "Plant", right: "Invasive/Terrestrial", color: .systemGreen)
        case 2:
            customHeader.setup(left: "Aquatic", right: "Invasive/Terrestrial", color:.systemGreen)
        default:
            customHeader.setup(left: "", right: "", color: .systemGreen)
        }
        return customHeader
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = getSessionDefaultCell(indexPath: indexPath)
            cell.setup(delegate: self)
            return cell
        case 1:
            let cell = getFormTypeCell(indexPath: indexPath)
            cell.setup(onObservation: { [weak self] in
                guard let _self = self else {return}
                print("When Plant observation is clicked")
            }, onTreatment: { [weak self] in
                guard let _self = self else {return}
                print("When Plant Treatment is clicked")
            }) { [weak self] in
                guard let _self = self else {return}
                print("When Plant Monitoring is clicked")
            }
            return cell
        case 2:
            let cell = getFormTypeCell(indexPath: indexPath)
            cell.setup(onObservation: { [weak self] in
                guard let _self = self else {return}
                print("When Animal observation is clicked")
            }, onTreatment: { [weak self] in
                guard let _self = self else {return}
                print("When Animal Treatment is clicked")
            }) { [weak self] in
                guard let _self = self else {return}
                print("When Animal Monitoring is clicked")
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
}
