//
//  TimerSegue.swift
//  NoPhone Timer
//
//  Created by Alex Longerbeam on 12/19/16.
//  Copyright © 2016 Alex Longerbeam. All rights reserved.
//

import UIKit

class TimerSegue: UIStoryboardSegue {

    
    override func perform() {
        let home = source.view as UIView!
        let timer = destination.view as UIView!
        
        timer?.transform = (timer?.transform)!.scaledBy(x: 0.001, y: 0.001)
        
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(timer!, aboveSubview: home!)
        

        
        UIView.animate(withDuration: 0.75, animations: { () -> Void in
            home?.transform = (home?.transform)!.scaledBy(x: 10, y: 10)
            timer?.transform = CGAffineTransform.identity
            
            }, completion: { (Finished) -> Void in
                
                home?.transform = CGAffineTransform.identity
                self.source.present(self.destination as UIViewController, animated: false, completion: nil)
        })
        
    }
}

