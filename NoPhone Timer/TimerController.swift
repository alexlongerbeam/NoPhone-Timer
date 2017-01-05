//
//  TimerController.swift
//  NoPhone Timer
//
//  Created by Alex Longerbeam on 9/5/16.
//  Copyright © 2016 Alex Longerbeam. All rights reserved.
//

import Foundation

class TimerController{
    
    
    
    fileprivate var hours: Int = 0
    fileprivate var minutes: Int = 0
    fileprivate var seconds: Int = 0
    
    var completionText:String = ""
   
    

    
    var timerGood: Bool{
        get{
            if seconds != 0 || minutes != 0 || hours != 0{
                return true
            }
            else{
                return false
            }
        }
    }
    
    func setTime(_ hrs: Int, mins: Int){
        hours = hrs
        minutes = mins
        seconds = 0
        
        if (hours==0){
            completionText = "\(minutes) minute"
        }
        else if minutes==0{
            completionText = "\(hours) hour"
        }
        else{
            completionText = "\(hours) hour and \(minutes) minute"
        }
    }
    
    func countdown(){
        seconds-=1
        if seconds<0{
            seconds = 59
            minutes -= 1
        }
        if minutes<0{
            minutes = 59
            hours -= 1
        }
        
    }
    
    func display() -> String{
        if hours != 0{
            return ("\(hours):" + minuteDisplay() + secondsDisplay())
        }
        else{
            return (minuteDisplay() + secondsDisplay())
        }
        
    }
    
    
    func minuteDisplay() -> String{
        if minutes<10{
            return "0\(minutes):"
        }
        else{
            return "\(minutes):"
        }
    }
    
    func secondsDisplay() -> String{
        if seconds<10{
            return "0\(seconds)"
        }
        else{
            return "\(seconds)"
        }
    }
    
}
