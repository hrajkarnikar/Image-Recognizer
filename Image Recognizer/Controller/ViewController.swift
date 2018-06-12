//
//  ViewController.swift
//  Image Recognizer
//
//  Created by bjoshi on 6/11/18.
//  Copyright © 2018 hrajkarnikar. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let userPickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageView.image = userPickedImage
            
            guard let convertedImage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert UIImage to CIImage")
            }
            
            detect(image: convertedImage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func detect(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading core model failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let result = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image")
            }
            print(result)
            if let firstResult = result.first {
                self.navigationItem.title = firstResult.identifier.capitalized
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)

    }
    
}

