//
//  DownloadPicture.swift
//  Pods
//
//  Created by Alexander Rinne on 25-06-17.
//
//

import Foundation
import FacebookCore
import GooglePlaces

class DownloadPicture {
    
//    declare sharedInstance
    static let sharedInstance = DownloadPicture()
    
//    get facebook Image from URL
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
//    download image and display in image view
    func downloadFacebookImage(url: URL, imageView: UIImageView) {

        getDataFromUrl(url: url) { (data, response, error)  in
            
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() { () -> Void in
            imageView.image = UIImage(data: data)
            }
        }
    }

//    load place picture from placeID
    func loadFirstPhotoForPlace(placeID: String, imageView: UIImageView) {
        
//        get first picture of place
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            
            if let error = error {

                print("Error: \(error.localizedDescription)")
            } else {
                
                if let firstPhoto = photos?.results.first {

                    GMSPlacesClient.shared().loadPlacePhoto(firstPhoto, callback: {
                        (photo, error) -> Void in
                        if let error = error {
                            print("Error: \(error.localizedDescription)")
                        } else {

//                            insert image in imageView
                            imageView.image = photo;
                        }
                    })
                }
            }
        }
    }
}
