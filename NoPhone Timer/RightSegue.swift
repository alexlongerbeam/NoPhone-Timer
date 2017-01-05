//
//  RightSegue.swift
//  NoPhone Timer
//
//  Created by Alex Longerbeam on 1/2/17.
//  Copyright © 2017 Alex Longerbeam. All rights reserved.
//

import UIKit

class RightSegue: UIStoryboardSegue {

    
    override func perform() {
        
        let firstVCView = self.source.view as UIView!
        let secondVCView = self.destination.view as UIView!
        
        let screenHeight = UIScreen.main.bounds.size.height
        let screenWidth = UIScreen.main.bounds.size.width
        
        
         secondVCView?.frame = CGRect(x: screenWidth, y: 0.0, width: screenWidth, height: screenHeight)
        
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(secondVCView!,belowSubview: firstVCView!)
        
        // Animate the transition.
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            firstVCView?.frame = ((firstVCView?.frame)?.offsetBy(dx: -screenWidth, dy: 0.0))!
            secondVCView?.frame = ((secondVCView?.frame)!.offsetBy(dx: -screenWidth, dy: 0.0))
            
        }) { (Finished) -> Void in
            
            
            self.source.present(self.destination as UIViewController, animated: false, completion: nil)
        }
    }

}
