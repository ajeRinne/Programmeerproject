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
    
    static let sharedInstance = DownloadPicture()
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadFacebookImage(url: URL, imageView: UIImageView) {
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
            imageView.image = UIImage(data: data)
            }

        }
    }
    
//    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
//        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
//            (photo, error) -> Void in
//            if let error = error {
//                // TODO: handle the error.
//                print("Error: \(error.localizedDescription)")
//            } else {
//                print("check66")
//                print(photo)
//                self.placeImageView.image = photo;
//                //                print("check602: \(photo.type)")
//                //                print(self.placeName)
//                //                print(self.placeID)
//                //                self.placeNameLabel.text = self.placeName
//            }
//        })
//    }
    
    func loadFirstPhotoForPlace(placeID: String, imageView: UIImageView) {
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                print("check67")
                print(placeID)
//                print(self.placeName)
                if let firstPhoto = photos?.results.first {
                    print("check68")
//                    self.loadImageForMetadata(photoMetadata: firstPhoto)
                    GMSPlacesClient.shared().loadPlacePhoto(firstPhoto, callback: {
                        (photo, error) -> Void in
                        if let error = error {
                            // TODO: handle the error.
                            print("Error: \(error.localizedDescription)")
                        } else {
                            print("check66")
                            print(photo)
                            imageView.image = photo;
                            //                print("check602: \(photo.type)")
                            //                print(self.placeName)
                            //                print(self.placeID)
                            //                self.placeNameLabel.text = self.placeName
                        }
                    })

                }
            }
        }
    }


    
}
