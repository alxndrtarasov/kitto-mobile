//
//  SendRequestViewController.swift
//  kitto-mobile
//
//  Created by Alexander Tarasov on 26/06/2019.
//  Copyright © 2019 Alexander Tarasov. All rights reserved.
//

import UIKit
import iOSDropDown
import Alamofire

class SendRequestViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var houseNumber: UITextField!
    @IBOutlet weak var apartmentNumber: UITextField!
    @IBOutlet weak var street: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var country : DropDown!
    @IBOutlet weak var insuranceTime : DropDown!
    @IBOutlet weak var image : UIImageView!
    
    var selectedTimeId: Int?
    var companyId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "2.png")!)
        country.optionArray = ["Russia", "Uzbekistan", "Italy"]
        insuranceTime.optionArray = ["6 months", "1 year", "2 year"]
        insuranceTime.optionIds = [6, 12, 24]
        insuranceTime.didSelect{(selectedText , index ,id) in
            self.selectedTimeId = id
        }
        let companyImage = DashboardViewController.imageDict[companyId!]
        image.image = companyImage
        apartmentNumber.delegate = self
        houseNumber.delegate = self
        houseNumber.keyboardType = UIKeyboardType.decimalPad
        apartmentNumber.keyboardType = UIKeyboardType.decimalPad
        
        // Do any additional setup after loading the view.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is RequestSuccessViewController {
            let requestSuccessViewController = segue.destination as? RequestSuccessViewController
            var currentDate = Date()
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions.insert(.withFractionalSeconds)
            let currentDateString = formatter.string(from: currentDate)
            currentDate.addTimeInterval(TimeInterval(self.selectedTimeId!*2628000))
            let endInsuranceDate = formatter.string(from: currentDate)
            let headers: HTTPHeaders = [
                "authorization": UserDefaults.standard.object(forKey: "token") as! String,
                "cache-control": "no-cache",
                "postman-token": "a32c5d76-9f36-3b8a-7a42-2374f9b08dc6",
                "Content-Type": "application/json"
            ]
            
            let userDefaults = UserDefaults.standard
            let email = userDefaults.string(forKey: "email")
            
            let parameters: Parameters = [
                "userEmail": email!,
                "propertyType": "house",
                "amount": "1",
                "policyStartDate": currentDateString,
                "policyEndDate": endInsuranceDate,
                "address": [
                    "houseNum": houseNumber.text!,
                                    "apartmentNum": apartmentNumber.text!,
                                    "street": street.text!,
                                    "city": city.text!,
                                    "state": state.text!,
                                    "country": country.text!
                ],
                "companyId": companyId!
//                "userEmail": "alxndrtarasov@gmail.com",
//                "propertyType": "house",
//                "amount": "1",
//                "policyStartDate": "2019-06-26T18:06:08.522Z",
//                "policyEndDate": "2020-06-26T18:06:08.522Z",
//                "address": [
//                    "houseNum": "123",
//                    "apartmentNum": "123",
//                    "street": "IOS",
//                    "city": "IOS",
//                    "state": "IOS",
//                    "country": "IOS"
//                ],
//                "companyId": 1
            ]
            
            
            AF.request("http://35.226.26.159:8080/api/V1/clients/requests", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseJSON {response in
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
