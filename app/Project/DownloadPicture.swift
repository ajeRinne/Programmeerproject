//
//  DownloadPicture.swift
//  Pods
//
//  Created by Alexander Rinne on 25-06-17.
//
//

//import Foundation
//import FacebookCore
//
//class DownloadPicture {
//    
//    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
//        URLSession.shared.dataTask(with: url) {
//            (data, response, error) in
//            completion(data, response, error)
//            }.resume()
//    }
//    
//    func downloadImage(url: URL -> UIImage) {
//        print("Download Started")
//        getDataFromUrl(url: url) { (data, response, error)  in
//            guard let data = data, error == nil else { return }
//            print(response?.suggestedFilename ?? url.lastPathComponent)
//            print("Download Finished")
//            DispatchQueue.main.async() { () -> Void in
////                cell.userImageView.image = UIImage(data: data)
//                let image = UIImage(data: data)
//                return image
//            }
//        }
//    }
//
//    
//}
