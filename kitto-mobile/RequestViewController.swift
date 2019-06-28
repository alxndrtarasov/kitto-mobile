//
//  RequestViewController.swift
//  kitto-mobile
//
//  Created by Alexander Tarasov on 27/06/2019.
//  Copyright © 2019 Alexander Tarasov. All rights reserved.
//

import UIKit
import ChameleonFramework
class RequestViewController: UIViewController {
    @IBOutlet weak var requestNumberLabel: UILabel!
    @IBOutlet weak var propertyTypeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var policyStartsLabel: UILabel!
    @IBOutlet weak var policyEndsLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var toCompanyButton: UIButton!
    @IBOutlet weak var claimButton: UIButton!
    
    
    var requestNumber: Int!
    var propertyType: String?
    var address: String?
    var policyStarts: String?
    var policyEnds: String?
    var status: String?
    var companyId: Int?
    var companyName: String?
    var company:NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = RequestsViewController.sharedColor
        requestNumberLabel.text = String(requestNumber)
        propertyTypeLabel.text = propertyType
        addressLabel.text = address
        policyStartsLabel.text = policyStarts
        policyEndsLabel.text = policyEnds
        statusLabel.text = status
        statusLabel.backgroundColor = decideColor(status: status!, frame: statusLabel.frame)
        toCompanyButton.setTitle(companyName, for: .normal)
        if status != "accepted" {
            claimButton.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
    
    func decideColor(status: String, frame: CGRect) -> UIColor {
        switch status.lowercased() {
        case "pending": return GradientColor(UIGradientStyle.topToBottom, frame:frame, colors: [UIColor.orange, UIColor.yellow]);
        case "rejected": return GradientColor(UIGradientStyle.topToBottom, frame:frame, colors: [UIColor.red, UIColor.orange]);
        case "accepted": return GradientColor(UIGradientStyle.topToBottom, frame:frame, colors: [UIColor.green, UIColor.yellow]);
        default:
            return UIColor.yellow
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is CompanyViewController {
            let companyViewController = segue.destination as? CompanyViewController
            companyViewController!.company = company
        }
        
        if segue.destination is SendClaimViewController {
            let claimViewController = segue.destination as! SendClaimViewController
            claimViewController.itemDescription = "Insurance request #" + String(self.requestNumber) + " for " + propertyType! + " in " + address!
            claimViewController.requestId = requestNumber
//                  + " in " + address
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
