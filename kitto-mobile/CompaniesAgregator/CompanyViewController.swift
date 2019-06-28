//
//  CompanyViewController.swift
//  kitto-mobile
//
//  Created by Alexander Tarasov on 25/06/2019.
//  Copyright © 2019 Alexander Tarasov. All rights reserved.
//

import UIKit

class CompanyViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var sendButton: UIButton!
    
    var company:NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let companyName = company!.object(forKey: "companyname") as! String
        let companyDescription = company!.object(forKey: "description") as! String
        let companyId = company!.object(forKey: "companyid") as! Int
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "2.png")!)
        titleLabel.text = companyName
        descriptionLabel.text = companyDescription
        image.image = DashboardViewController.imageDict[companyId]
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SendRequestViewController {
            let companyId = company!.object(forKey: "companyid") as! Int
            let sendRequestViewController = segue.destination as? SendRequestViewController
            sendRequestViewController?.companyId = companyId
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
