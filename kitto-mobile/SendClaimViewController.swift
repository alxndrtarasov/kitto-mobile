//
//  SendClaimViewController
//  kitto-mobile
//
//  Created by Alexander Tarasov on 27/06/2019.
//  Copyright © 2019 Alexander Tarasov. All rights reserved.
//

import UIKit
import Alamofire

class SendClaimViewController: UIViewController {
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    @IBOutlet weak var damageText: UITextView!
    @IBOutlet weak var claimButton: UIButton!
    
    var itemDescription: String?
    var requestId: Int?
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        super.viewDidLoad()
        self.view.backgroundColor = RequestsViewController.sharedColor
        itemDescriptionLabel.text = itemDescription
        damageText.clipsToBounds = true;
        damageText.layer.cornerRadius = 10.0;
        // Do any additional setup after loading the view.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is RequestSuccessViewController {
            let requestSuccessViewController = segue.destination as? RequestSuccessViewController
            let currentDate = Date()
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions.insert(.withFractionalSeconds)
            let currentDateString = formatter.string(from: currentDate)
            let headers: HTTPHeaders = [
                "authorization": UserDefaults.standard.object(forKey: "token") as! String,
                "cache-control": "no-cache",
                "postman-token": "a32c5d76-9f36-3b8a-7a42-2374f9b08dc6",
                "Content-Type": "application/json"
            ]
            
            let parameters: Parameters = [
                "policyId": requestId!,
                "description": damageText.text!,
                "claimDate": currentDateString
            ]
            
            
            AF.request("http://35.226.26.159:8080/api/V1/clients/claims", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseString {response in
                    switch response.result {
                    case .success(let JSON):
                        print("Success with JSON: \(JSON)")
                        print(response)
                        requestSuccessViewController!.animationPath = "1190-like"
                        requestSuccessViewController!.labelText = "Sent!"
                        requestSuccessViewController!.viewDidLoad()
                    case .failure(let error):
                        print("Request failed with error: \(error)")
                        requestSuccessViewController!.animationPath = "6926-sad-package"
                        requestSuccessViewController!.labelText = "Wrong request"
                        requestSuccessViewController!.viewDidLoad()
                    }
                    debugPrint(response)
            }
        }
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
