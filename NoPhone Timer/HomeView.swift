//
//  HomeView.swift
//  NoPhone Timer
//
//  Created by Alex Longerbeam on 8/13/16.
//  Copyright © 2016 Alex Longerbeam. All rights reserved.
//

import UIKit

class HomeView: UIViewController, RevMobAdsDelegate{
    
    //Labels
    @IBOutlet weak var emerLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var emerButton: UIButton!

    //Components of help button
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var helpLabel: UILabel!
    @IBOutlet weak var helpImage: UIImageView!
    
    //Time select buttons
    @IBOutlet weak var button15: UIButton!
    @IBOutlet weak var button30: UIButton!
    @IBOutlet weak var button45: UIButton!
    @IBOutlet weak var customButton: UIButton!
    @IBOutlet weak var hourButton: UIButton!
    
    //Variables
    var hours: Int = 0
    var minutes: Int = 0
    var completed:Bool = false
    var completedTime:String = ""
    var rewardedVideo: RevMobFullscreen?
    var fullscreen: RevMobFullscreen?
    
    
    
    //*****Button actions*****
    //************************
    @IBAction func addEmergency(_ sender: Any) {
        if rewardedVideo==nil{
            adNotLoaded()
            initializeAd()
        }
        else{
            showLoadedRewardedVideo()
            loadRewardedVideo()
        }
    }
    
    @IBAction func button15(_ sender: AnyObject) {
        hours = 0
        minutes = 15
        timeSelected()
        
    }
    @IBAction func button30(_ sender: AnyObject) {
        hours = 0
        minutes = 30
        timeSelected()
        
    }
    @IBAction func button45(_ sender: AnyObject) {
        hours = 0
        minutes = 45
        timeSelected()
    }
    
    @IBAction func hourButton(_ sender: AnyObject) {
        hours = 1
        minutes = 0
        timeSelected()
    }
    
    
    @IBAction func customButton(_ sender: AnyObject) {
        if DataService.instance.cancels>0{
            performSegue(withIdentifier: "picker", sender: nil)
        }
        else{
            insufficientCancels()
        }
    }
    
    @IBAction func helpButton(_ sender: Any) {
        performSegue(withIdentifier: "help", sender: nil)
    }
    
    
    
    

    
    //****Application Functions****
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if completed{
            completed = false
            completionAlert()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        helpLabel.alpha=1
        helpImage.alpha=1
        if DataService.instance.isFirstTime(){
            DataService.instance.set(value: 3)
            DataService.instance.firstTimePassed()
            animateHelp()
        }
        emerLabel.text = DataService.instance.text()
        totalLabel.text = DataService.instance.completedText()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(noNotification), name: Notification.Name("DeniedNotifications"), object: nil)
        
        UIApplication.shared.statusBarStyle = .lightContent
       
        initializeAd()
        if (RevMobAds.session() != nil){
            self.loadRewardedVideo()
            
        }
        
        }
    
    //*****************************************
    //*********Advertisement handlers**********
    //*****************************************
    func initializeAd(){
        let completionBlock: () -> Void = {
            self.loadRewardedVideo()
            
        }
        let errorBlock: (Error?) -> Void = {error in
            // check the error
            print(error)
        }
        RevMobAds.startSession(withAppID: "586dfb7de3b2a21b72a4b569",
                               withSuccessHandler: completionBlock, andFailHandler: errorBlock)
    }
    
    //*****Rewarded Video*****
    func loadRewardedVideo(){
        rewardedVideo = RevMobAds.session().fullscreen()
        rewardedVideo!.delegate = self
        rewardedVideo!.loadRewardedVideo()
    }
    
    
    func showLoadedRewardedVideo(){
        if(rewardedVideo != nil) {
            rewardedVideo!.showRewardedVideo()
        }
    }
    
    func revmobRewardedVideoDidComplete(_ placementId: String!) {
        if(placementId != nil){
            NSLog("[RevMob Sample App] Rewarded Video of placement Id: \(placementId) completed")
        }
        DataService.instance.addOne()
        emerLabel.text = DataService.instance.text()
    }
    

    
    //****Helper Functions
    
    func timeSelected(){
        if DataService.instance.cancels>0{
            if InternetCheck.isConnection(){
                performSegue(withIdentifier: "middle", sender: nil)
            }
            else{
                performSegue(withIdentifier: "straightToTimer", sender: nil)
            }
        }
        else{
            insufficientCancels()
        }
    }
    
    func animateHelp(){
        UIView.animate(withDuration: 0.8, delay: 0, options: [.repeat, .autoreverse], animations: { () -> Void in
            
            self.helpImage.alpha=0.3
            self.helpLabel.alpha=0.3
            
            })
        
    }
    
    //****Manage Alerts****
    func insufficientCancels(){
        let alert = UIAlertController(title: "Not enough Cancels", message: "You need at least 1 Cancel to start a timer", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func adNotLoaded(){
        let alert = UIAlertController(title: "No Network Connection", message: "Take Phone out of airplane mode \n or try again in a few seconds", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func completionAlert(){
        let alert = UIAlertController(title: "Congratulations!", message: "You just completed a " + completedTime + " timer!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func noNotification(){
        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
            return
        }
        let alert = UIAlertController(title: "Please Go to Settings and Allow Notifications", message: "Notifications are essential for the performance of the app. \n We will only send you notifications when you are using the app", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.cancel, handler: { action in
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        }))
        present(alert, animated: true, completion: nil)
    }

    
    //Passes data into correct view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="middle"{
            if let middleVC = segue.destination as? MiddleView {
                middleVC.hr = hours
                middleVC.min = minutes
            }
        }
        if segue.identifier=="straightToTimer"{
            if let timerVC = segue.destination as? TimerView {
                timerVC.hr = hours
                timerVC.min = minutes
            }
        }
    }
    
    
    
}








