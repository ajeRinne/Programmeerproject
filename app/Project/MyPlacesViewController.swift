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

//    MARK: Constants
    let cellIdentifier: String = "cell"
    let placeTableRef = Database.database().reference(withPath: "placesTable")
    let userTableRef = Database.database().reference(withPath: "usersTable")
    
//    MARK: Variables
    var facebookID: String = ""
    var tableTag: Int = 0
    var addedByMeItems: [PlaceItem] = []
    var joiningEventsItems: [JoiningEventsItem] = []

//    MARK: Outlets
    @IBOutlet var addedByMeTableView: UITableView!
    @IBOutlet var placesIJoinTableView: UITableView!
    @IBOutlet var searchPlacesButton: UIBarButtonItem!
    @IBOutlet var signOutButton: UIBarButtonItem!
    @IBOutlet var mapButton: UIBarButtonItem!
    
//    MARK: Actions
    
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
    
//    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.facebookID = Facebook.sharedInstance.facebookID
        

        let userItemRef = userTableRef.child(self.facebookID)
        let joiningEventsRef = userItemRef.child("joinsEvents")
        joiningEventsRef.queryOrdered(byChild: "joinsEvents").observe(.value, with: { snapshot in

            var joiningEventsItemsNew: [JoiningEventsItem] = []
            for item in snapshot.children {

                let joiningEventsItem = JoiningEventsItem(snapshot: item as! DataSnapshot)
                joiningEventsItemsNew.append(joiningEventsItem)
            }
            
            self.joiningEventsItems = joiningEventsItemsNew
            self.placesIJoinTableView.reloadData()
        })
        
        
        
        
        placeTableRef.queryOrdered(byChild: "facebookID").queryEqual(toValue: facebookID).observe(.value, with:{
            snapshot in
            print("check214: \(snapshot)")
            var addedByMeItemsNew: [PlaceItem] = []
            for item in snapshot.children {
                
                print("check211: \(item)")
                let addedByMeItem = PlaceItem(snapshot: item as! DataSnapshot)
                addedByMeItemsNew.append(addedByMeItem)
            }
            self.addedByMeItems = addedByMeItemsNew
           self.addedByMeTableView.reloadData()
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            print("check207: \(addedByMeItems.count)")
            return addedByMeItems.count
        } else if tableView.tag == 2  {
            print("check208: \(joiningEventsItems.count)")
            return joiningEventsItems.count
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("check209")

        if tableView.tag == 1 {
            print("check28")

            let cell = tableView.dequeueReusableCell(withIdentifier: "addedByMeCell") as! AddedByMeCell
            let addedByMeItem = self.addedByMeItems[indexPath.row]
            let placeID = addedByMeItem.placeID
            let placeName = addedByMeItem.placeName
            cell.placeLabel.text = placeName
            
            DownloadPicture.sharedInstance.loadFirstPhotoForPlace(placeID: placeID, imageView: cell.placeImageView)


            return cell
            
            
        } else if tableView.tag == 2 {
            
            print("check29")
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "eventsIJoinCell") as! EventsIJoinCell
            print("check213")
            let joiningEventsItem = self.joiningEventsItems[indexPath.row]
            let placeID = joiningEventsItem.placeID
            print("check212: \(placeID)")
            placeTableRef.queryOrdered(byChild: "placeID").queryEqual(toValue: placeID).observe(.value, with: { snapshot in
                
                //            Iterate over items in snapshot
                self.placeTableRef.queryOrdered(byChild: "placeID").queryEqual(toValue: placeID).observe(.value, with: { snapshot in
                    print("check202: \(snapshot)")
                    for item in snapshot.children {
                        
                        print("check203: \(item)")
                        
                        //                Create database instance to get data per place
                        let placeItem = PlaceItem(snapshot: item as! DataSnapshot)
                        print("check204: \(placeItem)")
                        let placeName = placeItem.placeName
                        let placeID = placeItem.placeID
                        print("check205: \(placeID)")
                        let addedByUser = placeItem.facebookID
                        cell.placeLabel.text = placeName
                        cell.addedByLabel.text = addedByUser


                        DownloadPicture.sharedInstance.loadFirstPhotoForPlace(placeID: placeItem.placeID, imageView: cell.placeImageView)

                    }
                })
            })
            return cell
            
        } else {
            print("Doesn't enter a tagged cell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "joiningEventsCell") as! JoiningEventsCell
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (tableView.tag == 1) {
            print("check244:\(facebookID)")
            self.tableTag = 1
            self.performSegue(withIdentifier: "myPlacesToAddPlace", sender: nil)
        } else if (tableView.tag == 2) {
            print("check245:\(facebookID)")
            self.tableTag = 2
            self.performSegue(withIdentifier: "myPlacesToAddPlace", sender: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if tableView.tag == 1 {
                print("check217")
                let addedByMeItem = addedByMeItems[indexPath.row]
                userTableRef.observe(.value, with: { (snapshot) in
                    for item in snapshot.children {
                        print("check219: \(item)")
                        let addedByMeItem = self.addedByMeItems[indexPath.row]
//                        let placeID = addedByMeItem.placeID
                        print("check233")
                        let userItem = UserItem(snapshot: item as! DataSnapshot)
                        print("check244")
                        let facebookID = userItem.facebookID
                        let userItemRef = self.userTableRef.child(facebookID)
                        let joiningEventsRef = userItemRef.child("joinsEvents").child(addedByMeItem.placeID)
                        print("check255: \(joiningEventsRef)")
                        let placeID = joiningEventsRef.queryOrdered(byChild: "joinsEvents").queryEqual(toValue: addedByMeItem.placeID)
                        placeID.ref.removeValue()
                    }
                    print("check277: \(addedByMeItem.placeID)")
                    let placeItem = self.placeTableRef.child(addedByMeItem.placeID)
                    print("check271: \(placeItem)")
                    let placeItemID =  placeItem.queryOrdered(byChild: "placeID").queryEqual(toValue: addedByMeItem.placeID)
                    placeItemID.ref.removeValue()
                self.addedByMeTableView.reloadData()
                
                })
                
                addedByMeTableView.reloadData()

        
            } else if tableView.tag == 2  {
                print("check218")
                let joiningEventsItem = joiningEventsItems[indexPath.row]
                let currentPlaceID = joiningEventsItem.placeID
                print("check219: \(joiningEventsItem)")
                let userItemRef = userTableRef.child(facebookID)
                let joiningEventRef = userItemRef.child("joinsEvents").child(currentPlaceID)
                print(joiningEventRef)
                let place = joiningEventRef.queryOrdered(byChild: "joinsEvents").queryEqual(toValue: currentPlaceID)
                place.ref.removeValue()
                
                let joiningUserItem = placeTableRef.child(joiningEventsItem.placeID).child("joiningUsers").child(facebookID)
                print("check220: \(joiningUserItem)")
//                joiningEventsItem.ref?.remove(at: indexPath.row)
                joiningUserItem.ref.removeValue()
                self.placesIJoinTableView.reloadData()
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("check22: \(self.facebookID)")
        
        
        
        if (segue.identifier == "myPlacesToMap") {
            print("check23")
            let viewController = segue.destination as! MapViewController
            viewController.facebookID = self.facebookID
        } else if (segue.identifier == "myPlacesToAddPlace") {
            print("check24")
            let viewController = segue.destination as! AddPlaceViewController
            viewController.facebookID = self.facebookID
            
            if (self.tableTag == 1) {
                print("check231")
                let indexPath = addedByMeTableView.indexPathForSelectedRow
                print(indexPath)
                //            Get place item at selected row
                if indexPath != nil {
                    let placeItem = addedByMeItems[indexPath!.row]
                    print("check232: \(placeItem)")
                    let placeID = placeItem.placeID
                    
                    //                send current place to next view
                    viewController.placeID = placeID
                }
                
            } else if (self.tableTag == 2) {
                print("check241")
                let indexPath = placesIJoinTableView.indexPathForSelectedRow
                print(indexPath)
                //            Get place item at selected row
                if indexPath != nil {
                    let placeItem = joiningEventsItems[indexPath!.row]
                    print("check242: \(placeItem)")
                    let placeID = placeItem.placeID
                    
                    viewController.placeID = placeID
                }
                
            } else if (self.tableTag == 0) {
                print("async probs")
            }
            viewController.alreadyJoined = true
            
        } else if(segue.identifier == "myPlacesToPlaces") {
            print("check25")
            let viewController = segue.destination as! PlacesTableViewController
            viewController.facebookID = self.facebookID
        }
        
    }
    
}

