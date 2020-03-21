//
//  SubjectTableViewCell.swift
//  Notes
//
//  Created by Nayna on 11/19/19.
//  Copyright © 2019 Apple Developer. All rights reserved.
//

import UIKit

class SubjectTableViewCell: UITableViewCell {

    @IBOutlet weak var shadowView: UIView!
   // @IBOutlet weak var contView: UIView!
    
    @IBOutlet weak var contView: UIView!
    @IBOutlet weak var subject: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
               shadowView.layer.shadowColor =  UIColor(red:0/255.0, green:0/255.0, blue:0/255.0, alpha: 1.0).cgColor
                    shadowView.layer.shadowOffset = CGSize(width: 0.75, height: 0.75)
                    shadowView.layer.shadowRadius = 1.5
                    shadowView.layer.shadowOpacity = 0.7
                    shadowView.layer.cornerRadius = 10
                 
                    contView.layer.cornerRadius = 15
                 
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
