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
import FacebookLogin
import FacebookCore
import GooglePlaces

class CreatePlaceViewController: UIViewController {
    
    let placeTableRef = Database.database().reference(withPath: "placesTable")
    let userTableRef = Database.database().reference(withPath: "usersTable")
    
    var placeID : String = ""
    var facebookID : String = ""
    var placeName : String = ""

    
    
    @IBOutlet var placeImageView: UIImageView!
    @IBOutlet var placeNameLabel: UILabel!
    @IBOutlet var addEventNameTextField: Textfield!
    @IBOutlet var addTimeTextField: Textfield!
    @IBOutlet var addDescriptionTextView: TextView!
    @IBOutlet var createPlaceButton: UIBarButtonItem!
    @IBOutlet var signOutButton: UIBarButtonItem!
    @IBOutlet var addButton: UIView!
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

    @IBAction func addButtonTouched(_ sender: Any) {
        
        print("check50")
        let placeItem = PlaceItem(placeID: self.placeID, facebookID: self.facebookID, placeName: self.placeName, eventName: addEventNameTextField.text!, placeTime: addTimeTextField.text!, placeDescription: addDescriptionTextView.text!)
        print("check501")
        print(placeItem)
        
        //              Create a reference to the database for the place
        let placeItemRef = placeTableRef.child(placeID)
        placeItemRef.setValue(placeItem.toAnyObject())
        
        userTableRef.child("\(facebookID)/joinsEvents/\(placeID)").setValue(["placeID": placeID])
        
        placeTableRef.child("\(placeID)/joiningUsers/\(facebookID)").setValue(["facebookID": facebookID])
        
        self.performSegue(withIdentifier: "createPlaceToMyPlaces", sender: nil)
        

        print("check503")
//        print(placeItemRef)
    
        
    }
    
   
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            (photo, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                print("check503")
                print(photo)
                self.placeImageView.image = photo;
                
            }
        })
    }
    
    func loadFirstPhotoForPlace(placeID: String) {
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                print("check56")
                print(placeID)
                print(self.placeName)
                if let firstPhoto = photos?.results.first {
                    print("check57")
                    self.loadImageForMetadata(photoMetadata: firstPhoto)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("check68")
        //        _ = sender as! UITableViewCell
        if (segue.identifier == "createPlaceToMyPlaces") {
            let viewController = segue.destination as! MyPlacesViewController

            viewController.facebookID = self.facebookID
            
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("check59")
        print(facebookID)
        print(placeID)
        print(placeName)
        
//        if FBSDKAccessToken.current() != nil {
//            print("user: \(FBSDKAccessToken.current()!) signed in")
//            let params = ["fields" : "id, name"]
//            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: params)
//            graphRequest.start {
//                (urlResponse, requestResult) in
//                
//                switch requestResult {
//                case .failed(let error):
//                    print("error in graph request:", error)
//                    break
//                case .success(let graphResponse):
//                    if let responseDictionary = graphResponse.dictionaryValue {
//                        print(responseDictionary)
//                        print("check16")
//                        self.name = (responseDictionary["name"]!) as! String
//                        self.facebookID = (responseDictionary["id"]!) as! String
//                        print("check17")
//                        print(self.facebookID)
//                        self.performSegue(withIdentifier: "loginToMyPlaces", sender: nil)
//                    }
//                }
//            }
//        }

        let user = Auth.auth().currentUser
        loadFirstPhotoForPlace(placeID: placeID)
        print(facebookID)
        addEventNameTextField.text = ""
        addTimeTextField.text = ""
        addDescriptionTextView.text = ""

        // Do any additional setup after loading the view.
        self.placeNameLabel.text = self.placeName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
