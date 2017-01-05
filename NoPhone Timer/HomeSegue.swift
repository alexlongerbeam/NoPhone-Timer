//
//  HomeSegue.swift
//  NoPhone Timer
//
//  Created by Alex Longerbeam on 12/19/16.
//  Copyright © 2016 Alex Longerbeam. All rights reserved.
//

import UIKit

class HomeSegue: UIStoryboardSegue {

    
    
    override func perform() {
        var timer = source.view as UIView!
        var home = destination.view as UIView!
        
        home?.transform = (home?.transform)!.scaledBy(x: 10, y: 10)
        
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(home!, belowSubview: timer!)
        

        
        UIView.animate(withDuration: 0.75, animations: { () -> Void in
            timer?.transform = (timer?.transform)!.scaledBy(x: 0.001, y: 0.001)
            home?.transform = CGAffineTransform.identity
            
            }, completion: { (Finished) -> Void in
                
                timer?.transform = CGAffineTransform.identity
                self.source.present(self.destination as UIViewController, animated: false, completion: nil)
        })
        
    }
}


