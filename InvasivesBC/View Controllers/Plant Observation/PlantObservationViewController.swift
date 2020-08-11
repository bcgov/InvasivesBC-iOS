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
    
    @IBAction func rightButtonAction(_ sender: Any) {
        if editable {
            // Button is for reviewing
            self.editable = false
            tableView.reloadData()
        } else {
            // Button is for submitting
            showAlert(with: "Cant submit yet", message: "")
        }
    }
    @IBAction func leftButtonAction(_ sender: Any) {
        self.editable = true
        tableView.reloadData()
    }
    
    
    // TODO: Pass intial model to populate form
    func setup(editable: Bool) {
        self.editable = editable
    }
    
    func style() {
        self.title = "Plant Observation"
    }
    
    func styleForState() {
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
        switch section {
        case .LocationandGeometry:
            return getLocationandGeometryFields()
        case .ObserverInformation:
            return getObserverInformationFields()
        case .SpeciesInformationandObservation:
            return getSpeciesInformationandObservationFields()
        case .AdvancedDataElements:
            return getAdvancedDataElementsFields()
        }
    }
    
    private func getLocationandGeometryFields() -> [InputItem] {
        var fields: [InputItem] = []
        let latitude = DoubleInput(
            key: "latitude",
            header: "Latitude",
            editable: editable,
            width: .Half
        )
        fields.append(latitude)
        
        let longitude = DoubleInput(
            key: "longitude",
            header: "Longitude",
            editable: editable,
            width: .Half
        )
        fields.append(longitude)
        
        let geometryType = DropdownInput(
            key: "geometryType",
            header: "Geometry Type",
            editable: editable,
            width: .Half,
            dropdownItems: CodeTableService.shared.getDropdowns(type: "ObservationGeometryCode")
        )
        fields.append(geometryType)
        
        let area = DoubleInput(
            key: "area",
            header: "Area m^2",
            editable: editable,
            width: .Half
        )
        fields.append(area)
        
        let wellDistance = DoubleInput(
            key: "wellDistance",
            header: "Well Distance",
            editable: editable,
            width: .Half
        )
        fields.append(wellDistance)
        
        let wellTagId = DoubleInput(
            key: "wellTagId",
            header: "Well Tag ID",
            editable: editable,
            width: .Half
        )
        fields.append(wellTagId)
        
        return fields
    }
    
    private func getObserverInformationFields() -> [InputItem] {
        var fields: [InputItem] = []
        let firstName = TextInput(
            key: "firstName",
            header: "Observer First Name",
            editable: editable,
            width: .Half
        )
        fields.append(firstName)
        
        let lastName = TextInput(
            key: "lastName",
            header: "Observer Last Name",
            editable: editable,
            width: .Half
        )
        fields.append(lastName)
        
        let time = TimeInput(
            key: "time",
            header: "Time",
            editable: editable,
            width: .Half
        )
        
        fields.append(time)
        
        let date = DateInput(
            key: "date",
            header: "Date",
            editable: editable,
            width: .Half
        )
        
        fields.append(date)
        
        return fields
    }
    
    private func getSpeciesInformationandObservationFields() -> [InputItem] {
        var fields: [InputItem] = []
        let species = DropdownInput(
            key: "species",
            header: "Species",
            editable: editable,
            width: .Third,
            dropdownItems: CodeTableService.shared.getDropdowns(type: "Species")
        )
        fields.append(species)
        
        let observationType = DropdownInput(
            key: "observationType",
            header: "Observation Type",
            editable: editable,
            width: .Third,
            dropdownItems: CodeTableService.shared.getDropdowns(type: "ObservationTypeCode")
        )
        fields.append(observationType)
        
        let agency = DropdownInput(
            key: "agency",
            header: "Agency",
            editable: editable,
            width: .Third,
            dropdownItems: CodeTableService.shared.getDropdowns(type: "SpeciesAgencyCode")
        )
        fields.append(agency)
        ///
        let jurisdiction = DropdownInput(
            key: "jurisdiction",
            header: "Jurisdiction",
            editable: editable,
            width: .Third,
            dropdownItems: CodeTableService.shared.getDropdowns(type: "JurisdictionCode")
        )
        fields.append(jurisdiction)
        
        let distribution = DropdownInput(
            key: "distribution",
            header: "Distribution",
            editable: editable,
            width: .Third,
            dropdownItems: CodeTableService.shared.getDropdowns(type: "SpeciesDistributionCode")
        )
        fields.append(distribution)
        
        let density = DropdownInput(
            key: "density",
            header: "Density",
            editable: editable,
            width: .Third,
            dropdownItems: CodeTableService.shared.getDropdowns(type: "SpeciesDensityCode")
        )
        fields.append(density)
        ///
        let soilTexture = DropdownInput(
            key: "soilTexture",
            header: "Soil Texture",
            editable: editable,
            width: .Third,
            dropdownItems: CodeTableService.shared.getDropdowns(type: "SoilTextureCode")
        )
        fields.append(soilTexture)
        
        let slope = DropdownInput(
            key: "slope",
            header: "Slope",
            editable: editable,
            width: .Third,
            dropdownItems: CodeTableService.shared.getDropdowns(type: "SlopeCode")
        )
        fields.append(slope)
        
        let aspect = DropdownInput(
            key: "aspect",
            header: "Aspect",
            editable: editable,
            width: .Third,
            dropdownItems: CodeTableService.shared.getDropdowns(type: "AspectCode")
        )
        fields.append(aspect)
        ///
        /// TODO: Code table doesnt exist
        let flowering = DropdownInput(
            key: "flowering",
            header: "Flowering",
            editable: editable,
            width: .Third
//            dropdownItems: CodeTableService.shared.getDropdowns(type: "JurisdictionCode")
        )
        fields.append(flowering)
        
        let specificUse = DropdownInput(
            key: "specificUse",
            header: "Specific Use",
            editable: editable,
            width: .Third,
            dropdownItems: CodeTableService.shared.getDropdowns(type: "SpecificUseCode")
        )
        fields.append(specificUse)
        
        let proposedAction = DropdownInput(
            key: "proposedAction",
            header: "Proposed Action",
            editable: editable,
            width: .Third,
            dropdownItems: CodeTableService.shared.getDropdowns(type: "ProposedActionCode")
        )
        fields.append(proposedAction)
        ///
        /// TODO: Code table doesnt exist
        let seedStage = DropdownInput(
            key: "seedStage",
            header: "Seed Stage",
            editable: editable,
            width: .Third
//            dropdownItems: CodeTableService.shared.getDropdowns(type: "JurisdictionCode")
        )
        fields.append(seedStage)
        
        /// TODO: Code table doesnt exist
        let plantHealth = DropdownInput(
            key: "plantHealth",
            header: "Plant Health",
            editable: editable,
            width: .Third
//            dropdownItems: CodeTableService.shared.getDropdowns(type: "JurisdictionCode")
        )
        fields.append(plantHealth)
        
        let plantLifeStage = DropdownInput(
            key: "plantLifeStage",
            header: "Plant Life Stage",
            editable: editable,
            width: .Third,
            dropdownItems: CodeTableService.shared.getDropdowns(type: "LifeStageCode")
        )
        fields.append(plantLifeStage)
        
        return fields
    }
    
    private func getAdvancedDataElementsFields() -> [InputItem] {
        var fields: [InputItem] = []
        let earlyDetection = SwitchInput(
            key: "earlyDetection",
            header: "Early Detection",
            editable: editable,
            width: .Third
        )
        fields.append(earlyDetection)
        
        let research = SwitchInput(
            key: "research",
            header: "Research",
            editable: editable,
            width: .Third
        )
        fields.append(research)
        
        let wellOnSite = SwitchInput(
            key: "wellOnSite",
            header: "Well On Site",
            editable: editable,
            width: .Third
        )
        fields.append(wellOnSite)
        ///
        let specialCare = SwitchInput(
            key: "specialCare",
            header: "Special Care",
            editable: editable,
            width: .Third
        )
        fields.append(specialCare)
        
        let biologicalCare = SwitchInput(
            key: "biologicalCare",
            header: "Biological Care",
            editable: editable,
            width: .Third
        )
        fields.append(biologicalCare)
        
        let legacySite = SwitchInput(
            key: "legacySite",
            header: "Legacy Site",
            editable: editable,
            width: .Third
        )
        fields.append(legacySite)
        ///
        let primaryFileId = TextInput(
            key: "primaryFileId",
            header: "Primary File ID",
            editable: editable,
            width: .Third
        )
        fields.append(primaryFileId)
        
        let secondaryFileId = TextInput(
            key: "secondaryFileId",
            header: "Secondary File ID",
            editable: editable,
            width: .Third
        )
        fields.append(secondaryFileId)
        
        let rangeUnit = TextInput(
            key: "rangeUnit",
            header: "Range Unit",
            editable: editable,
            width: .Third
        )
        fields.append(rangeUnit)
        ///
        let locationComments = TextAreaInput(
            key: "locationComments",
            header: "Location / Access Comments",
            editable: editable,
            width: .Full
        )
        fields.append(locationComments)
        
        let generalComments = TextAreaInput(
            key: "generalComments",
            header: "General Observation Comments",
            editable: editable,
            width: .Full
        )
        fields.append(generalComments)
        ///
        let photoTaken = SwitchInput(
            key: "photoTaken",
            header: "Photo Taken",
            editable: editable,
            width: .Third
        )
        fields.append(photoTaken)
        
        let sampleTaken = SwitchInput(
            key: "sampleTaken",
            header: "Sample Taken",
            editable: editable,
            width: .Third
        )
        fields.append(sampleTaken)
        
        let sampleNumber = TextInput(
            key: "sampleNumber",
            header: "Sample Number",
            editable: editable,
            width: .Third
        )
        fields.append(sampleNumber)
        ///
        let negativeObservation = SwitchInput(
            key: "negativeObservation",
            header: "Photo Taken",
            editable: editable,
            width: .Half
        )
        fields.append(negativeObservation)
        
        let aquaticObservation = SwitchInput(
            key: "aquaticObservation",
            header: "Aquatic Observation",
            editable: editable,
            width: .Half
        )
        fields.append(aquaticObservation)
        
        return fields
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
        cell.setup(fields: getFields(for: type), delegagte: self)
        return cell
    }
}
