//
//  ObservationFields.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-08-12.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import Foundation

extension PlantObservationModel {
    func getLocationandGeometryFields(editable: Bool) -> [InputItem] {
        
        var fields: [InputItem] = []
        let latitude = DoubleInput(
            key: "latitude",
            header: "Latitude",
            editable: editable,
            value: self.latitude.roundToDecimal(6),
            width: .Half
        )
        fields.append(latitude)
        
        let longitude = DoubleInput(
            key: "longitude",
            header: "Longitude",
            editable: editable,
            value: self.longitude.roundToDecimal(6),
            width: .Half
        )
        fields.append(longitude)
        
        let geometryType = DropdownInput(
            key: "observationGeometryCode",
            header: "Geometry Type",
            editable: editable,
            value: self.observationGeometryCode,
            width: .Half,
            dropdownItems: CodeTableService.shared.getDropdowns(type: "ObservationGeometryCode")
        )
        fields.append(geometryType)
        
        let area = DoubleInput(
            key: "area",
            header: "Area m^2",
            editable: editable,
            value: self.area.roundToDecimal(1),
            width: .Half
        )
        fields.append(area)
        
        let wellDistance = DoubleInput(
            key: "wellDistance",
            header: "Well Distance",
            editable: editable,
            value: self.wellDistance,
            width: .Half
        )
        fields.append(wellDistance)
        
        let wellTagId = DoubleInput(
            key: "wellTagId",
            header: "Well Tag ID",
            editable: editable,
            value: self.wellTagId,
            width: .Half
        )
        fields.append(wellTagId)
        
        return fields
    }
    
    func getObserverInformationFields(editable: Bool) -> [InputItem] {
        var fields: [InputItem] = []
        let firstName = TextInput(
            key: "firstName",
            header: "Observer First Name",
            editable: editable,
            value: self.firstName,
            width: .Half
        )
        fields.append(firstName)
        
        let lastName = TextInput(
            key: "lastName",
            header: "Observer Last Name",
            editable: editable,
            value: self.lastName,
            width: .Half
        )
        fields.append(lastName)
        
        let time = TimeInput(
            key: "time",
            header: "Time",
            editable: editable,
            value: self.time,
            width: .Half
        )
        
        fields.append(time)
        
        let date = DateInput(
            key: "date",
            header: "Date",
            editable: editable,
            value: self.date,
            width: .Half
        )
        
        fields.append(date)
        
        return fields
    }
    
    func getSpeciesInformationandObservationFields(editable: Bool) -> [InputItem] {
        var fields: [InputItem] = []
        let species = DropdownInput(
            key: "species",
            header: "Species",
            editable: editable,
            value: self.species,
            width: .Third,
            dropdownItems: CodeTableService.shared.getDropdowns(type: "Species")
        )
        fields.append(species)
        
        let observationType = DropdownInput(
            key: "observationTypeCode",
            header: "Observation Type",
            editable: editable,
            value: self.observationTypeCode,
            width: .Third,
            dropdownItems: CodeTableService.shared.getDropdowns(type: "ObservationTypeCode")
        )
        fields.append(observationType)
        
        let agency = DropdownInput(
            key: "speciesAgencyCode",
            header: "Agency",
            editable: editable,
            value: self.speciesAgencyCode,
            width: .Third,
            dropdownItems: CodeTableService.shared.getDropdowns(type: "SpeciesAgencyCode")
        )
        fields.append(agency)
        ///
        let jurisdiction = DropdownInput(
            key: "jurisdictionCode",
            header: "Jurisdiction",
            editable: editable,
            value: self.jurisdictionCode,
            width: .Third,
            dropdownItems: CodeTableService.shared.getDropdowns(type: "JurisdictionCode")
        )
        fields.append(jurisdiction)
        
        let distribution = DropdownInput(
            key: "speciesDistributionCode",
            header: "Distribution",
            editable: editable,
            value: self.speciesDistributionCode,
            width: .Third,
            dropdownItems: CodeTableService.shared.getDropdowns(type: "SpeciesDistributionCode")
        )
        fields.append(distribution)
        
        let density = DropdownInput(
            key: "speciesDensityCode",
            header: "Density",
            editable: editable,
            value: self.speciesDensityCode,
            width: .Third,
            dropdownItems: CodeTableService.shared.getDropdowns(type: "SpeciesDensityCode")
        )
        fields.append(density)
        ///
        let soilTexture = DropdownInput(
            key: "soilTextureCode",
            header: "Soil Texture",
            editable: editable,
            value: self.soilTextureCode,
            width: .Third,
            dropdownItems: CodeTableService.shared.getDropdowns(type: "SoilTextureCode")
        )
        fields.append(soilTexture)
        
        let slope = DropdownInput(
            key: "slopeCode",
            header: "Slope",
            editable: editable,
            value: self.slopeCode,
            width: .Third,
            dropdownItems: CodeTableService.shared.getDropdowns(type: "SlopeCode")
        )
        fields.append(slope)
        
        let aspect = DropdownInput(
            key: "aspectCode",
            header: "Aspect",
            editable: editable,
            value: self.aspectCode,
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
            value: self.flowering,
            width: .Third
            //            dropdownItems: CodeTableService.shared.getDropdowns(type: "JurisdictionCode")
        )
        fields.append(flowering)
        
        let specificUse = DropdownInput(
            key: "specificUseCode",
            header: "Specific Use",
            editable: editable,
            value: self.specificUseCode,
            width: .Third,
            dropdownItems: CodeTableService.shared.getDropdowns(type: "SpecificUseCode")
        )
        fields.append(specificUse)
        
        let proposedAction = DropdownInput(
            key: "proposedActionCode",
            header: "Proposed Action",
            editable: editable,
            value: self.proposedActionCode,
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
            value: self.seedStage,
            width: .Third
            //            dropdownItems: CodeTableService.shared.getDropdowns(type: "JurisdictionCode")
        )
        fields.append(seedStage)
        
        /// TODO: Code table doesnt exist
        let plantHealth = DropdownInput(
            key: "plantHealth",
            header: "Plant Health",
            editable: editable,
            value: self.plantHealth,
            width: .Third
            //            dropdownItems: CodeTableService.shared.getDropdowns(type: "JurisdictionCode")
        )
        fields.append(plantHealth)
        
        let plantLifeStage = DropdownInput(
            key: "lifeStageCode",
            header: "Plant Life Stage",
            editable: editable,
            value: self.lifeStageCode,
            width: .Third,
            dropdownItems: CodeTableService.shared.getDropdowns(type: "LifeStageCode")
        )
        fields.append(plantLifeStage)
        
        return fields
    }
    
