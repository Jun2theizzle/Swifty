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
    var googleAPIKey = "some api key"
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
        
        uiBackground.image = UIImage(named: "Lineups/holyship_lineup.png")
        // Do any additional setup after loading the view.
    }
    
    func doVision(_ request: URLRequest) { // _ is to be able to call function with named params, ie doVision(request)
        let task = URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else { // guard used to unwrap optionals, instead of doing if if let someVar = variable.value {}
                print(error?.localizedDescription ?? "")
                return
            }
        }
    }

}
