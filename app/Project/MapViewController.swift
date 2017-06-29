//
//  MapViewController.swift
//  Project
//
//  Created by Alexander Rinne on 18-06-17.
//  Copyright © 2017 Alexander Rinne. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FBSDKLoginKit
import FacebookCore
import GoogleMaps
import GooglePlaces
import GooglePlacePicker


class MapViewController: UIViewController, UISearchBarDelegate, LocateOnTheMap, GMSMapViewDelegate {

//    MARK: - Constants
    
    let lat = 52.370216
    let lon = 4.895168
    
//    MARK: - Variables
    
    var placeID: String = ""
    var placeName: String = ""
    var facebookID: String = ""
    var googleMapsView: GMSMapView!
    var searchResultController: SearchResultsController!
    var resultsArray = [String]()

//    MARK: - Outlets
    
    @IBOutlet var searchButton: UIBarButtonItem!
    @IBOutlet var mapsView: UIView!
    
//    MARK: - Actions
    
//    initiate searchController
    @IBAction func searchButtonTouched(_ sender: Any) {
            let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
            self.present(searchController, animated: true, completion: nil)
    }
    
//    MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        authenticate user
        self.facebookID = Facebook.sharedInstance.facebookID
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        
//        configure MapsView
        self.googleMapsView = GMSMapView(frame: self.mapsView.frame)
        self.googleMapsView.mapType = .normal
        self.googleMapsView.delegate = self
        self.view.addSubview(self.googleMapsView)
        
//        configure searchbarController
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
        
//        configure placePicker
        pickPlace(lat: lat, lon: lon)
    }


//    MARK: - placePicker
    
//    get place data
    func csv(data: String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ";")
            result.append(columns)
        }
        return result
    }
    
//    configure placePicker
    func pickPlace(lat: Double, lon: Double) {
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let northEast = CLLocationCoordinate2D(latitude: center.latitude + 0.001, longitude: center.longitude + 0.001)
        let southWest = CLLocationCoordinate2D(latitude: center.latitude - 0.001, longitude: center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        let placePicker = GMSPlacePicker(config: config)

//        check place picker error
        placePicker.pickPlace(callback: {(place, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }

//            save place info when place is picked
            if let place = place {

                self.placeID = place.placeID
                self.placeName = place.name
                

                self.performSegue(withIdentifier: "mapToCreatePlace", sender: nil)
            }
        })
    }
    
//    MARK: - Maps

    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        
        DispatchQueue.main.async() { () -> Void in
        

            let position = CLLocationCoordinate2DMake(lat, lon)
            let marker = GMSMarker(position: position)
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 10)
            self.googleMapsView.camera = camera
            
            marker.title = "Address: \(title)"
            marker.map = self.googleMapsView
            self.pickPlace(lat: lat, lon: lon)
            
        }
        
    }
    
//    MARK: - Searchbar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let placeClient = GMSPlacesClient()
        placeClient.autocompleteQuery(searchText, bounds: nil, filter: nil) { (results, error)  -> Void in
            
            self.resultsArray.removeAll()
            
            if results == nil {
                return
            }
            for result in results! {
                if let result = result as? GMSAutocompletePrediction {
                    self.resultsArray.append(result.attributedFullText.string)
                }
                
            }
            
            self.searchResultController.reloadDataWithArray(self.resultsArray)
            
        }
    }
    
//    MARK: - Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "mapToCreatePlace") {
            let viewController = segue.destination as! CreatePlaceViewController
            viewController.facebookID = facebookID
            viewController.placeID = placeID
            viewController.placeName = placeName
        }
    }
}


