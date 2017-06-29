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
    
//    MARK: - Constants
    
    let placeTableRef = Database.database().reference(withPath: "placesTable")
    let userTableRef = Database.database().reference(withPath: "usersTable")

//    MARK: - Variables
    
    var facebookID: String = ""
    var placeID: String = ""
    var placeName: String = ""
    var items: [JoiningUserItem] = []
    var alreadyJoined: Bool = false
    
//    MARK: - Outlets
    
    @IBOutlet var addPlaceButton: UIBarButtonItem!
    @IBOutlet var joiningUsersTableView: UITableView!
    @IBOutlet var homeButton: UIBarButtonItem!
    @IBOutlet var placeImageView: UIImageView!
    @IBOutlet var placeNameLabel: UILabel!
    @IBOutlet var eventLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var descriptiontextView: UITextView!
    @IBOutlet var signOutButton: UIBarButtonItem!
    @IBOutlet var descriptionTextView: UITextView!
    
//    MARK: - Actions
    
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
        
        userTableRef.child("\(facebookID)/joinsEvents/\(placeID)").setValue(["placeID": placeID])
        placeTableRef.child("\(placeID)/joiningUsers/\(facebookID)").setValue(["facebookID": facebookID])
        
        _ = navigationController?.popViewController(animated: true)
    }
    
//    MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.facebookID = Facebook.sharedInstance.facebookID
        
        if alreadyJoined == true {
            
            self.navigationItem.rightBarButtonItem = nil
        }

        self.placeNameLabel.text = self.placeName
        
        DownloadPicture.sharedInstance.loadFirstPhotoForPlace(placeID: placeID, imageView: self.placeImageView)
        
        placeTableRef.child(placeID).observe(.value, with: { snapshot in

//            Create database instance to get data per place
            let placeItem = PlaceItem(snapshot: snapshot as! DataSnapshot)

            self.placeNameLabel.text = placeItem.placeName
            self.eventLabel.text = placeItem.eventName
            self.timeLabel.text = placeItem.placeTime
            self.descriptionTextView.text = placeItem.placeDescription
            
            
        })
        let placeItemRef = placeTableRef.child(placeID)
        let joiningUsersRef = placeItemRef.child("joiningUsers")
        joiningUsersRef.queryOrdered(byChild: "joiningUsers").observe(.value, with: { snapshot in
            
            var joiningUserItems: [JoiningUserItem] = []
            for item in snapshot.children {
                let joiningUserItem = JoiningUserItem(snapshot: item as! DataSnapshot)
                joiningUserItems.append(joiningUserItem)
            }
            
            self.items = joiningUserItems
            self.joiningUsersTableView.reloadData()
        })

        
        
        
    }
    
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return items.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "joiningUsersCell") as! JoiningUsersCell
        

        //        Get places table

        let joiningUserItem = self.items[indexPath.row]
        let joiningUserFacebookID = joiningUserItem.facebookID
        
        
        var userItemRef = userTableRef.child(joiningUserFacebookID).observe(.value, with: { snapshot in
            var user = UserItem(snapshot: snapshot)
            

            cell.userNameLabel.text = user.name

            let profilePictureURL = NSURL(string: user.profilePictureURL)
            DownloadPicture.sharedInstance.downloadFacebookImage(url: profilePictureURL! as URL, imageView: cell.userImageView)
        })
        return cell
    }
      

        
}



    


