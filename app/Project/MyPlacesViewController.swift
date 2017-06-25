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

    let cellIdentifier : String = "cell"
    let placeTableRef = Database.database().reference(withPath: "placesTable")
    let userTableRef = Database.database().reference(withPath: "usersTable")
    
    var facebookID : String = ""
    var addedByMeItems: [PlaceItem] = []
    var joiningEventsItems: [JoiningEventsItem] = []

    @IBOutlet var addedByMeTableView: UITableView!
    @IBOutlet var placesIJoinTableView: UITableView!
    @IBOutlet var searchPlacesButton: UIBarButtonItem!
    @IBOutlet var signOutButton: UIBarButtonItem!
    @IBOutlet var mapButton: UIBarButtonItem!
    
    @IBAction func signOutButtonTouched(_ sender: Any) {
        do {
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            dismiss(animated: true, completion: nil)
            
        } catch {
            print("Could not sign out: \(error)")
        }
    }

    
    @IBAction func searchPlacesButtonTouched(_ sender: Any) {

        print("check21: \(facebookID)")
        performSegue(withIdentifier: "myPlacesToPlaces", sender:nil)
    }
    
    
    @IBAction func mapButtonTouched(_ sender: Any) {
        performSegue(withIdentifier: "myPlacesToMap", sender:nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("check22: \(self.facebookID)")
        

        
        if (segue.identifier == "myPlacesToMap") {
            print("check23")
            let viewController = segue.destination as! MapViewController
            viewController.facebookID = self.facebookID
        }
        
        
        if (segue.identifier == "myPlacesToAddPlace") {
            print("check24")
            let viewController = segue.destination as! AddPlaceViewController
            viewController.facebookID = self.facebookID
            viewController.alreadyJoined = true
        }
        
        if (segue.identifier == "myPlacesToPlaces") {
            print("check25")
            let viewController = segue.destination as! PlacesTableViewController
            viewController.facebookID = self.facebookID
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addedByMeTableView.delegate = self
        placesIJoinTableView.delegate = self
        addedByMeTableView.dataSource = self
        placesIJoinTableView.dataSource = self

        
        if (FBSDKAccessToken.current() != nil) {
            let params = ["fields" : "id, name"]
            let graphRequest = GraphRequest(graphPath: "me", parameters: params)
            graphRequest.start {
                (urlResponse, requestResult) in
                
                switch requestResult {
                case .failed(let error):
                    print("error in graph request:", error)
                    return
                case .success(let graphResponse):
                    if let responseDictionary = graphResponse.dictionaryValue {
                        print(responseDictionary)
                        self.facebookID = (responseDictionary["id"]!) as! String
                        print("check223:\(self.facebookID)")
                    }
                }
            }
            print("user signed in")
        } else {
            print("no user signed in")
        }
        
        
        print("check205: \(facebookID)")
        let userItemRef = userTableRef.child(facebookID)
        let joiningEventsRef = userItemRef.child("joinsEvents")
        joiningEventsRef.queryOrdered(byChild: "joinsEvents").observe(.value, with: { snapshot in
            print("check215: \(snapshot)")
            var joiningEventsItemsNew: [JoiningEventsItem] = []
            for item in snapshot.children {
                print("check204: \(item)")
                let joiningEventsItem = JoiningEventsItem(snapshot: item as! DataSnapshot)
                joiningEventsItemsNew.append(joiningEventsItem)
            }
            
            self.joiningEventsItems = joiningEventsItemsNew
            print("check206: \(joiningEventsItemsNew)")
            print("check205: \(self.joiningEventsItems)")
            print(self.joiningEventsItems.count)
            self.placesIJoinTableView.reloadData()
        })
        
        placeTableRef.queryOrdered(byChild: facebookID).queryEqual(toValue: facebookID).observe(.value, with:{
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
        
//        var cell = tableView.dequeueReusableCell(withIdentifier: "joiningUsersCell") as! JoiningUsersCell
        var cell: UITableViewCell
        if tableView.tag == 1 {
            print("check28")

            cell = tableView.dequeueReusableCell(withIdentifier: "addedByMeCell") as! AddedByMeCell
            let addedByMeItem = self.addedByMeItems[indexPath.row]
            let placeID = addedByMeItem.placeID
            let placeName = addedByMeItem.placeName
//            cell.placeLabel.text = placeName
            
            func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
                GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
                    (photo, error) -> Void in
                    if let error = error {
                        // TODO: handle the error.
                        print("Error: \(error.localizedDescription)")
                    } else {
                        print("check47")
                        print(photo)
//                        cell.placeImageView.image = photo;
                        
                    }
                })
            }
            
            func loadFirstPhotoForPlace(placeID: String) {
                GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
                    if let error = error {
                        // TODO: handle the error.
                        print("Error: \(error.localizedDescription)")
                    } else {
                        print("check48")
                        print(placeID)
                        if let firstPhoto = photos?.results.first {
                            print("check49")
                            loadImageForMetadata(photoMetadata: firstPhoto)
                        }
                    }
                }
            }
            
            loadFirstPhotoForPlace(placeID: placeID)

            return cell
            
            
        } else if tableView.tag == 2 {
            
            print("check29")
            
            cell = tableView.dequeueReusableCell(withIdentifier: "eventsIJoinCell") as! UITableViewCell
            print("check213")
            let joiningEventsItem = self.joiningEventsItems[indexPath.row]
            let placeID = joiningEventsItem.placeID
            print("check212: \(placeID)")
            placeTableRef.queryOrdered(byChild: "placeID").queryEqual(toValue: placeID).observe(.value, with: { snapshot in
                
                //            Iterate over items in snapshot
                self.placeTableRef.queryOrdered(byChild: "placeID").queryEqual(toValue: placeID).observe(.value, with: { snapshot in
                    
                    for item in snapshot.children {
                        
                        print("check203: \(item)")
                        
                        //                Create database instance to get data per place
                        let placeItem = PlaceItem(snapshot: item as! DataSnapshot)
                        let placeName = placeItem.placeName
                        let placeID = placeItem.placeID
                        let addedByUser = placeItem.facebookID
//                        cell.placeLabel = placeName
//                        cell.addedByLabel = addedByUser

                        func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
                            GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
                                (photo, error) -> Void in
                                if let error = error {
                                    // TODO: handle the error.
                                    print("Error: \(error.localizedDescription)")
                                } else {
                                    print("check47")
                                    print(photo)
//                                    cell.placeImageView.image = photo;
                                    
                                }
                            })
                        }
                        
                        func loadFirstPhotoForPlace(placeID: String) {
                            GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
                                if let error = error {
                                    // TODO: handle the error.
                                    print("Error: \(error.localizedDescription)")
                                } else {
                                    print("check48")
                                    print(placeID)
                                    if let firstPhoto = photos?.results.first {
                                        print("check49")
                                        loadImageForMetadata(photoMetadata: firstPhoto)
                                    }
                                }
                            }
                        }
                        
                        loadFirstPhotoForPlace(placeID: placeItem.placeID)

                    }
                })
            })
            return cell
        } else {
            print("Doesn't enter a tagged cell")
            cell = tableView.dequeueReusableCell(withIdentifier: "joiningEventsCell") as! JoiningEventsCell
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("check20:\(facebookID)")
        self.performSegue(withIdentifier: "myPlacesToAddPlace", sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if tableView.tag == 1 {
                print("check207")
                let addedByMeItem = addedByMeItems[indexPath.row]
//                addedByMeItem.ref?.removeValue()

            } else if tableView.tag == 2  {
                print("check208")

            }
        }
    }
    
}

