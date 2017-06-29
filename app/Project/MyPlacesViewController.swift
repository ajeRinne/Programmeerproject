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
import FacebookLogin
import FacebookCore
import GooglePlaces


class MyPlacesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

//    MARK: - Constants
    
    let cellIdentifier: String = "cell"
    let placeTableRef = Database.database().reference(withPath: "placesTable")
    let userTableRef = Database.database().reference(withPath: "usersTable")
    
//    MARK: - Variables
    
    var facebookID: String = ""
    var tableTag: Int = 0
    var addedByMeItems: [PlaceItem] = []
    var joiningEventsItems: [JoiningEventsItem] = []

//    MARK: - Outlets
    
    @IBOutlet var addedByMeTableView: UITableView!
    @IBOutlet var placesIJoinTableView: UITableView!
    @IBOutlet var searchPlacesButton: UIBarButtonItem!
    @IBOutlet var signOutButton: UIBarButtonItem!
    @IBOutlet var mapButton: UIBarButtonItem!
    
//    MARK: - Actions
    
//    sign out button handler
    @IBAction func signOutButtonTouched(_ sender: Any) {
        do {
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            dismiss(animated: true, completion: nil)
            
        } catch {
            print("Could not sign out: \(error)")
        }
    }

//  perform segue to map placesTableView searchButton is touched
    @IBAction func searchPlacesButtonTouched(_ sender: Any) {

        performSegue(withIdentifier: "myPlacesToPlaces", sender:nil)
    }
    
//    perform segue to map when mapButton is touched
    @IBAction func mapButtonTouched(_ sender: Any) {
        performSegue(withIdentifier: "myPlacesToMap", sender:nil)
    }
    
    
//    MARK: - ViewController
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        authenticate user
        self.facebookID = Facebook.sharedInstance.facebookID
        
//        create reference to events that user attends
        let userItemRef = userTableRef.child(self.facebookID)
        let joiningEventsRef = userItemRef.child("joinsEvents")
        
//        look up events that user attends
        joiningEventsRef.queryOrdered(byChild: "joinsEvents").observe(.value, with: { snapshot in

            var joiningEventsItemsNew: [JoiningEventsItem] = []
            
            for item in snapshot.children {

                let joiningEventsItem = JoiningEventsItem(snapshot: item as! DataSnapshot)
                joiningEventsItemsNew.append(joiningEventsItem)
            }
            
//            set data in user in global array to load in tableView
            self.joiningEventsItems = joiningEventsItemsNew
            
//            update table view with new data
            self.placesIJoinTableView.reloadData()
        })
        
//        look up events that user has added
        placeTableRef.queryOrdered(byChild: "facebookID").queryEqual(toValue: facebookID).observe(.value, with:{
            snapshot in
            
            var addedByMeItemsNew: [PlaceItem] = []
            
            for item in snapshot.children {
                
                print("check211: \(item)")
                let addedByMeItem = PlaceItem(snapshot: item as! DataSnapshot)
                addedByMeItemsNew.append(addedByMeItem)
            }
            
//            set data in user in global array to load in tableView
            self.addedByMeItems = addedByMeItemsNew
            
            
//            update table view with new data
           self.addedByMeTableView.reloadData()
        })
        
    }

    // MARK: - Table view data source
    
//    create valid number of rows per table using tableTag
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 1 {
            
            return addedByMeItems.count
            
        } else if tableView.tag == 2  {
            
            return joiningEventsItems.count
        }
        return 0
    }
    
