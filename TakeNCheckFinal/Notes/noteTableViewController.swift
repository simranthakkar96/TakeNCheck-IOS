//
//  noteTableViewController.swift
//  Notes
//
//  Created by Farzaad on 6/11/19.
//  Copyright © 2019 Apple Developer. All rights reserved.
//

import UIKit
import CoreData

class noteTableViewController: UITableViewController,UISearchBarDelegate,UISearchDisplayDelegate {
    @IBOutlet weak var btnfilter: UIBarButtonItem!
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    @IBOutlet weak var cellview: noteTableViewCell!
    @IBOutlet var tview: UITableView!
    var notes:[Note] = []
    var boolsort = true
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
  //  let sliderHandler = SooninSlideInHandler()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchbar.delegate = self
        self.retrieveNotes()
       
    }
    
   
    

     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(true)
         retrieveNotes()
     }
     
     override func didReceiveMemoryWarning() {
         super.didReceiveMemoryWarning()
         
     }
     

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return notes.count
       }

       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "noteTableViewCell", for: indexPath) as! noteTableViewCell

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
       
      
    func retrieveNotes() {
      let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
      
      do{
          notes = try context.fetch(Note.fetchRequest())
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
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
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText:String)
       {
           if searchText != ""
           {
               var predicate: NSPredicate = NSPredicate()
               predicate = NSPredicate(format: "noteName contains[c] '\(searchText)'")
       
               let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
               let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
               fetchRequest.predicate = predicate
               
               do
               {
                   notes = try context.fetch(fetchRequest) as! [NSManagedObject] as! [Note]
               }
               catch{
                   print(error)
               }
           }
           else{
            viewDidLoad()
        }
           tableView.reloadData()
       }
    @IBAction func addNote(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "add") as! noteViewController
        self.present(vc,animated: true)
    }
    
    
    @IBAction func btnAddCat(_ sender: UIBarButtonItem) {
        
       let vc = storyboard?.instantiateViewController(withIdentifier: "MenuVC") as! MenuViewController
       self.present(vc,animated: true)
    }
    
    
    @IBAction func filterButton(_ sender: Any)
    {
        if boolsort == true{
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
            let sort = NSSortDescriptor(key: #keyPath(Note.noteName), ascending: true)
            fetchRequest.sortDescriptors = [sort]
            
            do{
                notes = try context.fetch(fetchRequest)
                
            }catch{
                print(error)
            }
            boolsort = false
            if #available(iOS 13.0, *) {
                btnfilter.image = UIImage(systemName: "calendar")
            } 
            tableView.reloadData()
        }
        else if boolsort == false{
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
            let sort = NSSortDescriptor(key: #keyPath(Note.noteDate), ascending: false)
            fetchRequest.sortDescriptors = [sort]
            
            do{
                notes = try context.fetch(fetchRequest)
                
            }catch{
                print(error)
            }
            boolsort = true
            if #available(iOS 13.0, *) {
                           btnfilter.image = UIImage(systemName: "folder")
                       }
            tableView.reloadData()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let noteDetailsViewController = segue.destination as! noteViewController
                let selectedNote: Note = notes[indexPath.row]
                
                noteDetailsViewController.indexPath = indexPath.row
                noteDetailsViewController.isExsisting = false
                noteDetailsViewController.note = selectedNote
                
            }
            
        }
            
        else if segue.identifier == "addItem" {
            print("User added a new note.")
            
        }

    }

}
