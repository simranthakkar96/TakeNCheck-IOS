//
//  SNotesTableViewCell.swift
//  Notes
//
//  Created by Nayna on 11/19/19.
//  Copyright © 2019 Apple Developer. All rights reserved.
//

import UIKit
import MapKit
class SNotesTableViewCell: UITableViewCell {

    @IBOutlet weak var contView: UIView!
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var SNtitle: UILabel!
       @IBOutlet weak var SNcategory: UILabel!
       
       @IBOutlet weak var SNdate: UILabel!
       @IBOutlet weak var SNdescription: UILabel!
       
       @IBOutlet weak var SNimg: UIImageView!
       
       @IBOutlet weak var SNmapview: MKMapView!
    
    
    let locationManager = CLLocationManager()
       let regionInMeters: Double = 1000
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        shadowView.layer.shadowColor =  UIColor(red:0/255.0, green:0/255.0, blue:0/255.0, alpha: 1.0).cgColor
             shadowView.layer.shadowOffset = CGSize(width: 0.75, height: 0.75)
             shadowView.layer.shadowRadius = 1.5
             shadowView.layer.shadowOpacity = 0.7
             shadowView.layer.cornerRadius = 10
             SNmapview.layer.cornerRadius = 20
             contView.layer.cornerRadius = 15
             //self.backgroundColor = UIColor(patternImage: UIImage(named: "splash.jpg")!)
             SNimg.layer.cornerRadius = 10
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(note: Note) {
        
        self.SNtitle.text = note.noteName?.uppercased()
        self.SNdescription.text = note.noteDescription
        self.SNcategory.text = note.noteCategory
        
        self.SNimg.image = UIImage(data: note.noteImage! as Data)
        self.SNdate.text = note.noteDate
        let location = CLLocationCoordinate2DMake(note.noteLat, note.noteLong);
        let region = MKCoordinateRegionMakeWithDistance(location, regionInMeters, regionInMeters)
        self.SNmapview.setRegion(region, animated: true)
        // Drop a pin
        let dropPin = MKPointAnnotation();
        dropPin.coordinate = location;
       // dropPin.title = "Le Normandie Restaurant";
        self.SNmapview.addAnnotation(dropPin);
    }

}
