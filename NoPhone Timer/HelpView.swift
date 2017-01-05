//
//  HelpView.swift
//  NoPhone Timer
//
//  Created by Alex Longerbeam on 1/2/17.
//  Copyright © 2017 Alex Longerbeam. All rights reserved.
//

import UIKit

class HelpView: UIViewController {

    @IBOutlet weak var back: UIButton!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var helpText: UILabel!
    
    
    
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "leftBack", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = .default
        helpText.sizeToFit()
        
        //helpText.numberOfLines = 0
        
        
        
        //containerView.sizeToFit()
    }
}
