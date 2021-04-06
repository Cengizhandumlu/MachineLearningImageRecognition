//
//  ViewController.swift
//  MachineLearningImageRecognition
//
//  Created by Cengizhan DUMLU on 6.04.2021.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    
    var chosenImage = CIImage()
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    @IBAction func changeClicked(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        
        if let ciImage = CIImage(image: imageView.image!){
            chosenImage = ciImage
        }
        //recognizeImage resim secilir secilmez cagırılacak
        recognizeImage(image: chosenImage)
        
    }
    
    func recognizeImage(image: CIImage){
        //1) Request olusturmak
        
        //2) Handler olusturmak (ele almak)
        
        resultLabel.text = "Finding ..."
        
        if let model = try? VNCoreMLModel(for: MobileNetV2().model) { //indirdigimiz modelin ismini verdik
             //mobilnetv2 modelini bir degiskene atadık
            let request = VNCoreMLRequest(model: model) { (vnrequest, error) in
                if let results = vnrequest.results as? [VNClassificationObservation] {
                    //Gorsel sınıflandırma dizisini bizimle paylasıyor
                    if results.count > 0 {
                        let topResult = results.first // ilk secenegi bize getir dedik
                        
                        //request islemi
                        //yuzde kac islemle alındı
                        //requesti ele alıp calısacagı yer handler kısmı
                        DispatchQueue.main.async {
                            let confidienceLevel = (topResult?.confidence ?? 0) * 100
                            let rounded = Int (confidienceLevel*100) / 100
                            
                            self.resultLabel.text = "\(rounded)% it's \(topResult!.identifier)" //request tamamlandı fakat calısmadı henuz
                        }
                    }
                }
            }
            
            //Handler kısmı
            let handler = VNImageRequestHandler(ciImage: image)
            DispatchQueue.global(qos: .userInteractive).async {
                do{
                    try handler.perform([request])
                }catch{
                    print("error")
                }
        }
        
    }
    
  }
    
}

