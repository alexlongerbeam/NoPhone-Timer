//
//  DataService.swift
//  NoPhone Timer
//
//  Created by Alex Longerbeam on 12/26/16.
//  Copyright © 2016 Alex Longerbeam. All rights reserved.
//

import Foundation

class DataService{
    static let instance = DataService()
    
    private var _cancels:Int = 0
    private var _completedMins:Int = 0
    private var _oppFirstTime:Bool = false
    
    var cancels:Int{
        load()
        return _cancels
    }
    
    var completedMins:Int{
        load()
        return _completedMins
    }
    
    func text()->String{
        load()
        if _cancels==1{
            return "You have 1 Cancel"
        }
        else{
            return "You have \(_cancels) Cancels"
        }
    }
    
    func completedText()->String{
        load()
        var str = "Total NoPhone time spent:\n"
        let hrs = _completedMins/60
        let mins = _completedMins%60
        
        
        if mins==0 && hrs==0{
            str.append("0 minutes")
        }
            
        else if mins != 0 {
            switch hrs {
            case 0:
                break
            case 1:
                str.append("1 hour and ")
            default:
                str.append("\(hrs) hours and ")
            }
            
            if mins==1{
                str.append("1 minute")
            }
            else{
                str.append("\(mins) minutes")
            }
        }
            
            
        else{
            switch hrs {
            case 0:
                break
            case 1:
                str.append("1 hour")
            default:
                str.append("\(hrs) hours")
            }
            
        }
        
        return str
    }
    
    func save(){
        UserDefaults.standard.set(_cancels, forKey: "cancels")
        UserDefaults.standard.set(_oppFirstTime, forKey: "first")
        UserDefaults.standard.set(_completedMins, forKey: "completed")
        
    }
    
    func load(){
        if let storedValue = UserDefaults.standard.integer(forKey: "cancels") as Int?{
            _cancels = storedValue
        }
        if let storedBool = UserDefaults.standard.bool(forKey: "first") as Bool?{
            _oppFirstTime = storedBool
        }
        if let storedComps = UserDefaults.standard.integer(forKey: "completed") as Int?{
            _completedMins = storedComps
        }
        
    }
    
    func set(value:Int){
        _cancels = value
        save()
    }
    
    func addOne(){
        _cancels+=1
        save()
    }
    func subOne(){
        _cancels-=1
        save()
    }
    
    func isFirstTime()->Bool{
        load()
        return !_oppFirstTime
    }
    
    func firstTimePassed(){
        _oppFirstTime = true
        save()
    }
    
    func addMinutes(mins:Int){
        _completedMins+=mins
        save()
    }
    
}
