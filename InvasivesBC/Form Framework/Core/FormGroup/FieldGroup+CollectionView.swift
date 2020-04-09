//
//  FieldGroup+CollectionView.swift
//  InvasivesBC
//
//  Created by Pushan  on 2020-04-08.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import Foundation
import UIKit

// Supporting Form Cell for CollectionView
extension UICollectionView {
    
    // Generic method to obtain FieldCell
    func dequeueReusableFieldCell(type: FieldGroup.FieldCellType, for index: IndexPath) -> FieldCell {
        return self.dequeueReusableCell(withFieldType: type, for: index) as! FieldCell
    }
    
    func dequeueReusableTextFieldCell(for indexPath: IndexPath) -> TextFieldCollectionViewCell {
        return self.dequeueReusableFieldCell(type: .text, for: indexPath) as! TextFieldCollectionViewCell
    }
    
    
    

}

extension FieldGroup: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Count = \(fields.count) ")
        return fields.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let config = fields[indexPath.row]
        let cell = collectionView.dequeueReusableFieldCell(type: config.fieldCellType, for: indexPath)
        cell.initialize(model: config, presenter: self.preseneter)
       return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
    
}
