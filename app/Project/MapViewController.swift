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

    let lat = 52.370216
    let lon = 4.895168
    
    var placeID: String = ""
    var placeName: String = ""
    var facebookID: String = ""
    var googleMapsView: GMSMapView!
    var searchResultController: SearchResultsController!
    var resultsArray = [String]()

    
    @IBOutlet var searchButton: UIBarButtonItem!
    
    @IBAction func searchButtonTouched(_ sender: Any) {
            let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
            self.present(searchController, animated: true, completion: nil)
    }

    @IBOutlet var mapsView: UIView!
    
    

    func csv(data: String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ";")
            result.append(columns)
        }
        return result
    }
    
    func pickPlace(lat: Double, lon: Double) {
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let northEast = CLLocationCoordinate2D(latitude: center.latitude + 0.001, longitude: center.longitude + 0.001)
        let southWest = CLLocationCoordinate2D(latitude: center.latitude - 0.001, longitude: center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        let placePicker = GMSPlacePicker(config: config)

        placePicker.pickPlace(callback: {(place, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let place = place {
                
                print("check34")
                print(place)


                self.placeID = place.placeID
                print(self.placeID)
                self.placeName = place.name
                

                self.performSegue(withIdentifier: "mapToCreatePlace", sender: nil)
            }
        })
    }

    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        
        DispatchQueue.main.async() { () -> Void in
        
            print("calculating lat lon")
            let position = CLLocationCoordinate2DMake(lat, lon)
            let marker = GMSMarker(position: position)
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 10)
            
            if camera != nil {
                print("check35")
            }
            self.googleMapsView.camera = camera
            
            marker.title = "Address: \(title)"
            marker.map = self.googleMapsView
            print("check36: \(marker)")
            print("calculated lat lon")
        }
        
    }
    

    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//        let marker = GMSMarker()
        let place = marker.title
        print("Check37: \(place!)")



        return true
    }

    

    
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
                    print("check38\(self.resultsArray)")
                }
                
            }
            
            self.searchResultController.reloadDataWithArray(self.resultsArray)
            
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "mapToCreatePlace") {
            let viewController = segue.destination as! CreatePlaceViewController
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
                        print("check223:\(self.facebookID)")
                    }
                }
            }
            print("user signed in")
        } else {
            print("no user signed in")
        }

        print("check39")
        pickPlace(lat: lat, lon: lon)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("check30")
        let lat = 52.370216
        let lon = 4.895168
        let position = CLLocationCoordinate2DMake(lat, lon)
//        let marker = GMSMarker(position: position)
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 10)
        


        self.googleMapsView = GMSMapView(frame: self.mapsView.frame)
               self.googleMapsView.mapType = .normal
        self.googleMapsView.delegate = self
        
        self.view.addSubview(self.googleMapsView)

        searchResultController = SearchResultsController()
        searchResultController.delegate = self
        pickPlace(lat: lat, lon: lon)

    }
    
}


