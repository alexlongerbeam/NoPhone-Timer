//
//  MiddleView.swift
//  NoPhone Timer
//
//  Created by Alex Longerbeam on 12/19/16.
//  Copyright © 2016 Alex Longerbeam. All rights reserved.
//

import UIKit

class MiddleView: UIViewController {
    
    //****Buttons****
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var contButton: UIButton!
    
    //******Button actions******
    @IBAction func back(_ sender: Any) {
        performSegue(withIdentifier: "backHome", sender: nil)
    }
    
    @IBAction func contButton(_ sender: AnyObject) {
        //check()
        if (InternetCheck.isConnection()){
            let alert = UIAlertController(title: "Error", message: "Phone is not in Airplane Mode", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        else{
            performSegue(withIdentifier: "timer", sender: nil)
        }
    }
    
    //****Variables
    var hr: Int = 0
    var min: Int = 0
    var circleTimer = Timer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
    
        if segue.identifier=="timer"{
            if let timerVC = segue.destination as? TimerView {
                timerVC.hr = hr
                timerVC.min = min
            }
        }
    }
}
