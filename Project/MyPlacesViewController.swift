//
//  MyPlacesViewController.swift
//  Project
//
//  Created by Alexander Rinne on 08-06-17.
//  Copyright © 2017 Alexander Rinne. All rights reserved.
//

import UIKit
import Firebase

class MyPlacesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellIdentifier : String = "cell"

    @IBOutlet var addBarbutton: UIBarButtonItem!

    @IBOutlet var addedByMeTableView: UITableView!
    
    @IBOutlet var placesIJoinTableView: UITableView!
    
    @IBOutlet var searchPlacesButton: UIBarButtonItem!
    
    @IBOutlet var signOutButton: UIBarButtonItem!
    
    @IBOutlet var signOutButtonTouched: UIBarButtonItem!
    
    @IBAction func searchPlacesButtonTouched(_ sender: Any) {
        performSegue(withIdentifier: "myPlacesToPlaces", sender:nil)
        
    }
    
    @IBAction func addBarButtonTouched(_ sender: Any) {
        performSegue(withIdentifier: "myPlacesToCreatePlace", sender:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addedByMeTableView.dataSource = self
        addedByMeTableView.delegate = self
        placesIJoinTableView.dataSource = self
        placesIJoinTableView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 || tableView.tag == 2 {
            return 1
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as! UITableViewCell
        if tableView.tag == 1 {
            print("check1")
//            cell.placeLabel?.text = "place works"
        } else if tableView.tag == 2 {
            print("check2")
//            cell.placeLabel?.text = "place works"
//            cell.addedByLabel?.text = "addedBy works"
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.performSegue(withIdentifier: "myPlacesToAddPlace", sender: nil)
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        if self.tableView.tag == 1{
//            self.tableView.reloadData()
//        } else {
//            self.tableView.reloadData()
//        }
//    }


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
