//
//  TimerView.swift
//  TimerStoryboard
//
//  Created by Alex Longerbeam on 12/12/16.
//  Copyright © 2016 Alex Longerbeam. All rights reserved.
//

import UIKit

class TimerView: UIViewController  {

    //Outlets related to Timer Display
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet var longPress: UILongPressGestureRecognizer!
    
    //Outlets dealing with canceling
    @IBOutlet weak var cancelLabel: UILabel!
    @IBOutlet weak var pressMessage: UILabel!
    @IBOutlet weak var bar: UIView!
    
    //Outlets dealing with airplan mode
    @IBOutlet weak var airplaneCancel: UIButton!
    @IBOutlet weak var AirplaneAlert: UIView!
    
   //Handles short tap on timer label
    @IBAction func timerButton(_ sender: AnyObject) {
        showForSec()
    }
    
    //Handles cancel button on airplane mode alert
    @IBAction func airplaneCancel(_ sender: Any) {
        homeScreen() 
    }
    
    
    //Handles long press on timer label to cancel timer
    @IBAction func longPress(_ sender: AnyObject) {
        if sender.state == .ended {
            holdTimer.invalidate()
            stopCancel()
            resumeTimer()
            
        }
        else if sender.state == .began {
            labelTimer.invalidate()
            showLabel()
            pauseTimer()
            holdTimer = Timer.scheduledTimer(timeInterval: 3.25, target: self, selector: #selector(TimerView.checkCancel), userInfo: nil, repeats: false)
            cancel()
        }
    }
    
    //Timer related variables
    var hr: Int = 0
    var min: Int = 0
    var seconds:Int = 0
    var timerObject = TimerController()
    
    //Timers
    var timer = Timer()
    var notificationTimer = Timer()
    var holdTimer = Timer()
    var labelTimer = Timer()
    var backgroundTimer = Timer()
    var airplaneTimer = Timer()
    
    //Booleans
    var timerRunning: Bool = false
    var actualBackground:Bool = false //if app is left for >1.5 sec
    var completed:Bool = false //if timer is completed
    
    
    
    //***************************************
    //******Functions controlling timer******
    //***************************************
    
    func startTimer(){
        timerLabel.text = timerObject.display()
        timerRunning = true
        UIApplication.shared.isIdleTimerDisabled = true
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(TimerView.runTimer), userInfo: nil, repeats: true)
        
    }
    func pauseTimer(){
        timer.invalidate()
        //timerRunning = false
    }
    
