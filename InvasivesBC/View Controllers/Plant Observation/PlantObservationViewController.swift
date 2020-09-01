//
//  PlantObservationViewController.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-08-11.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import UIKit
import GRDB
import MapKit


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
                                          deviceRequestUID: "DeviceUID123",
                                          date: Date(),
                                          synched: false,
                                          synch_error: false,
                                          synch_error_string: "")
    
    
    
    var observationRecord =  Observation(local_activity_id: 0,
    negative_observation_ind: false,
    aquatic_observation_ind: false,
    primary_user_first_name: "",
    primary_user_last_name: "",
    secondary_user_first_name: "",
    secondary_user_last_name: "",
    species: "",
    primary_file_id: "",
    secondary_file_id: "",
    location_comment: "",
    general_observation_comment: "",
    sample_taken_ind: false,
    sample_label_number: "")
    
    
    
    
    
    var terrestrialPlantRecord =  TerrestrialPlant( local_activity_id: 0,
    species: "",
    distribution: "",
    density: "",
    soil_texture: "",
    slope: "",
    aspect: "",
    flowering: "",
    specific_use: "",
    proposed_action: "",
    seed_stage: "",
    plant_health: "",
    plant_life_stage: "",
    early_detection: false,
    research: false,
    well_on_site_ind: false,
    special_care_ind: false,
    biological_care_ind: false,
    legacy_site_ind: false,
    range_unit: "")
    
    // where fields for the form are defined
    var model: PlantObservationModel?
    
    // the grdb way:
    var record: Activity?
    
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
        
    
    }
    
    
    // MARK: Database commit
    func insertRecord(){
        let dbQueue = self.delegate.dbQueue
        
       // self.activityRecord.latitude = 50
       // self.activityRecord.longitude = 50
        
        try! dbQueue.write { db in
        // Write database rows
            try! self.activityRecord.insert(db)
            print("activity id:\(self.activityRecord.local_id)")
          
            self.observationRecord.local_activity_id = self.activityRecord.local_id ?? 0
            try! self.observationRecord.insert(db)
            
            self.terrestrialPlantRecord.local_activity_id = self.observationRecord.local_id ?? 0
            try! self.terrestrialPlantRecord.insert(db)
            
            
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
    

    //  MARK:  MAP UI Fields to GRDB Model on Field changed
    @objc func inputItemValueChanged(notification: Notification) {
        guard let item: InputItem = notification.object as? InputItem else {return}
        
        switch item.key {
        case "date":
                   self.activityRecord.date = (item.value.get(type: item.type)) as! Date
        case "negativeObservation":
            self.observationRecord.negative_observation_ind = (item.value.get(type: item.type)) as! Bool
        case "aquaticObservation":
            self.observationRecord.aquatic_observation_ind = (item.value.get(type: item.type)) as! Bool
        case "firstName":
            self.observationRecord.primary_user_first_name = (item.value.get(type: item.type)) as! String
        case "lastName":
            self.observationRecord.primary_user_last_name = (item.value.get(type: item.type)) as! String
        case "species":
            self.observationRecord.species = (item.value.get(type: item.type)) as! String
            self.terrestrialPlantRecord.species = (item.value.get(type: item.type)) as! String
        case "primaryFileId":
            self.observationRecord.primary_file_id = (item.value.get(type: item.type)) as! String
        case "secondaryFileId":
            self.observationRecord.secondary_file_id = (item.value.get(type: item.type)) as! String
        case "locationComments":
            self.observationRecord.location_comment = (item.value.get(type: item.type)) as! String
        case "generalComments":
            self.observationRecord.general_observation_comment = (item.value.get(type: item.type)) as! String
            
        case "sampleTaken":
            self.observationRecord.sample_taken_ind = (item.value.get(type: item.type)) as! Bool
        case "sampleNumber":
            self.observationRecord.sample_label_number = (item.value.get(type: item.type)) as! String
        case "speciesDistributionCode":
            self.terrestrialPlantRecord.distribution = (item.value.get(type: item.type)) as! String
        case "speciesDensityCode":
            self.terrestrialPlantRecord.density = (item.value.get(type: item.type)) as! String
        case "soilTextureCode":
            self.terrestrialPlantRecord.soil_texture = (item.value.get(type: item.type)) as! String
        case "slopeCode":
            self.terrestrialPlantRecord.slope = (item.value.get(type: item.type)) as! String
        case "aspectCode":
            self.terrestrialPlantRecord.aspect = (item.value.get(type: item.type)) as! String
        case "flowering":
            self.terrestrialPlantRecord.flowering = (item.value.get(type: item.type)) as! String
        case "specificUseCode":
            self.terrestrialPlantRecord.specific_use = (item.value.get(type: item.type)) as! String
        case "proposedActionCode":
            self.terrestrialPlantRecord.proposed_action = (item.value.get(type: item.type)) as! String
        case "seedStage":
            self.terrestrialPlantRecord.seed_stage = (item.value.get(type: item.type)) as! String
        case "plantHealth":
            self.terrestrialPlantRecord.plant_health = (item.value.get(type: item.type)) as! String
        case "lifeStageCode":
            self.terrestrialPlantRecord.plant_life_stage = (item.value.get(type: item.type)) as! String
        case "earlyDetection":
            self.terrestrialPlantRecord.early_detection = (item.value.get(type: item.type)) as! Bool
        case "research":
            self.terrestrialPlantRecord.research = (item.value.get(type: item.type)) as! Bool
        case "wellOnSite":
            self.terrestrialPlantRecord.well_on_site_ind = (item.value.get(type: item.type)) as! Bool
        case "specialCare":
            self.terrestrialPlantRecord.special_care_ind = (item.value.get(type: item.type)) as! Bool
        case "biologicalCare":
            self.terrestrialPlantRecord.biological_care_ind = (item.value.get(type: item.type)) as! Bool
        case "legacySite":
            self.terrestrialPlantRecord.legacy_site_ind = (item.value.get(type: item.type)) as! Bool
        case "rangeUnit":
            self.terrestrialPlantRecord.range_unit = (item.value.get(type: item.type)) as! String
        default:
            print("Didn't have a database field to map to, name of UI field key was:\(item.key)")
        }
    }
    
//    
//    var secondary_user_first_name: String
//    var secondary_user_last_name: String
//    var species: String
//    var primary_file_id: String
//    var secondary_file_id: String
//    var location_comment: String
//    var general_observation_comment: String
//    var sample_taken_ind: String
//    var sample_label_number: String
//    
    
    
    @IBAction func rightButtonAction(_ sender: Any) {
        savePlantObservation()
        
//        if editable {
//            // Button is for reviewing
//            self.editable = false
//            self.openAllSections()
//
//
//            tableView.reloadData()
//        } else {
//            // Button is for submitting
//            savePlantObservation()
//        }
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
        
        insertRecord()
        
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
        rightButton.setTitle("Submit", for: .normal)
        rightButton.center = self.view.center
        leftButton.alpha = 0
        
        //if editable {
            //leftButton.isHidden = true
            //rightButton.setTitle("Proceed to review", for: .normal)
           // rightButton.setTitle("Submit", for: .normal)
       // } else {
            //leftButton.isHidden = false
            //rightButton.setTitle("Submit", for: .normal)
       // }
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
