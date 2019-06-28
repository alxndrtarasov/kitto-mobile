//
//  ClaimsListViewController.swift
//  kitto-mobile
//
//  Created by Alexander Tarasov on 27/06/2019.
//  Copyright © 2019 Alexander Tarasov. All rights reserved.
//

import UIKit
import Alamofire
import ChameleonFramework
class ClaimsListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var claimsList: [NSDictionary] = []
    private let refreshControl = UIRefreshControl()
    
    @objc private func fetchClaimsData(_ sender: Any) {
        fetchClaimsData()
    }
    
    func fetchClaimsData() {
        let headers: HTTPHeaders = [
            "authorization": UserDefaults.standard.object(forKey: "token") as! String,
            "cache-control": "no-cache",
            "postman-token": "a32c5d76-9f36-3b8a-7a42-2374f9b08dc6"
        ]
        let parameters: Parameters = [
            "email": UserDefaults.standard.string(forKey: "email")!
        ]
        
        _ = AF.request("http://35.226.26.159:8080/api/V1/clients/claims", method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: headers).responseJSON { response in switch response.result {
        case .success(let JSON):
            print("Success with JSON: \(JSON)")
            
            let response = JSON as!NSDictionary
            print(response)
            //example if there is an id
            self.claimsList = response.object(forKey: "data") as! [NSDictionary]
            self.tableView.reloadData()
        case .failure(let error):
            print("Request failed with error: \(error)")
            }
        }
        print(self.claimsList)
        self.refreshControl.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "5.png")!)
        fetchClaimsData()
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(fetchClaimsData(_:)), for: .valueChanged)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ClaimViewController {
            let claimViewController = segue.destination as? ClaimViewController
            let cell = sender as! RequestTableViewCell
            
            let indexPath = self.tableView.indexPath(for: cell)
            let claim = self.claimsList[indexPath!.row]
            
            let claimNumber = claim.object(forKey: "claimid") as! Int
            let claimDescription = claim.object(forKey: "description") as! String
            
            let request = claim.object(forKey: "insurance") as! NSDictionary
            let requestNumber = request.object(forKey: "insurancerequestid") as! Int
            let propertyType = request.object(forKey: "propertytype") as! String
            let status = claim.object(forKey: "status") as! String
            
            let addressObj = request.object(forKey: "address") as!NSDictionary
            let apartment = addressObj.object(forKey: "apartment_num") as! String
            let street = addressObj.object(forKey: "street") as! String
            let city = addressObj.object(forKey: "city") as! String
            let country = addressObj.object(forKey: "country") as! String
            let address = [street, apartment, city, country].joined(separator: ", ")
            
            let companyObj = request.object(forKey: "company") as!NSDictionary
            let companyId = companyObj.object(forKey: "companyid") as! Int
            let companyName = companyObj.object(forKey: "companyname") as! String
            
            claimViewController!.descriptionText = claimDescription
            claimViewController!.claimNumber = claimNumber
            claimViewController!.requestNumber = requestNumber
            claimViewController!.propertyType = propertyType
            claimViewController!.address = address
            claimViewController!.status = status
            claimViewController!.companyId = companyId
            claimViewController!.companyName = companyName
            claimViewController!.company = companyObj
        }
    }
    
}

extension ClaimsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(claimsList.count)
        return claimsList.count
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RequestTableViewCell
        let claim = claimsList[indexPath.row]
        let claimNumber = claim.object(forKey: "claimid") as! Int
        let status = claim.object(forKey: "status") as! String
        
        let request = claim.object(forKey: "insurance") as! NSDictionary
        let propertyType = request.object(forKey: "propertytype") as! String
        let address = request.object(forKey: "address") as!NSDictionary
        let city = address.object(forKey: "city") as! String
        
        
        cell.requestNameLabel.text = "Claim #" + String(claimNumber) + " for " + propertyType + " in " + city
        cell.backgroundColor = decideColor(status: status, frame: cell.frame)
        return cell
    }
    
    
}
