//
//  SelectGeometryTypeTableViewCell.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-08-10.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import UIKit

class SelectGeometryTypeTableViewCell: UITableViewCell, Theme {
    
    var completion: (()->Void)?
    
    @IBOutlet weak var iconContainer: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        guard let callback = completion else {return}
        callback()
    }
    
    func setup(type: DefineGeometryType, onTap: @escaping ()->Void) {
        style()
        completion = onTap
        switch type {
        case .Point:
            button.setTitle("Point Observation", for: .normal)
            iconContainer.image = UIImage(named: "PointObservation")
            label.text = "Click on the approximate centre of your area and extend the radius feature to capture an area up to 100 sq meters."
        case .TwoPoint:
            button.setTitle("2 Point Box", for: .normal)
            iconContainer.image = UIImage(named: "2Point")
            label.text = "Click on the approximate centre of your area then specify a height length and width value."
        case .WayPoint:
            button.setTitle("Waypoint Path", for: .normal)
            iconContainer.image = UIImage(named: "waypoint")
            label.text = "Define 2 or more points along the center of a path then specify a buffer width value."
        case .Polygon:
            button.setTitle("Polygon", for: .normal)
            iconContainer.image = UIImage(named: "Polygon")
            label.text = "Define 3 or more points along the boundary edge then return to your start point to close the polygon."
        }
    }
    
    
    func style() {
        if UIDevice.current.userInterfaceIdiom == .phone {
            label.isHidden = true
        }
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        styleHollowButton(button: button)
        label.font = UIFont.regular(size: 17)
    }
}
