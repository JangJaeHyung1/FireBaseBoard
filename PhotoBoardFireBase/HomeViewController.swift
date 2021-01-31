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
    var uidKey: [String] = []
    var userChildAutoById : String?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
//
        cell.subject.text = array[indexPath.row].subject
        cell.explaination.text = array[indexPath.row].explaination

        
        URLSession.shared.dataTask(with: URL(string: array[indexPath.row].imageUrl!)!) { (data, response, error) in
            if error != nil{
                return
            }
            DispatchQueue.main.async {
                cell.imageView.image = UIImage(data: data!)
            }
        }.resume()
        
        
        
        cell.likeBtn.tag = indexPath.row
        cell.likeBtn.addTarget(self, action: #selector(like(_:)), for: .touchUpInside)
        
        if let _ = self.array[indexPath.row].likes?[Auth.auth().currentUser!.uid] {
            cell.likeBtn.setImage(#imageLiteral(resourceName: "baseline_favorite_black_24pt"), for: .normal)
        }else{
            cell.likeBtn.setImage(#imageLiteral(resourceName: "baseline_favorite_border_black_24pt"), for: .normal)
        }
        
        
        cell.deleteImg.tag = indexPath.row
        cell.deleteImg.addTarget(self, action: #selector(deleteImg(_:)), for: .touchUpInside)
        
        return cell
    }
    

    @IBOutlet weak var lblUser: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Database.database().reference().child("users").observe(.value) { (DataSnapshot) in
            self.array.removeAll()
            self.uidKey.removeAll()
            
            for child in DataSnapshot.children{
                let fchild = child as? DataSnapshot
                let userDTO = UserDTO()
                let uidKey = fchild?.key
//                userDTO.explaination = fchild?.value(forKey: "explaination") as? String
//                userDTO.imageUrl = fchild?.value(forKey: "imageUrl") as? String
//                userDTO.subject = fchild?.value(forKey: "subject") as? String
//                userDTO.uid = fchild?.value(forKey: "uid") as? String
//                userDTO.userId = fchild?.value(forKey: "userId") as? String
                userDTO.setValuesForKeys((fchild?.value as? [String: Any])!)
                
                self.array.append(userDTO)
                self.uidKey.append(uidKey!)
                
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
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

    @objc func like(_ sender: UIButton){
        
//        if (sender.currentImage == #imageLiteral(resourceName: "baseline_favorite_black_24pt")){
//            sender.setImage(#imageLiteral(resourceName: "baseline_favorite_border_black_24pt"), for: .normal)
//        }else{
//            sender.setImage(#imageLiteral(resourceName: "baseline_favorite_black_24pt"), for: .normal)
//        }
        
        
        Database.database().reference().child("users").child(self.uidKey[sender.tag]).runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
          if var post = currentData.value as? [String : AnyObject], let uid = Auth.auth().currentUser?.uid {
            var likes: Dictionary<String, Bool>
            likes = post["likes"] as? [String : Bool] ?? [:]
            var likeCount = post["likeCount"] as? Int ?? 0
            if let _ = likes[uid] {
              // Unlike the post and remove self from likes
              likeCount -= 1
              likes.removeValue(forKey: uid)
            } else {
              // like the post and add self to likes
              likeCount += 1
              likes[uid] = true
            }
            post["likeCount"] = likeCount as AnyObject?
            post["likes"] = likes as AnyObject?

            // Set value and report transaction success
            currentData.value = post

            return TransactionResult.success(withValue: currentData)
          }
          return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
          if let error = error {
            print(error.localizedDescription)
          }
        }
    }
    
    
    @objc func deleteImg(_ sender: UIButton){
        // Create a reference to the file to delete
        let imgName = array[sender.tag].imageName
        let desertRef = Storage.storage().reference().child("ios_images/\(imgName!)")

        // Delete the file
        desertRef.delete { error in
            if error != nil {
            // Uh-oh, an error occurred!
          } else {
            // File deleted successfully
            Database.database().reference().child("users").child(self.uidKey[sender.tag]).removeValue()
          }
        }
            
    }
    
}

class CustomCell : UICollectionViewCell{
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var deleteImg: UIButton!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var explaination: UILabel!
}
