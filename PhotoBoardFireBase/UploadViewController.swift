//
//  UploadViewController.swift
//  PhotoBoardFireBase
//
//  Created by jh on 2021/01/30.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var subject: UITextField!
    @IBOutlet weak var explaination: UITextField!
    
    @IBAction func uploadBtn(_ sender: Any) {
        upload()
    }
    
    
       
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        dismiss(animated: true, completion: nil)
        
        
    }
    func upload(){
        
        guard let image = self.imageView.image else {
            return
        }
        
        let imageName = Auth.auth().currentUser?.uid ?? " " + "\(Int(NSDate.timeIntervalSinceReferenceDate * 1000)).jpg"
        
        let riversRef = Storage.storage().reference().child("ios_images").child(imageName)
        
        riversRef.putData(image.pngData()!, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            riversRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                Database.database().reference().child("users").childByAutoId().setValue([
                    "userId": Auth.auth().currentUser?.email,
                    "uid": Auth.auth().currentUser?.uid,
                    "subject": self.subject.text!,
                    "explaination": self.explaination.text!,
                    "imageUrl" : downloadURL.absoluteString
                ])
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openGallery)))
        imageView.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }
    
    @objc func openGallery() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
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
