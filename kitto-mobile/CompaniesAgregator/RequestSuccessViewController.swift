//
//  RequestSuccessViewController.swift
//  kitto-mobile
//
//  Created by Alexander Tarasov on 26/06/2019.
//  Copyright © 2019 Alexander Tarasov. All rights reserved.
//

import UIKit
import Lottie
class RequestSuccessViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var animationView: AnimationView!
    
    var animationPath = ""
    var labelText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let likeAnimation = Animation.named(animationPath, bundle: Bundle.main)
        animationView.animation = likeAnimation
        animationView.play();
        label.text = labelText
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
