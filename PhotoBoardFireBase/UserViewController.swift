//
//  UserViewController.swift
//  PhotoBoardFireBase
//
//  Created by jh on 2021/01/28.
//

import UIKit
import Firebase

class UserViewController: UIViewController {

    @IBAction func logout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch  {
        }
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
