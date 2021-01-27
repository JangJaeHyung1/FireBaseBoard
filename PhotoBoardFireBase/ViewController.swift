//
//  ViewController.swift
//  PhotoBoardFireBase
//
//  Created by jh on 2021/01/26.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController {
    
    
    @IBAction func sign(_ sender: Any) {
        
        GIDSignIn.sharedInstance().signIn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().presentingViewController = self
        
        
        // Do any additional setup after loading the view.
    }


}

