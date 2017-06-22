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
import GooglePlaces

class AddPlaceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var facebookID : String = ""
    var placeID : String = ""
    var placeName : String = ""
    
    let placeTableRef = Database.database().reference(withPath: "placesTable")
    let userTableRef = Database.database().reference(withPath: "usersTable")

    
//    let placeTableRef = Database.database().reference(withPath: "placesTable")
//    let userTableRef = Database.database().reference(withPath: "usersTable").child("users/\(userID)")

    @IBOutlet var addPlaceButton: UIBarButtonItem!
    @IBOutlet var joiningUsersTableView: UITableView!
    @IBOutlet var homeButton: UIBarButtonItem!
    @IBOutlet var placeNameLabel: UILabel!
    @IBOutlet var addedByLabel: UILabel!
    
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var signOutButton: UIBarButtonItem!
    
    @IBOutlet var descriptionTextView: UITextView!
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
    }

    @IBAction func homeButtonTouched(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func addPlaceButtonTouched(_ sender: Any) {
        
        print("check51")
        print(facebookID)
        print(placeID)
        userTableRef.child(facebookID).child("joinsEvents").setValue(placeID)
        placeTableRef.child(placeID).child("joiningUsers").setValue(facebookID)
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            (photo, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                print("check17")
                print(photo)
//                self.placeImageView.image = photo;
//                print(self.placeName)
//                print(self.placeID)
//                self.placeNameLabel.text = self.placeName
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
                print(self.placeName)
                if let firstPhoto = photos?.results.first {
                    print("check19")
                    self.loadImageForMetadata(photoMetadata: firstPhoto)
                }
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("check28")
        print(placeName)
        print(placeID)
        print(facebookID)
        self.placeNameLabel.text = self.placeName
        loadFirstPhotoForPlace(placeID: placeID)
    }

    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        return cell
    }
//    override func viewDidAppear(_ animated: Bool) {
//        self.tableView.reloadData()
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
