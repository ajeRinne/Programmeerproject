//
//  CreatePlaceViewController.swift
//  Project
//
//  Created by Alexander Rinne on 08-06-17.
//  Copyright © 2017 Alexander Rinne. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GooglePlaces

class CreatePlaceViewController: UIViewController {
    
    let placesRef = Database.database().reference(withPath: "placesTable")
    
    var placeID : String = ""
    var facebookID : String = ""
    var placeName : String = ""

    
    
    @IBOutlet var placeImageView: UIImageView!
    
    @IBOutlet var placeNameLabel: UILabel!
    

    @IBOutlet var createPlaceButton: UIBarButtonItem!
    
    @IBOutlet var signOutButton: UIBarButtonItem!
    
    @IBAction func signOutButtonTouched(_ sender: Any) {
        do {
            //            Authenticate user and log out
            try Auth.auth().signOut()
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            dismiss(animated: true, completion: nil)
            
        } catch {
            print("Could not sign out: \(error)")
        }
    }
    
    
    @IBAction func createPlaceButtonTouched(_ sender: Any) {
        
        let placeItem = PlaceItem(placeID: self.placeID, facebookID: self.facebookID, placeName: self.placeName, eventName: "empty", placeTime: "empty", placeDescription: "empty", joiningUsers: facebookID)
        
        //              Create a reference to the database for the place
        let placeItemRef = self.placesRef.child(placeID)

        performSegue(withIdentifier: "createEventToAddEvent", sender: nil)
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
                self.placeImageView.image = photo;
                print(self.placeName)
                print(self.placeID)
                self.placeNameLabel.text = self.placeName
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
        let user = Auth.auth().currentUser
        loadFirstPhotoForPlace(placeID: placeID)
        print(facebookID)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
