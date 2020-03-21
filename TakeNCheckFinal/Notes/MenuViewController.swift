//
//  MenuViewController.swift
//  Notes
//
//  Created by Farzaad on 11/13/19.
//  Copyright © 2019 Apple Developer. All rights reserved.
//

import UIKit
import CoreData
class MenuViewController: UIViewController {

    @IBOutlet weak var menuview: UIView!
    var i = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        category = UserDefaults.standard.stringArray(forKey: "subjects") ?? category
           // self.view.backgroundColor = UIColor(patternImage: UIImage(named: "splashscreen1.png")!)
        self.menuview.frame = CGRect(x: 0 - self.menuview.bounds.width, y: self.menuview.frame.origin.y, width:self.menuview.bounds.width, height: self.menuview.bounds.height)
        // Do any additional setup after loading the view.
    }
    @IBAction func btn_menu(_ sender: Any) {
        print("hello")
        if(i==0)
               {
                   UIView.animate(withDuration: 0.4, animations:{
                       self.menuview.frame = CGRect(x: self.menuview.frame.origin.x + self.menuview.bounds.width, y: self.menuview.frame.origin.y, width:self.menuview.bounds.width, height: self.menuview.bounds.height)
                   
                       
                   })
                   i=1
               }
               else{
                   UIView.animate(withDuration: 0.4, animations:{
                       self.menuview.frame = CGRect(x: self.menuview.frame.origin.x - self.menuview.bounds.width, y: self.menuview.frame.origin.y, width:self.menuview.bounds.width, height: self.menuview.bounds.height)
                       
                   
                   })
                   i=0
                   print(self.menuview .frame.origin.x)
               }

    }
    

    

}
