//
//  noteTableViewCell.swift
//  Notes
//
//  Created by Farzaad on 6/11/19.
//  Copyright © 2019 Apple Developer. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class noteTableViewCell: UITableViewCell {

    @IBOutlet weak var contView: UIView!
    @IBOutlet weak var cellview: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var noteNameLabel: UILabel!
    @IBOutlet weak var noteDescriptionLabel: UILabel!
    
    @IBOutlet weak var noteCategory: UILabel!
    @IBOutlet weak var noteImageView: UIImageView!
    @IBOutlet weak var datelbl: UILabel!
    @IBOutlet weak var mapview: MKMapView!
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Styles
      //  cellview.backgroundColor = UIColor(patternImage: UIImage(named: "splash.jpg")!)
        shadowView.layer.shadowColor =  UIColor(red:0/255.0, green:0/255.0, blue:0/255.0, alpha: 1.0).cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0.75, height: 0.75)
        shadowView.layer.shadowRadius = 1.5
        shadowView.layer.shadowOpacity = 0.7
        shadowView.layer.cornerRadius = 10
        mapview.layer.cornerRadius = 20
        contView.layer.cornerRadius = 15
        //self.backgroundColor = UIColor(patternImage: UIImage(named: "splash.jpg")!)
        noteImageView.layer.cornerRadius = 10
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureCell(note: Note) {
        
        self.noteNameLabel.text = note.noteName?.uppercased()
        self.noteDescriptionLabel.text = note.noteDescription
        self.noteCategory.text = note.noteCategory
        
        self.noteImageView.image = UIImage(data: note.noteImage! as Data)
        self.datelbl.text = note.noteDate
        let location = CLLocationCoordinate2DMake(note.noteLat, note.noteLong);
        let region = MKCoordinateRegionMakeWithDistance(location, regionInMeters, regionInMeters)
        self.mapview.setRegion(region, animated: true)
        // Drop a pin
        let dropPin = MKPointAnnotation();
        dropPin.coordinate = location;
       // dropPin.title = "Le Normandie Restaurant";
        self.mapview.addAnnotation(dropPin);
    }

  
}
