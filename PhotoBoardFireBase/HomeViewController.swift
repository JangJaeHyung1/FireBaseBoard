//
//  HomeViewController.swift
//  PhotoBoardFireBase
//
//  Created by jh on 2021/01/28.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var array: [UserDTO] = []
    var uidKet: [String] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        
        cell.subject.text = array[indexPath.row].subject
        cell.explaination.text = array[indexPath.row].explaination
        
        let data = try? Data(contentsOf: URL(string: array[indexPath.row].imageUrl!)!)
        cell.imageView.image = UIImage(data: data!)
        
        return cell
    }
    

    @IBOutlet weak var lblUser: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Database.database().reference().child("users").childByAutoId().observe(.value) { (DataSnapshot) in
            self.array.removeAll()
            
            for child in DataSnapshot.children{
                let fchild = child as? DataSnapshot
                let userDTO = UserDTO()
                userDTO.setValuesForKeys((fchild?.value as? [String: Any])!)
                self.array.append(userDTO)
            }
            self.collectionView.reloadData()
        }
        
        lblUser.text = Auth.auth().currentUser?.email
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

class CustomCell : UICollectionViewCell{
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var explaination: UILabel!
}
