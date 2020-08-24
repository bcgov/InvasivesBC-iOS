//
//  PlantObservationViewController.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-08-11.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import UIKit
import GRDB


enum PlantObservationSection: Int, CaseIterable {
    case LocationandGeometry = 0
    case ObserverInformation
    case SpeciesInformationandObservation
    case AdvancedDataElements
}


class PlantObservationViewController: BaseViewController {
    
    // set up blank record
    var activityRecord = Activity(activity_type: "Observation",
                                       activity_sub_type: "Terrestrial Plant",
                                       isFavorite: false,
                                       latitude: 0, longitude: 0,
                                       synched: false,
                                       synch_error: false,
                                       synch_error_string: "")


    
    var model: PlantObservationModel?
    
    var isSectionOpen: [PlantObservationSection: Bool] = [
        .LocationandGeometry: true,
        .ObserverInformation: true,
        .SpeciesInformationandObservation: true,
        .AdvancedDataElements: true
    ]
    
    var editable: Bool = true {
        didSet {
            styleForState()
        }
    }
    var tableCells: [String] = ["SectionTableViewCell"]
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        /*
         Hiding table until view did appear
         Because views haven't been layed out, so
         inputGroups don't know how to display themselves.
        */
        tableView.alpha = 0
        style()
        styleForState()
        addListeners()
        
        
        // just for dev and api testing.
        updateRecord()
    
    }
    
    
    func updateRecord(){
        let dbQueue = self.delegate.dbQueue
        
        
        /*try! dbQueue.read { db in
        // Fetch database rows
            let rows = try Row.fetchCursor(db, sql: "SELECT * FROM Activity")
          
        }*/
        
        self.activityRecord.latitude = 150
        self.activityRecord.longitude = 50
        
        try! dbQueue.write { db in
        // Write database rows
            try! self.activityRecord.insert(db)
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // When view appears,
        // 1) Collapsing all sections
        self.closeAllSections()
        // 2) We want the first section to be open
        isSectionOpen[.LocationandGeometry] = true
        // 3) Reload table to reflect the changes
        self.tableView.reloadData()
        self.view.layoutIfNeeded()
        // 4) Display table with an fading in animation
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.alpha = 1
            self.view.layoutIfNeeded()
        })
    }
    
    private func addListeners() {
        NotificationCenter.default.removeObserver(self, name: .InputItemValueChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.inputItemValueChanged(notification:)), name: .InputItemValueChanged, object: nil)
    }
    
    // MARK: Input Item Changed
    @objc func inputItemValueChanged(notification: Notification) {
        guard let item: InputItem = notification.object as? InputItem else {return}
        // Set value in Realm object
        if let m = model {
            m.set(value: item.value.get(type: item.type) as Any, for: item.key)
        }
    }
    
    @IBAction func rightButtonAction(_ sender: Any) {
        if editable {
            // Button is for reviewing
            self.editable = false
            self.openAllSections()
           
            
            tableView.reloadData()
        } else {
            // Button is for submitting
            savePlantObservation()
        }
    }
    
    @IBAction func leftButtonAction(_ sender: Any) {
        self.editable = true
        tableView.reloadData()
    }
    
    func setup(editable: Bool, model: PlantObservationModel) {
        self.editable = editable
        self.model = model
    }
    
    func savePlantObservation() {
        guard let model = self.model else { return }
        RealmRequests.saveObject(object: model)
        model.set(shouldSync: true)
        
        let alertController = UIAlertController(title: "Plant observation", message:
            "record saved", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default))
        self.present(alertController, animated: true, completion: nil)
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.navigationController?.popToRootViewController(animated: true)
        }
  
    }
    
    func style() {
        self.title = "Plant Observation"
    }
    
    func styleForState() {
        guard leftButton != nil, rightButton != nil else {return}
        if editable {
            leftButton.isHidden = true
            rightButton.setTitle("Proceed to review", for: .normal)
        } else {
            leftButton.isHidden = false
            rightButton.setTitle("Submit", for: .normal)
        }
    }
    
    func closeAllSections() {
        for (key, _) in isSectionOpen {
            isSectionOpen[key] = false
        }
    }
    
    func openAllSections() {
        for (key, _) in isSectionOpen {
            isSectionOpen[key] = true
        }
    }
   
    func getFields(for section: PlantObservationSection) -> [InputItem] {
        guard let model = model else {return []}
        switch section {
        case .LocationandGeometry:
            return model.getLocationandGeometryFields(editable: editable)
        case .ObserverInformation:
            return model.getObserverInformationFields(editable: editable)
        case .SpeciesInformationandObservation:
            return model.getSpeciesInformationandObservationFields(editable: editable)
        case .AdvancedDataElements:
            return model.getAdvancedDataElementsFields(editable: editable)
        }
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
        guard let section = PlantObservationSection(rawValue: section), let isOpen = isSectionOpen[section] else { return 0}
        return isOpen ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = PlantObservationSection(rawValue: section) else { return nil}
        let headerView: FormSectionHeader = FormSectionHeader.fromNib()
        switch section {
        case .LocationandGeometry:
            headerView.setup(text: "Location and Geometry", isOpen: isSectionOpen[.LocationandGeometry] ?? false) {[weak self] in
                guard let _self = self else {return}
                _self.isSectionOpen[.LocationandGeometry] = !(_self.isSectionOpen[.LocationandGeometry] ?? false)
                _self.tableView.reloadData()
            }
        case .ObserverInformation:
            headerView.setup(text: "Observer Information", isOpen: isSectionOpen[.ObserverInformation] ?? false) {[weak self] in
                guard let _self = self else {return}
                _self.isSectionOpen[.ObserverInformation] = !(_self.isSectionOpen[.ObserverInformation] ?? false)
                _self.tableView.reloadData()
            }
        case .SpeciesInformationandObservation:
            headerView.setup(text: "Species Information and Observation", isOpen: isSectionOpen[.SpeciesInformationandObservation] ?? false) {[weak self] in
                guard let _self = self else {return}
                _self.isSectionOpen[.SpeciesInformationandObservation] = !(_self.isSectionOpen[.SpeciesInformationandObservation] ?? false)
                _self.tableView.reloadData()
            }
        case .AdvancedDataElements:
            headerView.setup(text: "Advanced Data Elements", isOpen: isSectionOpen[.AdvancedDataElements] ?? false) {[weak self] in
                guard let _self = self else {return}
                _self.isSectionOpen[.AdvancedDataElements] = !(_self.isSectionOpen[.AdvancedDataElements] ?? false)
                _self.tableView.reloadData()
            }
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let type = PlantObservationSection.init(rawValue: indexPath.section) else {return UITableViewCell()}
        let cell = getSectionCell(indexPath: indexPath)
        cell.setup(fields: getFields(for: type), delegate: self)
        return cell
    }
}
