//
//  AddPlaceViewController.swift
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

class AddPlaceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let placeTableRef = Database.database().reference(withPath: "placesTable")
    let userTableRef = Database.database().reference(withPath: "usersTable")

    var facebookID: String = ""
    var placeID: String = ""
    var placeName: String = ""
    var items: [JoiningUserItem] = []
    var alreadyJoined: Bool = false
    
    @IBOutlet var addPlaceButton: UIBarButtonItem!
    @IBOutlet var joiningUsersTableView: UITableView!
    @IBOutlet var homeButton: UIBarButtonItem!
    @IBOutlet var placeImageView: UIImageView!
    @IBOutlet var placeNameLabel: UILabel!
    @IBOutlet var addedByLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var signOutButton: UIBarButtonItem!
    @IBOutlet var descriptionTextView: UITextView!
    
    @IBAction func signOutButtonTouched(_ sender: Any) {
        do {

            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            dismiss(animated: true, completion: nil)
            
        } catch {
            print("Could not sign out: \(error)")
        }
    }

    @IBAction func homeButtonTouched(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func addPlaceButtonTouched(_ sender: Any) {
        
        print("check65")
        print(facebookID)
        print(placeID)
        
        userTableRef.child("\(facebookID)/joinsEvents/\(placeID)").setValue(["placeID": placeID])
        
        placeTableRef.child("\(placeID)/joiningUsers/\(facebookID)").setValue(["facebookID": facebookID])
        
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("check69")
        
        self.facebookID = Facebook.sharedInstance.facebookID
        
        if alreadyJoined == true {
            self.navigationItem.rightBarButtonItem = nil
        }

        self.placeNameLabel.text = self.placeName
        

        DownloadPicture.sharedInstance.loadFirstPhotoForPlace(placeID: placeID, imageView: self.placeImageView)
        
        placeTableRef.queryOrdered(byChild: "placeName").observe(.value, with: { snapshot in
            
            //            Iterate over items in snapshot
            for item in snapshot.children {
                
                //                Create database instance to get data per place
                let placeItem = PlaceItem(snapshot: item as! DataSnapshot)
                self.placeName = placeItem.placeName
                let placeTime = placeItem.placeTime
                let placeDescription = placeItem.placeDescription

                self.descriptionTextView.text = placeDescription
                self.timeLabel.text = placeTime
            }
            
        })
        let placeItemRef = placeTableRef.child(placeID)
        let joiningUsersRef = placeItemRef.child("joiningUsers")
        joiningUsersRef.queryOrdered(byChild: "joiningUsers").observe(.value, with: { snapshot in
            
            var joiningUserItems: [JoiningUserItem] = []
            for item in snapshot.children {
                print("check604: \(item)")
                let joiningUserItem = JoiningUserItem(snapshot: item as! DataSnapshot)
                joiningUserItems.append(joiningUserItem)
            }
            
            self.items = joiningUserItems
            print("check606: \(joiningUserItems)")
            print("check605: \(self.items)")
            print(self.items.count)
            self.joiningUsersTableView.reloadData()
        })

        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("check60: \(items.count)")
        return items.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "joiningUsersCell") as! JoiningUsersCell
        

        //        Get places table
        print("check62: \(self.items)")
        let joiningUserItem = self.items[indexPath.row]
        let joiningUserFacebookID = joiningUserItem.facebookID
        
        
        print("check621: \(joiningUserFacebookID)")
        var userItemRef = userTableRef.child(joiningUserFacebookID).observe(.value, with: { snapshot in
            var user = UserItem(snapshot: snapshot)
            
                print("check622: \(user)")
//            cell.user
            cell.userNameLabel.text = user.name

            let profilePictureURL = NSURL(string: user.profilePictureURL)
            DownloadPicture.sharedInstance.downloadFacebookImage(url: profilePictureURL! as URL, imageView: cell.userImageView)
        })
        return cell
    }
      

        
}



    


