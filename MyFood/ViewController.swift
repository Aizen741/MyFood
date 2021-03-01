//
//  ViewController.swift
//  MyFood
//
//  Created by Rahul Sivadasan on 28/02/21.
//

import UIKit
import CoreML
import Vision


class ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var ImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let UserPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            ImageView.image = UserPickedImage
            
            guard let ciImage = CIImage(image: UserPickedImage) else {
                fatalError("Ci image donot worked!")
            }
            
            detect(image: ciImage)

        }
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    func detect(image: CIImage){
        
        guard let model =  try? VNCoreMLModel(for:Inceptionv3().model) else{
            fatalError("Loading model Failed")
        }
        let request = VNCoreMLRequest(model: model){(request,error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("model failed to processs image")
            }
            
            if let firstResult = results.first {
                if firstResult.identifier.contains("hotdog"){
                    self.navigationItem.title = "Hotdog !"
                }else{
                    self.navigationItem.title = "Not Hotdog!"
                }
            }
        }
        
    
    let handler = VNImageRequestHandler(ciImage: image)
    
    do {
        try handler.perform([request])
    }
    catch{
        print(error)
    }
    }
    
    
    
    
    @IBAction func cameraTapperd(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
    }
}

