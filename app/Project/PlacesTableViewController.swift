//
//  PlacesTableViewController.swift
//  Project
//
//  Created by Alexander Rinne on 08-06-17.
//  Copyright © 2017 Alexander Rinne. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FacebookCore
import GooglePlaces

class PlacesTableViewController: UITableViewController {
    
    var facebookID: String = ""
    var placeID: String = ""
    var placeName: String = ""
    
    let placeTableRef = Database.database().reference(withPath: "placesTable")
    let userTableRef = Database.database().reference(withPath: "usersTable")
    
    var items: [PlaceItem] = []
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("check31")

        if (segue.identifier == "placesToAddplace") {
            let viewController = segue.destination as! AddPlaceViewController
            print("check30")
            print(facebookID)
            print(placeID)
            print(placeName)
            viewController.facebookID = facebookID
            viewController.placeID = placeID
            viewController.placeName = placeName
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                        print("check10:\(self.facebookID)")
                    }
                }
            }
        }
        
        print("check24: \(self.facebookID)")
        //        Authenticate user and check for changes in login status
        
        if (FBSDKAccessToken.current() != nil)
        {
            print("user signed in")
        }else {
            print("no user signed in")
        }

        
        //        Get places table
        placeTableRef.observe(.value, with: { snapshot in
            print(snapshot.value!)
        })
        
        //          Guery database by places
        placeTableRef.queryOrdered(byChild: "placeName").observe(.value, with: { snapshot in
            
            //            Create temporary array to store data
            var newItems: [PlaceItem] = []
            print("check25:\(newItems)")
            
            //            Iterate over items in snapshot
            for item in snapshot.children {
                
                //                Create database instance to get data per place
                let placeItem = PlaceItem(snapshot: item as! DataSnapshot)
                
                //                Append data of single place to array
                newItems.append(placeItem)
                print("check26: \(placeItem.placeName)")
            }
            
            //            Copy temporary array in array
            self.items = newItems
            
            //            Reload data in order se up to date view
            self.tableView.reloadData()
        })
      }

    
    // MARK: - Table view data source
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        self.tableView.registerClass.reuseIdentifier: "placesCell"
//        
//        :(UITableViewCell class) forCellReuseIdentifier:@"PlacesCell"
        //        Create cell reference
        let cell = tableView.dequeueReusableCell(withIdentifier: "placesCell", for: indexPath) as! PlacesCell
        
        
        //        Get place data from array
        let placeItem = self.items[indexPath.row]
        
        func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
            GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
                (photo, error) -> Void in
                if let error = error {
                    // TODO: handle the error.
                    print("Error: \(error.localizedDescription)")
                } else {
                    print("check17")
                    print(photo)
                    cell.placePictureView.image = photo;
                    
                }
            })
        }
        
        func loadFirstPhotoForPlace(placeID: String) {
            GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
                if let error = error {
                    // TODO: handle the error.
                    print("Error: \(error.localizedDescription)")
                } else {
                    print("check18")
                    print(placeID)
                    if let firstPhoto = photos?.results.first {
                        print("check19")
                        loadImageForMetadata(photoMetadata: firstPhoto)
                    }
                }
            }
        }

        
        //        Show place data in cell labels
        cell.placeTextField.text = placeItem.placeName
        
        loadFirstPhotoForPlace(placeID: placeItem.placeID)
        
        let facebookID = placeItem.facebookID
        
        userTableRef.queryOrdered(byChild: "facebookID").queryEqual(toValue: facebookID).observe(.value, with: { snapshot in

              print(snapshot.value!)
            print("check27")
            for item in snapshot.children {
                
                //                Create database instance to get data per place
                let userItem = UserItem(snapshot: item as! DataSnapshot)
                print("check28: \(userItem)")
                let name = userItem.name
                cell.addedByTextField.text = name
                
            }
        })
        
        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("check33")
        print(indexPath.row)
        let placeItem = items[indexPath.row]
        let placeItemID = placeItem.placeID
        let placeItemName = placeItem.placeName
        self.placeName = placeItemName
        self.placeID = placeItemID

        print(placeItemID)
        print(placeItemName)
        print(self.facebookID)
        print(self.placeID)
        
        self.performSegue(withIdentifier:
            "placesToAddPlace", sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }


    
}