//    create one section in tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
//    set individual cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        check which table view
        if tableView.tag == 1 {
            
//            user cell for tag 1
            let cell = tableView.dequeueReusableCell(withIdentifier: "addedByMeCell") as! AddedByMeCell
//            get right object out of events array
            let addedByMeItem = self.addedByMeItems[indexPath.row]
            
//            save variables out of object in local variables
            let placeID = addedByMeItem.placeID
            let placeName = addedByMeItem.placeName
            cell.placeLabel.text = placeName
            
//            download place picture
            DownloadPicture.sharedInstance.loadFirstPhotoForPlace(placeID: placeID, imageView: cell.placeImageView)

            return cell
            

        } else {
 
//            use cel for tag 2
            let cell = tableView.dequeueReusableCell(withIdentifier: "eventsIJoinCell") as! EventsIJoinCell

//            get placeID out of events array
            let joiningEventsItem = self.joiningEventsItems[indexPath.row]
            let placeID = joiningEventsItem.placeID

//            query database for specific placeID
            placeTableRef.queryOrdered(byChild: "placeID").queryEqual(toValue: placeID).observe(.value, with: { snapshot in
                
                self.placeTableRef.child(placeID).observe(.value, with: { snapshot in
                    
//                        Create database instance to get data per place
                    let placeItem = PlaceItem(snapshot: snapshot as! DataSnapshot)
                    
//                    save variables out of object in local variables
                    cell.placeLabel.text = placeItem.placeName
                    
//                    laod place picute in image view
                    let placeID = placeItem.placeID
                    DownloadPicture.sharedInstance.loadFirstPhotoForPlace(placeID: placeItem.placeID, imageView: cell.placeImageView)
                    
//                    get facebookID of user that added the place
                    let currentFacebookID = placeItem.facebookID
                    
//                    query database for username
                    self.userTableRef.queryOrdered(byChild: "facebookID").queryEqual(toValue: currentFacebookID).observe(.value, with: { snapshot in
                        
                        for item in snapshot.children {
                            
                            let userItem = UserItem(snapshot: item as! DataSnapshot)
                            let name = userItem.name
                            cell.addedByLabel.text = name
                        }
                    })
                })
            })
            
            return cell
        }
        
    }
    
//    allow editing on row
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
//    instantiate segues for click on table row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (tableView.tag == 1) {

            self.tableTag = 1
            self.performSegue(withIdentifier: "myPlacesToAddPlace", sender: nil)
            
        } else {

            self.tableTag = 2
            self.performSegue(withIdentifier: "myPlacesToAddPlace", sender: nil)
        }
        
    }
    
//    instantiate delete option on rows
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if tableView.tag == 1 {

//                remove references from users that have joined the event
                let addedByMeItem = addedByMeItems[indexPath.row]
                userTableRef.observe(.value, with: { (snapshot) in
                    
//                    query database users that have joined the event
                    for item in snapshot.children {

                        let addedByMeItem = self.addedByMeItems[indexPath.row]

                        let userItem = UserItem(snapshot: item as! DataSnapshot)

                        let facebookID = userItem.facebookID
                        let userItemRef = self.userTableRef.child(facebookID)
                        let joiningEventsRef = userItemRef.child("joinsEvents").child(addedByMeItem.placeID)

                        let placeID = joiningEventsRef.queryOrdered(byChild: "joinsEvents").queryEqual(toValue: addedByMeItem.placeID)
                        placeID.ref.removeValue()
                    }
                    
//                    remove reference to place
                    let placeItem = self.placeTableRef.child(addedByMeItem.placeID)
                    let placeItemID =  placeItem.queryOrdered(byChild: "placeID").queryEqual(toValue: addedByMeItem.placeID)
                    
                    placeItemID.ref.removeValue()
                    
//                    reload table view
                self.addedByMeTableView.reloadData()
                
                })
        
            } else {

//               remove reference to event that user joins
//               query database for joinsEvent of user
                let joiningEventsItem = joiningEventsItems[indexPath.row]
                let currentPlaceID = joiningEventsItem.placeID
                let userItemRef = userTableRef.child(facebookID)
                let joiningEventRef = userItemRef.child("joinsEvents").child(currentPlaceID)
                let place = joiningEventRef.queryOrdered(byChild: "joinsEvents").queryEqual(toValue: currentPlaceID)
                
//                remove joinsEvent
                place.ref.removeValue()
                
//                query database joining user with facebookID of user
                let joiningUserItem = placeTableRef.child(joiningEventsItem.placeID).child("joiningUsers").child(facebookID)

//                remove joiningUser
                joiningUserItem.ref.removeValue()
                self.placesIJoinTableView.reloadData()
            }
        }
    }
    
//    MARK: - Segue
    
//    prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "myPlacesToAddPlace") {

            let viewController = segue.destination as! AddPlaceViewController
            viewController.facebookID = self.facebookID
            
            if (self.tableTag == 1) {

//                get placeID for table 1
                let indexPath = addedByMeTableView.indexPathForSelectedRow
                let placeItem = addedByMeItems[indexPath!.row]
                let placeID = placeItem.placeID
                    
//                send current place to next view
                viewController.placeID = placeID
                
            } else {

//                get placeID for table 2
                let indexPath = placesIJoinTableView.indexPathForSelectedRow
                let placeItem = joiningEventsItems[indexPath!.row]
                let placeID = placeItem.placeID
                
//                send current place t onext view
                viewController.placeID = placeID
            }
            
//            set variable so event cannot be added to list again
            viewController.alreadyJoined = true
        }
    }
}