    func resumeTimer(){
        if !timer.isValid{
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(TimerView.runTimer), userInfo: nil, repeats: true)
        }
    }
    
    func runTimer(){
        if timerObject.timerGood{
            timerObject.countdown()
            timerLabel.text = timerObject.display()
            if InternetCheck.isConnection(){
                airplaneOff()
            }
        }
        else{
            completed = true
            homeScreen()
        }
    }

    
    //**************************************************
    //******Functions dealing with canceling timer******
    //**************************************************
    func cancel(){
        let endWidth = cancelLabel.frame.width
        let x = bar.frame.minX
        let y = bar.frame.minY
        let h = bar.frame.height
        cancelLabel.isHidden = false
        bar.isHidden = false
        UIView.animate(withDuration: 3.0, animations: { () -> Void in
            self.bar.frame = CGRect(x: x, y: y, width: endWidth, height: h)
            
        }, completion: nil)
    }
    
    func stopCancel(){
        let x = bar.frame.minX
        let y = bar.frame.minY
        let h = bar.frame.height
        let startWidth:CGFloat = 2.0
        bar.isHidden = true
        cancelLabel.isHidden = true
        hideLabel()
        self.view.layer.removeAllAnimations()
        self.bar.frame = CGRect(x: x, y: y, width: startWidth, height: h)
    }
    
    //Show "hold to cancel" label for a second
    func showForSec(){
        showLabel()
        labelTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(TimerView.hideLabel), userInfo: nil, repeats: false)
    }
    
    func showLabel(){
        pressMessage.isHidden = false
    }
    func hideLabel(){
        pressMessage.isHidden = true
    }

    func checkCancel(){
        pauseTimer()
        let alert = UIAlertController(title: "Are you sure you want to cancel?", message: "You will be deducted a Cancel", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {action in
            DataService.instance.subOne()
            self.homeScreen()
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: {action in
            self.stopCancel()
            alert.dismiss(animated: true, completion: nil)
            self.resumeTimer()
        }))
        present(alert, animated: true, completion:nil)
        
    }
    
    func homeScreen(){
        timer.invalidate()
        timerRunning = false
        hideLabel()
        UIApplication.shared.isIdleTimerDisabled = false
        performSegue(withIdentifier: "homeScreen", sender: nil)
    }
    
    //**************************************
    //******Dealing with airplane mode******
    //**************************************
    func airplaneOff(){
        pauseTimer()
        DataService.instance.subOne()
        AirplaneAlert.layer.cornerRadius = 8.0
        AirplaneAlert.clipsToBounds = true
        AirplaneAlert.isHidden = false
        airplaneTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(TimerView.airplaneOn), userInfo: nil, repeats: true)
    }
    
    func airplaneOn(){
        if !InternetCheck.isConnection(){
            airplaneTimer.invalidate()
            AirplaneAlert.isHidden = true
            resumeTimer()
        }
    }
    
    

    //*************************************
    //********Application Functions********
    //*************************************
    override func viewDidLoad() {
        super.viewDidLoad()

        //add observer for application entering background, entering foreground, and terminating
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(background), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        notificationCenter.addObserver(self, selector: #selector(foreground), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(appQuit), name: Notification.Name.UIApplicationWillTerminate, object: nil)
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        
    }
    
    //Initialize timer components and start it
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timerObject.setTime(hr, mins: min)
        timerLabel.text = timerObject.display()
        if !timerRunning{
            startTimer()
        }
    }
    

    func background(notification : NSNotification) {
        if timerRunning{
            pauseTimer()
            notificationTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(TimerView.sendNotification), userInfo: nil, repeats: true)
            backgroundTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(TimerView.longBackground), userInfo: nil, repeats: false)
        }
        
    }
    
    func foreground(notification : NSNotification){
        if timerRunning{
            notificationTimer.invalidate()
            backgroundTimer.invalidate()
            if actualBackground{
                DataService.instance.subOne()
                actualBackground = false
                let alert = UIAlertController(title: "You left the app!", message: "You have been deducted a Cancel", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {action in
                    if self.AirplaneAlert.isHidden{
                        self.resumeTimer()
                    }
                }))
                present(alert, animated: true, completion: nil)
            }
            else{
                if self.AirplaneAlert.isHidden{
                    resumeTimer()
                }
            }
        }
    }
    
    //***********************************************************
    //********Handle Notifications when app in background********
    //***********************************************************
    func sendNotification(){
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        // Initialize Date components
        var d = DateComponents()
        d.year = year
        d.month = month
        d.day = day
        d.hour = hour
        d.minute = minutes
        d.second = seconds + 1
        
        // Get NSDate given the above date components
        let timeForNot = NSCalendar(identifier: NSCalendar.Identifier.gregorian)?.date(from: d)
        
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        delegate?.scheduleNotification(at: timeForNot!)
    }
    

    
    //***************************************
    //********Miscellaneous functions********
    //***************************************
    //Selector for timer to see if app was in background for 1.5 sec
    func longBackground(){
        actualBackground = true
    }

    //Subtract a cancel if the app is terminated while a timer is running
    func appQuit(){
        if timerRunning{
            DataService.instance.subOne()
        }
    }
    
    //Pass data to home screen ViewController regarding amount of time for a timer and whether or not it was completed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="homeScreen"{
            if let homeVC = segue.destination as? HomeView {
                if completed{
                    homeVC.completed = true
                    homeVC.completedTime = timerObject.completionText
                    DataService.instance.addMinutes(mins: (hr*60+min))
                }
                
                
            }
        }
    }

}
