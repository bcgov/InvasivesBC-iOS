//
//  PlantObservationViewController.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-08-11.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import UIKit


enum PlantObservationSection: Int, CaseIterable {
    case LocationandGeometry = 0
    case ObserverInformation
    case SpeciesInformationandObservation
    case AdvancedDataElements
}


class PlantObservationViewController: BaseViewController {
    
    var editable: Bool = true
    var tableCells: [String] = ["SectionTableViewCell"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        setUpTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    // TODO: Pass intial model to populate form
    func setup(editable: Bool) {
        self.editable = editable
    }
    
    func style() {
        self.title = "Plant Observation"
    }
    
    func getSampleFields() -> [InputItem] {
        var fields: [InputItem] = []
        
        let textField = TextInput(key: "f1", header: "field 1", editable: editable)
        let textField2 = TextInput(key: "f2", header: "field 2", editable: editable)
        let textField3 = TextInput(key: "f3", header: "field 3", editable: editable)
        let textField4 = TextInput(key: "f4", header: "field 4", editable: editable)
        
        fields.append(textField)
        fields.append(textField2)
        fields.append(textField3)
        fields.append(textField4)
        
        return fields
    }
    
    func getFields(for section: PlantObservationSection) -> [InputItem] {
        return getSampleFields()
    }

}

extension PlantObservationViewController: UITableViewDataSource, UITableViewDelegate {
    
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
    
    func getSectionCell(indexPath: IndexPath) -> SectionTableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "SectionTableViewCell", for: indexPath) as! SectionTableViewCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return PlantObservationSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = PlantObservationSection(rawValue: section) else { return ""}
        switch section {
        case .LocationandGeometry:
            return "Location and Geometry"
        case .ObserverInformation:
            return "Observer Information"
        case .SpeciesInformationandObservation:
            return "Species Informationand Observation"
        case .AdvancedDataElements:
            return "Advanced Data Elements"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let type = PlantObservationSection.init(rawValue: indexPath.section) else {return UITableViewCell()}
        let cell = getSectionCell(indexPath: indexPath)
        cell.setup(fields: getFields(for: type), delegagte: self)
        return cell
    }
}
