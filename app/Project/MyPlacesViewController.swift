//
//  MyPlacesViewController.swift
//  Project
//
//  Created by Alexander Rinne on 08-06-17.
//  Copyright © 2017 Alexander Rinne. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GooglePlaces
// api key: AIzaSyDCedmeFG_2z2W3u2sohX13judBZ90Y_xI

class MyPlacesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    
    let cellIdentifier : String = "cell"
    var facebookID : String = ""
    
//    MARK: - Maps Search bar
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?


    @IBOutlet var addedByMeTableView: UITableView!
    
    @IBOutlet var placesIJoinTableView: UITableView!
    
    @IBOutlet var searchPlacesButton: UIBarButtonItem!
    
    @IBOutlet var signOutButton: UIBarButtonItem!
    
    @IBOutlet var mapButton: UIBarButtonItem!
    
    @IBAction func signOutButtonTouched(_ sender: Any) {
        do {
            //            Authenticate user and log out
//            try Auth.auth().signOut()
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            dismiss(animated: true, completion: nil)
            
        } catch {
            print("Could not sign out: \(error)")
        }
//

//        dismiss(animated: true, completion: nil)
    }

    
    @IBAction func searchPlacesButtonTouched(_ sender: Any) {
        print("IT DOES WORK!!!!!!!!!!!")
        print("check17: \(facebookID)")
        performSegue(withIdentifier: "myPlacesToPlaces", sender:nil)
    }
    
    
    @IBAction func autocompleteClicked(_ sender: UISearchController) {
        print("AutocompleteClicked")
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self as! GMSAutocompleteViewControllerDelegate
//        button.addTarget(self, action: "btn_move2_touchupinside:forEvent:", forControlEvents: .TouchUpInside)
        present(autocompleteController, animated: true, completion: nil)
    }
    
    
    @IBAction func mapButtonTouched(_ sender: Any) {
        performSegue(withIdentifier: "myPlacesToMap", sender:nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("check26: \(self.facebookID)")
        

        
        if (segue.identifier == "myPlacesToMap") {
            print("check40")
            let viewController = segue.destination as! MapViewController
            viewController.facebookID = self.facebookID
        }
        
        
        if (segue.identifier == "myPlacesToAddPlace") {
            print("check42")
            let viewController = segue.destination as! AddPlaceViewController
            viewController.facebookID = self.facebookID
        }
        
        if (segue.identifier == "myPlacesToPlaces") {
            print("check41")
            let viewController = segue.destination as! PlacesTableViewController
            viewController.facebookID = self.facebookID
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if (FBSDKAccessToken.current() != nil)
        {
            print("user signed in")
        }else {
            print("no user signed in")
        }

        
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        print("check14: \(credential)")
        print(facebookID)
        
//        addedByMeTableView.dataSource = self
//        addedByMeTableView.delegate = self
//        placesIJoinTableView.dataSource = self
//        placesIJoinTableView.delegate = self
//        let user = Auth.auth().currentUser
//        if (FBSDKAccessToken.current() != nil)
//        {
//            print("check3")
//            print(FBSDKAccessToken.current().userID)
//        }

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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("check15:\(facebookID)")
        self.performSegue(withIdentifier: "myPlacesToAddPlace", sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
//            Add delete option for items
//            items.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
        
    
}

