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
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            (photo, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                print("check66")
                print(photo)
                self.placeImageView.image = photo;
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
                print("check67")
                print(placeID)
                print(self.placeName)
                if let firstPhoto = photos?.results.first {
                    print("check68")
                    self.loadImageForMetadata(photoMetadata: firstPhoto)
                }
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("check69")
        
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
                        print("check61:\(self.facebookID)")
                    }
                }
            }
            print("user signed in")
        }else {
            print("no user signed in")
        }


        self.placeNameLabel.text = self.placeName
        
        loadFirstPhotoForPlace(placeID: placeID)
        
        placeTableRef.queryOrdered(byChild: "placeName").observe(.value, with: { snapshot in
            
            //            Iterate over items in snapshot
            for item in snapshot.children {
                
                //                Create database instance to get data per place
                let placeItem = PlaceItem(snapshot: item as! DataSnapshot)
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
        
        userTableRef.queryOrdered(byChild: "facebookID").queryEqual(toValue: facebookID).observe(.value, with: { snapshot in

            //            Iterate over items in snapshot
            self.userTableRef.queryOrdered(byChild: "facebookID").queryEqual(toValue: joiningUserFacebookID).observe(.value, with: { snapshot in
                
            })

            for item in snapshot.children {
                
                print("check63: \(item)")
                
                //                Create database instance to get data per place
                let userItem = UserItem(snapshot: item as! DataSnapshot)
                
                let name = userItem.name
                let URL = userItem.profilePictureURL
                let profilePictureURL = NSURL(string: URL)
                
                func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
                    URLSession.shared.dataTask(with: url) {
                        (data, response, error) in
                        completion(data, response, error)
                        }.resume()
                }

                func downloadImage(url: URL) {
                    print("Download Started")
                    getDataFromUrl(url: url) { (data, response, error)  in
                        guard let data = data, error == nil else { return }
                        print(response?.suggestedFilename ?? url.lastPathComponent)
                        print("Download Finished")
                        DispatchQueue.main.async() { () -> Void in
                            cell.userImageView.image = UIImage(data: data)
                        }
                    }
                }
                
                downloadImage(url: profilePictureURL! as URL)
                cell.userNameLabel.text = name
                
                //                Append data of single place to array

                print("check64: \(joiningUserItem.facebookID)")
            }



            //            Reload data in order se up to date view
//            self.tableView.reloadData()
        })
        
        
        return cell
        

    }


}
    


