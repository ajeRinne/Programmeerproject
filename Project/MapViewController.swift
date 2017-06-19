//
//  MapViewController.swift
//  Project
//
//  Created by Alexander Rinne on 18-06-17.
//  Copyright © 2017 Alexander Rinne. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class MapViewController: UIViewController, UISearchBarDelegate, LocateOnTheMap, GMSMapViewDelegate{
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        print("check13")
        // Do any additional setup after loading the view.
    }
    
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        
        DispatchQueue.main.async() { () -> Void in
        
            print("calculating lat lon")
            let position = CLLocationCoordinate2DMake(lat, lon)
            let marker = GMSMarker(position: position)
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 10)
            
            if camera != nil {
                print("check8")
            }
            self.googleMapsView.camera = camera
            
            marker.title = "Address: \(title)"
            marker.map = self.googleMapsView
            print("check9: \(marker)")
            print("calculated lat lon")
        }
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let marker = GMSMarker()
        print("Check11: \(marker)")

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
                }
                
            }
            
            self.searchResultController.reloadDataWithArray(self.resultsArray)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("check12")
        let lat = 52.370216
        let lon = 4.895168
        let position = CLLocationCoordinate2DMake(lat, lon)
        let marker = GMSMarker(position: position)
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 10)
        


        self.googleMapsView = GMSMapView(frame: self.mapsView.frame)
               self.googleMapsView.mapType = .normal
        self.googleMapsView.delegate = self
        
        self.view.addSubview(self.googleMapsView)

        searchResultController = SearchResultsController()
        searchResultController.delegate = self
//        let mapView.delegate = self
    }
    
}
