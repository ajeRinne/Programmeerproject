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
import GooglePlaces
// api key: AIzaSyDCedmeFG_2z2W3u2sohX13judBZ90Y_xI

class MyPlacesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    
    let cellIdentifier : String = "cell"
    
//    MARK: - Maps Search bar
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?

    @IBOutlet var addBarbutton: UIBarButtonItem!

    @IBOutlet var addedByMeTableView: UITableView!
    
    @IBOutlet var placesIJoinTableView: UITableView!
    
    @IBOutlet var searchPlacesButton: UIBarButtonItem!
    
    @IBOutlet var signOutButton: UIBarButtonItem!
    
    @IBAction func signOutButtonTouched(_ sender: Any) {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        dismiss(animated: true, completion: nil)
    }

    
    @IBAction func searchPlacesButtonTouched(_ sender: Any) {
        performSegue(withIdentifier: "myPlacesToPlaces", sender:nil)
        
    }
    
    @IBAction func addBarButtonTouched(_ sender: Any) {
        performSegue(withIdentifier: "myPlacesToCreatePlace", sender:nil)
    }
    
    @IBAction func autocompleteClicked(_ sender: UISearchController) {
        print("AutocompleteClicked")
        let autocompleteController = GMSAutocompleteViewController()
//        autocompleteController.delegate = self as! GMSAutocompleteViewControllerDelegate
        present(autocompleteController, animated: true, completion: nil)
    }
    
    
    
    
    override func viewDidLoad() {
        
//        MARK: - Maps search bar
//        resultsViewController?.delegate = self as! GMSAutocompleteResultsViewControllerDelegate
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        let subView = UIView(frame: CGRect(x: 0, y: 65.0, width: 350.0, height: 45.0))
        
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        
//        view.addConstraint(NSLayoutConstraint(item: searchController, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0))
//        view.addConstraint(NSLayoutConstraint(item: searchController, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0))

        
//        let trailingConstraint = NSLayoutConstraint(item: searchController as Any, attribute: .trailing, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
//       let leadingConstraint = NSLayoutConstraint(item: searchController as Any, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 90)
//        let trailingConstraint = NSLayoutConstraint(item: searchController, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: Superview.trailing, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 0)
//        searchController.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
//        let leadingConstraint = NSLayoutConstraint(item: searchController, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: Superview.leading, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 0)
//        let heightConstraint = NSLayoutConstraint(item: searchController, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 25)
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        super.viewDidLoad()
//        addedByMeTableView.dataSource = self
//        addedByMeTableView.delegate = self
//        placesIJoinTableView.dataSource = self
//        placesIJoinTableView.delegate = self
        if (FBSDKAccessToken.current() != nil)
        {
            print("check3")
            print(FBSDKAccessToken.current().userID)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 || tableView.tag == 2 {
            return 1
        } else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as! UITableViewCell
        if tableView.tag == 1 {
            print("check1")
//            cell.placeLabel?.text = "place works"
        } else if tableView.tag == 2 {
            print("check2")
//            cell.placeLabel?.text = "place works"
//            cell.addedByLabel?.text = "addedBy works"
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.performSegue(withIdentifier: "myPlacesToAddPlace", sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
//            Add delete option for items
//            items.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
        
    
}

extension MyPlacesViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

extension MyPlacesViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
//    // Turn the network activity indicator on and off again.
//    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//    }
//    
//    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//    }
}