    func getAdvancedDataElementsFields(editable: Bool) -> [InputItem] {
        var fields: [InputItem] = []
        let earlyDetection = SwitchInput(
            key: "earlyDetection",
            header: "Early Detection",
            editable: editable,
            value: self.earlyDetection,
            width: .Third
        )
        fields.append(earlyDetection)
        
        let research = SwitchInput(
            key: "research",
            header: "Research",
            editable: editable,
            value: self.research,
            width: .Third
        )
        fields.append(research)
        
        let wellOnSite = SwitchInput(
            key: "wellOnSite",
            header: "Well On Site",
            editable: editable,
            value: self.wellOnSite,
            width: .Third
        )
        fields.append(wellOnSite)
        ///
        let specialCare = SwitchInput(
            key: "specialCare",
            header: "Special Care",
            editable: editable,
            value: self.specialCare,
            width: .Third
        )
        fields.append(specialCare)
        
        let biologicalCare = SwitchInput(
            key: "biologicalCare",
            header: "Biological Care",
            editable: editable,
            value: self.biologicalCare,
            width: .Third
        )
        fields.append(biologicalCare)
        
        let legacySite = SwitchInput(
            key: "legacySite",
            header: "Legacy Site",
            editable: editable,
            value: self.legacySite,
            width: .Third
        )
        fields.append(legacySite)
        ///
        let primaryFileId = TextInput(
            key: "primaryFileId",
            header: "Primary File ID",
            editable: editable,
            value: self.primaryFileId,
            width: .Third
        )
        fields.append(primaryFileId)
        
        let secondaryFileId = TextInput(
            key: "secondaryFileId",
            header: "Secondary File ID",
            editable: editable,
            value: self.secondaryFileId,
            width: .Third
        )
        fields.append(secondaryFileId)
        
        let rangeUnit = TextInput(
            key: "rangeUnit",
            header: "Range Unit",
            editable: editable,
            value: self.rangeUnit,
            width: .Third
        )
        fields.append(rangeUnit)
        ///
        let locationComments = TextAreaInput(
            key: "locationComments",
            header: "Location / Access Comments",
            editable: editable,
            value: self.locationComments,
            width: .Full
        )
        fields.append(locationComments)
        
        let generalComments = TextAreaInput(
            key: "generalComments",
            header: "General Observation Comments",
            editable: editable,
            value: self.generalComments,
            width: .Full
        )
        fields.append(generalComments)
        ///
        let photoTaken = SwitchInput(
            key: "photoTaken",
            header: "Photo Taken",
            editable: editable,
            value: self.photoTaken,
            width: .Third
        )
        fields.append(photoTaken)
        
        let sampleTaken = SwitchInput(
            key: "sampleTaken",
            header: "Sample Taken",
            editable: editable,
            value: self.sampleTaken,
            width: .Third
        )
        fields.append(sampleTaken)
        
        let sampleNumber = TextInput(
            key: "sampleNumber",
            header: "Sample Number",
            editable: editable,
            value: self.sampleNumber,
            width: .Third
        )
        fields.append(sampleNumber)
        ///
        let negativeObservation = SwitchInput(
            key: "negativeObservation",
            header: "Negative Observation",
            editable: editable,
            value: self.negativeObservation,
            width: .Half
        )
        fields.append(negativeObservation)
        
        let aquaticObservation = SwitchInput(
            key: "aquaticObservation",
            header: "Aquatic Observation",
            editable: editable,
            value: self.aquaticObservation,
            width: .Half
        )
        fields.append(aquaticObservation)
        
        return fields
    }
}
