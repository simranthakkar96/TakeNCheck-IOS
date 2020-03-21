//
//  ViewController.swift
//  Notes
//
//  Created by Farzaad on 6/11/19.
//  Copyright © 2019 Apple Developer. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreLocation


   var category = ["Other"]

class noteViewController: UIViewController, UITextFieldDelegate,  UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate,UIPickerViewDataSource, UIPickerViewDelegate {
   

    @IBOutlet weak var noteInfoView: UIView!
    
    @IBOutlet weak var noteCategory: UITextField!
    @IBOutlet weak var noteDateLabel: UILabel!
    @IBOutlet weak var noteNameLabel: UITextField!
    @IBOutlet weak var noteDescriptionLabel: UITextView!
    
    @IBOutlet weak var noteImageView: UIImageView!
    
    @IBOutlet weak var mapview: MKMapView!
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
      var chosenCategory : String = ""
    var categoryPicker = UIPickerView()
   
     // var CategoryPicker = UIPickerView()
    
    var managedObjectContext: NSManagedObjectContext? {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    }
    
    var notesFetchedResultsController: NSFetchedResultsController<Note>!
    var notes = [Note]()
    var note: Note?
    var isExsisting = false
    var indexPath: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: date as Date)
        noteDateLabel.text = dateString
        noteNameLabel.layer.cornerRadius = 10
        checkLocationServices()
        pickerController.delegate = self
        
        
        categoryPicker.dataSource = self
              categoryPicker.delegate = self
              
             noteCategory.inputView = categoryPicker
        
        // Load data
        if let note = note {
            noteNameLabel.text = note.noteName
            noteDescriptionLabel.text = note.noteDescription
            noteCategory.text = note.noteCategory
            noteImageView.image = UIImage(data: note.noteImage! as Data)

        }
        
        if noteNameLabel.text != "" {
            isExsisting = true
        }
        
        // Delegates
        noteNameLabel.delegate = self
        noteDescriptionLabel.delegate = self
        noteCategory.delegate = self
        
        // Styles
        noteInfoView.layer.shadowOffset = CGSize(width: 0.75, height: 0.75)
        noteInfoView.layer.shadowRadius = 1.5
        noteInfoView.layer.shadowOpacity = 0.2
        noteInfoView.layer.cornerRadius = 2
        
        noteImageView.layer.cornerRadius = 2
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
       
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return category.count
       }
    
    
      func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          return category[row]
      }
      
   
      
      func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
          noteCategory.text = category[row]
          self.chosenCategory = category[row]
          self.noteCategory.resignFirstResponder()
      }
       
    

    // Core data
    func saveToCoreData(completion: @escaping ()->Void){
        managedObjectContext!.perform {
            do {
                try self.managedObjectContext?.save()
                completion()
                print("Note saved to CoreData.")
                
            }
            
            catch let error {
                print("Could not save note to CoreData: \(error.localizedDescription)")
                
            }
            
        }
        
    }
    
      var pickerController = UIImagePickerController()
    
    // Image Picker
    
    
    
    
    @IBAction func btn_AddSubject(_ sender: Any) {
        let alert = UIAlertController(title: "Add Category", message: "Add A New Category", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField?.text)")
            category.append(textField!.text!)
            UserDefaults.standard.set(category, forKey: "subjects")
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func pickImageButtonWasPressed(_ sender: Any) {
        
      
      
       // pickerController.allowsEditing = true
        
        let alertController = UIAlertController(title: "Add Image", message: "Choose", preferredStyle: .actionSheet)
       self.view.endEditing(true)
                         
                         let optionMenu = UIAlertController(title: nil, message: "Choose Image", preferredStyle: .actionSheet)
                         
                         let cameraAction = UIAlertAction(title: "Take Photo", style: .default, handler:
                         {
                             (alert: UIAlertAction!) -> Void in
                             
                             self.view.endEditing(true)
                             
                             if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
                             {
                                 if self.navigationController?.presentedViewController == self.pickerController
                                 {
                                 }
                                 else
                                 {
                                     self.pickerController.delegate = (self as UIImagePickerControllerDelegate & UINavigationControllerDelegate)
                                     self.pickerController.sourceType = UIImagePickerController.SourceType.camera
                                     self.pickerController.allowsEditing = true
                                     
                                     self.present(self.pickerController, animated: true, completion: nil)
                                 }
                             }
                             else
                             {
                                 let alert : UIAlertController = UIAlertController(title: "Alert Message", message:"Camera Not available", preferredStyle: UIAlertController.Style.alert)
                                 
                                 let validation : UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: { (action) -> Void in
                                     
                                     alert.dismiss(animated: true, completion: nil)
                                 })
                                 alert.addAction(validation)
                                 self.present(alert, animated: true, completion: nil)
                             }
                         })
                         
                         let libraryAction = UIAlertAction(title: "Choose From Library", style: .default, handler:
                         {
                             (alert: UIAlertAction!) -> Void in
                             
                             self.view.endEditing(true)
                             
                             if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum)
                             {
                                 self.pickerController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
                                 self.pickerController.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum;
                                 self.pickerController.allowsEditing = false
                                 
                                 self.present(self.pickerController, animated: true, completion: nil)
                             }
                         })
                         
                         let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
                         {
                             (alert: UIAlertAction!) -> Void in
                             self.view.endEditing(true)
                         })
                         optionMenu.addAction(libraryAction)
                         optionMenu.addAction(cameraAction)
                         optionMenu.addAction(cancelAction)
                         self.present(optionMenu, animated: true, completion: nil)
            
        }
     
        
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.noteImageView.image = image
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }

    
    @IBAction func saveButtonWasPressed(_ sender: UIBarButtonItem) {
        if noteNameLabel.text == "" || noteNameLabel.text == "NOTE NAME" || noteDescriptionLabel.text == "" || noteDescriptionLabel.text == "Note Description..." {
            
            let alertController = UIAlertController(title: "Incomplete Details", message:"Please complete the note", preferredStyle: UIAlertControllerStyle.alert)
            let OKAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil)
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        else {
            if (isExsisting == false) {
                let noteName = noteNameLabel.text
                let noteDescription = noteDescriptionLabel.text
                let noteCat = noteCategory.text
                
                let date = NSDate()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let dateString = dateFormatter.string(from: date as Date)
                noteDateLabel.text = dateString
               
                
                if let moc = managedObjectContext {
                    let note = Note(context: moc)

                    if let data = UIImageJPEGRepresentation(self.noteImageView.image!, 1.0) {
                        note.noteImage = data as NSData as Data
                    }
                
                    note.noteName = noteName
                    note.noteDescription = noteDescription
                    note.noteDate = dateString
                    note.noteCategory = noteCat
                    note.noteLat = (locationManager.location?.coordinate.latitude)!
                    note.noteLong = (locationManager.location?.coordinate.longitude)!
                    
                    saveToCoreData() {
                        
                        let isPresentingInAddFluidPatientMode = self.presentingViewController is UINavigationController
                        
                        if isPresentingInAddFluidPatientMode {
                            self.dismiss(animated: true, completion: nil)
                            
                        }
                        
                        else {
                            self.dismiss(animated: true) {
                                self.navigationController?.popViewController(animated: true)
                                self.dismiss(animated: true, completion: nil)
                            }
                            
                        }

                    }

                }
            
            }
            
            else if (isExsisting == true) {
                
                let note = self.note
                
                let managedObject = note
                managedObject!.setValue(noteNameLabel.text, forKey: "noteName")
                managedObject!.setValue(noteDescriptionLabel.text, forKey: "noteDescription")
                managedObject!.setValue(noteDateLabel.text, forKey: "noteDate")
                managedObject!.setValue(noteCategory.text, forKey: "noteCategory")
                             
                if let data = UIImageJPEGRepresentation(self.noteImageView.image!, 1.0) {
                    managedObject!.setValue(data, forKey: "noteImage")
                }
                
                do {
                    try context.save()
                    
                    let isPresentingInAddFluidPatientMode = self.presentingViewController is UINavigationController
                    
                    if isPresentingInAddFluidPatientMode {
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                        
                    else {
                        self.navigationController!.popViewController(animated: true)
                        
                    }

                }
                
                catch {
                    print("Failed to update existing note.")
                }
            }

        }

    }
    

    
    // Text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
            
        }
        
        return true
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.text == "Note Description...") {
            textView.text = ""
            
        }
        
    }
    
    
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(location, regionInMeters, regionInMeters)
            mapview.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorization()
        }
        else{
            
        }
    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus(){
        case .authorizedWhenInUse:
            mapview.showsUserLocation = true
            centerViewOnUserLocation()
            break
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            break
        case .authorizedAlways:
            break
        }
    }
    
    
}
extension noteViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        //yes
        
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //yes
    }
    
}
extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor(red: 245.0/255.0, green: 79.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }

}

