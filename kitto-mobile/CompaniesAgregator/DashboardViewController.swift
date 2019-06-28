//
//  DashboardViewController.swift
//  kitto-mobile
//
//  Created by Alexander Tarasov on 25/06/2019.
//  Copyright © 2019 Alexander Tarasov. All rights reserved.
//

import UIKit
import Alamofire

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    static var list: [NSDictionary] = []
    static var imageDict: Dictionary <Int, UIImage> = Dictionary<Int, UIImage> ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "2.png")!)
        sleep(1)
        let headers: HTTPHeaders = [
            "authorization": "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhbHhuZHJ0YXJhc292QGdtYWlsLmNvbSIsImV4cCI6MTU3MDM2MjY0MH0.cz4CDOJ70ORWLKWbV9712XcHDIi6lUgNKMuYu7V6Y6s6SQSqOGtawh9rjsJJmshnDsA53AoXOZuWnZnYtDkaTA",
            //UserDefaults.standard.object(forKey: "token") as! String,
            "cache-control": "no-cache",
            "postman-token": "a32c5d76-9f36-3b8a-7a42-2374f9b08dc6"
        ]
        _ = AF.request("http://35.226.26.159:8080/api/V1/clients/companies", headers: headers).responseJSON { response in switch response.result {
        case .success(let JSON):
            print("Success with JSON: \(JSON)")
            
            let response = JSON as! NSDictionary
            print(response)
            //example if there is an id
            DashboardViewController.list = response.object(forKey: "data") as! [NSDictionary]
            for company in DashboardViewController.list {
                let companyImageURL = company.object(forKey: "image_url") as! String
                let companyId = company.object(forKey: "companyid") as! Int
                let url = URL(string: companyImageURL)
                let data = try? Data(contentsOf: url!)
                if let imageData = data {
                    DashboardViewController.imageDict[companyId] = UIImage(data: imageData)
                }
            }
            self.tableView.reloadData()
        case .failure(let error):
            print("Request failed with error: \(error)")
            }
        }
        print(DashboardViewController.list)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is CompanyViewController {
            let companyViewController = segue.destination as? CompanyViewController
            let cell = sender as! CompanyTableViewCell
            let indexPath = self.tableView.indexPath(for: cell)
            let company = DashboardViewController.list[indexPath!.row]
            companyViewController!.company = company
        }
    }
    
}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(DashboardViewController.list.count)
        return DashboardViewController.list.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CompanyTableViewCell
        
        cell.companyNameLabel.text = DashboardViewController.list[indexPath.row].object(forKey: "companyname") as? String
        print(cell.companyNameLabel.text!)
        return cell
    }
    
    
}
