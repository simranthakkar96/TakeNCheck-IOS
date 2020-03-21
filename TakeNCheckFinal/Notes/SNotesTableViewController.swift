//
//  SNotesTableViewController.swift
//  Notes
//
//  Created by Nayna on 11/19/19.
//  Copyright © 2019 Apple Developer. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class SNotesTableViewController: UITableViewController {
   
    
    var ss = ""
    var notes:[Note] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.retrieveNotes()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
    func retrieveNotes() {
      let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
      
      do{
          notes = try context.fetch(Note.fetchRequest())
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "noteCategory == %@", ss)
            let sort = NSSortDescriptor(key: #keyPath(Note.noteDate), ascending: false)
            fetchRequest.sortDescriptors = [sort]
            
            do{
                notes = try context.fetch(fetchRequest)
            }catch{
                print(error)
            }
        tableView.reloadData()
      }catch{
          print(error)
      }
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 200 //or whatever you need
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        retrieveNotes()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return notes.count
       }

       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "SNotesCell", for: indexPath) as! SNotesTableViewCell

           let note: Note = notes[indexPath.row]
           cell.configureCell(note: note)
           cell.backgroundColor = UIColor.clear
           
           return cell
       }

       
       override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
           
           if editingStyle == .delete {
               let city = notes[indexPath.row]
                          context.delete(city)
                          (UIApplication.shared.delegate as! AppDelegate).saveContext()
                          
                          do
                          {
                              notes = try context.fetch(Note.fetchRequest())
                          }
                          catch
                          {
                              print(error)
                          }
           }
           
           tableView.reloadData()
           
       }
       
      

}
