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
            label.text = "As any mobile data editor user, I want to be directed to the \"Define geometry\" page once I've selected I want to create an observation or treatment"
        case .TwoPoint:
            button.setTitle("2 Point Box", for: .normal)
            iconContainer.image = UIImage(named: "2Point")
            label.text = "As any mobile data editor user, I want to be directed to the \"Define geometry\" page once I've selected I want to create an observation or treatment"
        case .WayPoint:
            button.setTitle("Waypoint Path", for: .normal)
            iconContainer.image = UIImage(named: "waypoint")
            label.text = "As any mobile data editor user, I want to be directed to the \"Define geometry\" page once I've selected I want to create an observation or treatment"
        case .Polygon:
            button.setTitle("Polygon", for: .normal)
            iconContainer.image = UIImage(named: "Polygon")
            label.text = "As any mobile data editor user, I want to be directed to the \"Define geometry\" page once I've selected I want to create an observation or treatment"
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
