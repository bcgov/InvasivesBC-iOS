//
//  Observation.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-08-12.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class ObservationModel: BaseObject {
    
    @objc dynamic var userId: String = ""
    
    @objc dynamic var status: String = "Draft"
    
    let drodownKeys: [String] = [
        "geometryType",
        "species",
        "observationType",
        "agency",
        "jurisdiction",
        "density",
        "soilTexture",
        "slope",
        "aspect",
        "flowering",
        "specificUse",
        "proposedAction",
        "seedStage",
        "plantLifeStage",
        "plantHealth",
        "",
        "",
        "",
        "",
    ]
    
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    @objc dynamic var ObservationGeometryCode: String = ""
    @objc dynamic var area: Double = 0
    @objc dynamic var wellDistance: Double = 0
    
    @objc dynamic var wellTagId: Double = 0
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var time: Date?
    @objc dynamic var date: Date?
    @objc dynamic var species: String = ""
    @objc dynamic var ObservationTypeCode: String = ""
    @objc dynamic var agency: String = ""
    @objc dynamic var jurisdiction: String = ""
    @objc dynamic var density: String = ""
    @objc dynamic var soilTexture: String = ""
    
    @objc dynamic var slope: String = ""
    @objc dynamic var aspect: String = ""
    @objc dynamic var flowering: String = ""
    @objc dynamic var specificUse: String = ""
    @objc dynamic var proposedAction: String = ""
    @objc dynamic var seedStage: String = ""
    @objc dynamic var plantHealth: String = ""
    @objc dynamic var plantLifeStage: String = ""
    
    @objc dynamic var earlyDetection: Bool = false
    @objc dynamic var research: Bool = false
    @objc dynamic var wellOnSite: Bool = false
    @objc dynamic var specialCare: Bool = false
    @objc dynamic var biologicalCare: Bool = false
    @objc dynamic var legacySite: Bool = false
    
    @objc dynamic var primaryFileId: String = ""
    @objc dynamic var secondaryFileId: String = ""
    @objc dynamic var rangeUnit: String = ""
    @objc dynamic var locationComments: String = ""
    @objc dynamic var generalComments: String = ""
    
    @objc dynamic var photoTaken: Bool = false
    @objc dynamic var sampleTaken: Bool = false
    @objc dynamic var sampleNumber: String = ""
    
    @objc dynamic var negativeObservation: Bool = false
    @objc dynamic var aquaticObservation: Bool = false
    
    
    // MARK: Setters
    func set(value: Any, for key: String) {
        if self[key] == nil {
            print("\(key) is nil")
            return
        }
        do {
            let realm = try Realm()
            try realm.write {
                self[key] = value
            }
        } catch let error as NSError {
            print("** REALM ERROR")
            print(error)
        }
    }
    
    func set(shouldSync should: Bool) {
        do {
            let realm = try Realm()
            try realm.write {
                self.sync = should
                self.status = should ? "Pending Sync" : "Draft"
            }
        } catch let error as NSError {
            print("** REALM ERROR")
            print(error)
        }
    }
    
    
}


extension ObservationModel {
    private func getLocationandGeometryFields(editable: Bool) -> [InputItem] {
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
            key: "ObservationGeometryCode",
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
    
    private func getObserverInformationFields(editable: Bool) -> [InputItem] {
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
    
    private func getSpeciesInformationandObservationFields(editable: Bool) -> [InputItem] {
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
            key: "ObservationTypeCode",
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
    
    private func getAdvancedDataElementsFields(editable: Bool) -> [InputItem] {
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
