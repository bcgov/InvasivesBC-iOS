//
//  FormGroup.swift
//  InvasivesBC
//
//  Created by Pushan  on 2020-04-08.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import Foundation
import UIKit

// MARK: FieldGroup
// FormGroup: View Class to arrnage and view field elements
class  FieldGroup: UIView {
    // MARK: Property: Public
    var fields: [FieldConfig] = []
    // MARK: Property: Private
    // Collection View: Will Display fiels as collection view cell
    private weak var collectionView: UICollectionView? = nil
    
    // MARK: Public Function
    // Initialize FormGroup
    public func initialize(with fields: [FieldConfig], in container: UIView) {}
    
    // Calculate estimated content height
    public static func estimateContentHeight(for fields: [FieldConfig]) -> CGFloat {
        let assumedCellSpacing: CGFloat = 10
        var rowHeights: [CGFloat] = []
        var widthCounter: CGFloat = 0
        var tempMaxRowItemHeight: CGFloat = 0
        for (index, item) in fields.enumerated()  {
            
            var itemWidth: CGFloat = 0
            // Get Width in terms of screen %
            switch item.width {
            case .Full:
                itemWidth = 100
            case .Half:
                itemWidth = 50
            case .Third:
                itemWidth = 33
            case .Forth:
                itemWidth = 25
            case .Fill:
                itemWidth = 100 - widthCounter
            }
            // If the new row witdh + current row width exceeds 100, item will be in the next row
            if (widthCounter + itemWidth) > 100 {
                // Store previous row's max height
                rowHeights.append(tempMaxRowItemHeight + assumedCellSpacing)
                tempMaxRowItemHeight = 0
                widthCounter = 0
            }
            
            // TODO: handle height for items with dependency where dependency is not satisfied
           
            
            // If current item's height is greater than the max item height for row
            // set max item hight for row
            if tempMaxRowItemHeight < item.height {
                tempMaxRowItemHeight = item.height
            }
            // increase width counter
            widthCounter = widthCounter + itemWidth
            
            // if its the last item, add rowheight
            if index == (fields.count - 1) {
                rowHeights.append(tempMaxRowItemHeight)
            }
        }
        
        var computedHeight: CGFloat = 0
        for rowHeight in rowHeights {
            computedHeight = computedHeight + rowHeight
        }
        return computedHeight
    }
    
    
    // MARK: Destroy
    deinit {
        InfoLog("\(self)")
    }
    
}

// MARK: FieldGroup - View Update Functions
extension FieldGroup {
    // MARK: Private Function
    // Adding autolayout constraints respect of container view
    private func addConstraints(for view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        self.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    // Adding autolayout constraints to collection view
    private func addCollectionVIewConstraints() {
       guard let collection = self.collectionView else {return}
       collection.translatesAutoresizingMaskIntoConstraints = false
       collection.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
       collection.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
       collection.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
       collection.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    // Collection View Creation
    private func createCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height), collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.isScrollEnabled = false
        self.collectionView = collection
        self.addSubview(collection)
        addCollectionVIewConstraints()
    }
}
