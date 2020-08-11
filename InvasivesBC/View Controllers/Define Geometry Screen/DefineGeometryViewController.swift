//
//  DefineGeometryViewController.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-08-10.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import UIKit


enum DefineGeometryType: Int, CaseIterable {
    case Point = 0
    case TwoPoint
    case WayPoint
    case Polygon
}

class DefineGeometryViewController: UIViewController {
    
    var formType: ActivityFormType?
    var selectedGeometry: DefineGeometryType?
    var tableCells: [String] = ["SelectGeometryTypeTableViewCell"]

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        style()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    func setup(type: ActivityFormType) {
        self.formType = type
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let type = formType, let geometryType = selectedGeometry , let destination = segue.destination as? GeometryPickerViewController else {return}
        destination.setup(form: type, geometry: geometryType)
    }
    
    func showGeometryPicker(for type: DefineGeometryType) {
        selectedGeometry = type
        performSegue(withIdentifier: "showGeometryPicker", sender: self)
    }
    
    func style() {
        self.title = "Define Geometry"
    }

}

extension DefineGeometryViewController: UITableViewDataSource, UITableViewDelegate {
    
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
    
    func getCell(indexPath: IndexPath) -> SelectGeometryTypeTableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "SelectGeometryTypeTableViewCell", for: indexPath) as! SelectGeometryTypeTableViewCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DefineGeometryType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let type = DefineGeometryType.init(rawValue: indexPath.row) else {return UITableViewCell()}
        let cell = getCell(indexPath: indexPath)
        cell.setup(type: type, onTap: {[weak self] in
            guard let _self = self else {return}
            _self.showGeometryPicker(for: type)
        })
        return cell
    }
}
