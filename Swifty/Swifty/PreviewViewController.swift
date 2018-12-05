//
//  PreviewViewController.swift
//  Swifty
//
//  Created by Jun Cheng on 11/27/18.
//  Copyright © 2018 Jun Cheng. All rights reserved.
//

import UIKit
import SwiftyJSON

class PreviewViewController: UIViewController {

    var picturePath:String = ""
    let session = URLSession.shared
    var googleAPIKey = ""
    var googleURL: URL {
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
    }
    
    @IBOutlet weak var saveBtn: UIButton!

    @IBOutlet weak var uiBackground: UIImageView!
    
    @IBAction func saveBtn_TouchUpInside(_ sender: Any) {
    }
    
    @IBAction func cancelBtn_TouchUpInside(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let image = UIImage(contentsOfFile: "Lineups/holyship_lineup.png")
        // Base64 encode the image and create the request
 
        
        let image: UIImage? = UIImage(named: "HolyShip")
        if image != nil {
            let binaryImageData = base64EncodeImage(image!)
            createRequest(with: binaryImageData)
        }
    }
    
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }

    func analyzeResults(_ results: Data) {
        do {
            let json = try JSON(data: results)
            
            let textAnnotations = json["responses"][0]["textAnnotations"].array
            for annotation in textAnnotations! {
                print(annotation["description"])
            }
        } catch let error as NSError {
            print(error)
        }

    }
    
    func base64EncodeImage(_ image: UIImage) -> String {
        var imagedata = image.pngData()
        
        // Resize the image if it exceeds the 2MB API limit
        if (imagedata!.count > 2097152) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            imagedata = resizeImage(newSize, image: image)
        }
        
        return imagedata!.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    
    func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = newImage!.pngData()
        UIGraphicsEndImageContext()
        return resizedImage!
    }

    
    func runRequestOnBackgroundThread(_ request: URLRequest) { // _ is to be able to call function with named params, ie runRequestOnBackgroundThread(request)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else { // guard used to unwrap optionals, instead of doing if if let someVar = variable.value {}
                print(error?.localizedDescription ?? "")
                return
            }
            self.analyzeResults(data)
        }
        task.resume()
    }
    
    
    func createRequest(with imageBase64: String) {
        // Create our request URL
        
        var request = URLRequest(url: googleURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        // Build our API request
        let jsonRequest = [
            "requests": [
                "image": [
                    "content": imageBase64
                ],
                "features": [
                    [
                        "type": "TEXT_DETECTION"
                    ]
                ]
            ]
        ]

        let jsonObject = JSON(jsonRequest)
        
        // Serialize the JSON
        guard let data = try? jsonObject.rawData() else {
            return
        }
        
        request.httpBody = data
        
        // Run the request on a background thread
        DispatchQueue.global().async { self.runRequestOnBackgroundThread(request) }
    }

}
