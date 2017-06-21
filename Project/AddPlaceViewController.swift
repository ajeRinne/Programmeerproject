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

class AddPlaceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var addPlaceButton: UIBarButtonItem!
    @IBOutlet var joiningUsersTableView: UITableView!
    @IBOutlet var homeButton: UIBarButtonItem!
    
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

    @IBAction func homeButtonTouched(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func addPlaceButtonTouched(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = Auth.auth().currentUser

        // Do any additional setup after loading the view.
    }

    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        return cell
    }
//    override func viewDidAppear(_ animated: Bool) {
//        self.tableView.reloadData()
//    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
