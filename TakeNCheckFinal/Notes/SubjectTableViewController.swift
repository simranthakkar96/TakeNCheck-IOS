//
//  SubjectTableViewController.swift
//  Notes
//
//  Created by Nayna on 11/19/19.
//  Copyright © 2019 Apple Developer. All rights reserved.
//

import UIKit
import CoreData


class SubjectTableViewController: UITableViewController {

    
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
   
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }


       override func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }
       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return category.count
       }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
       {
           return 100 //or whatever you need
       }
       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectTableViewCell", for: indexPath) as! SubjectTableViewCell

       //  let subject = category[indexPath.row]
         
        cell.subject?.text = category[indexPath.row]
           return cell
       }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            category.remove(at:indexPath.row)
        }
        tableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "subjectNotes" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let SNoteController = segue.destination as! SNotesTableViewController
                let selectedNote = category[indexPath.row]
                
                SNoteController.ss = selectedNote
                
            }
            
        }
            
        else if segue.identifier == "addItem" {
            print("User added a new note.")
            
        }

    }
/*
       override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
           
           if editingStyle == .delete {
               let city = category[indexPath.row]
                          context.delete(city)
                          (UIApplication.shared.delegate as! AppDelegate).saveContext()
                        
           }
           
           tableView.reloadData()
           
       }
*/
  

}
