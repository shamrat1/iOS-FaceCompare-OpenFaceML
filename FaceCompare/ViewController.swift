//
//  ViewController.swift
//  FaceCompare
//
//  Created by Mac on 2/26/20.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import SFaceCompare

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK:- Vars and Const's
    let actorImages = [
        #imageLiteral(resourceName: "tom-hanks"),#imageLiteral(resourceName: "chris-evens"),#imageLiteral(resourceName: "rdj")
    ]
    let imagePickerController = UIImagePickerController()
    var userSelected: UIImage?
    var matchedIndexes : [Int] = []
    
    // MARK:- Outlets
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var matchView: UIView!
    @IBOutlet weak var matchResultLabel: UILabel!
    @IBOutlet weak var compareButton: UIButton!
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        matchView.isHidden = true
        compareButton.isEnabled = false
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.matchedIndexes = []
            imageView2.image = userPickedImage
            imageView2.contentMode = .scaleAspectFit
            self.userSelected = userPickedImage
            compareButton.isEnabled = true
        }
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickImagePicker(_ sender: Any) {
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func onClickResults(_ sender: Any) {
        print(matchedIndexes)
        if matchedIndexes.count > 0 {
            let alert = UIAlertController(title: "Success", message: "\(matchedIndexes.count) Matched Case\(matchedIndexes.count > 1 ? "s": "")", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func onClickCompare(_ sender: UIButton) {
        compareButton.isEnabled = false
        guard let userSelectedImage = userSelected else {
            fatalError("Failed selecting image")
        }
        
        for index in 0..<actorImages.count{
            // 1: Create compare object
            let faceComparator = SFaceCompare(on: actorImages[index], and: userSelectedImage)
            // 2: Call compareFaces method with success and error handlers
            faceComparator.compareFaces(succes: { results in
                self.matchedIndexes.append(index)
                self.matchView.isHidden = false
                self.matchView.backgroundColor = .green
                self.matchResultLabel.text = "Match Found"
                print("match")
                
            }, failure: {  error in
//                self.matchView.isHidden = false
//                self.matchView.backgroundColor = .red
//                self.matchResultLabel.text = "Not Matched"
                print("not match")

            })
        }
        
    }
}

