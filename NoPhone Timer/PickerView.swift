//
//  PickerView.swift
//  TimerStoryboard
//
//  Created by Alex Longerbeam on 12/12/16.
//  Copyright © 2016 Alex Longerbeam. All rights reserved.
//

import UIKit
import Foundation

class PickerView:UIViewController, UIPickerViewDataSource, UIPickerViewDelegate
{

   
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var goButton: UIButton!
    
    @IBOutlet weak var timerSelector: UIPickerView!
   
    @IBAction func goButton(_ sender: AnyObject) {
        if hour != 0 || minute != 0 {
            if InternetCheck.isConnection(){
                performSegue(withIdentifier: "pickerTimer", sender: nil)
            }
            else{
                performSegue(withIdentifier: "pickerStraightTimer", sender: nil)
            }
        }
    }
    
    
    @IBAction func backButton(_ sender: AnyObject) {
        //performSegue(withIdentifier: "backButton", sender: nil)
        dismiss(animated: true, completion: nil)
    }
    var times: [[String]] = [[],[],[],[]]
    var hour:Int = 0
    var minute:Int = 0
    
    
    func initPicker(){
        var minutes:[String] = [String]()
        var hours:[String] = [String]()
        
        var num = 0
        for x in 0...23{
            hours.append(String(num))
            num+=1
        }
        
        num = 0
        for x in 0...59{
            
            minutes.append(String(num))
            num+=1
        }
        let hrLabel = ["hours"]
        let minLabel = ["minutes"]
        times[0] = hours
        times[1] = hrLabel
        times[2] = minutes
        times[3] = minLabel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.timerSelector.delegate = self
        self.timerSelector.dataSource = self
    
        UIApplication.shared.statusBarStyle = .lightContent
        
        initPicker()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return times.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       // print (String(component) + ":  " + String (times[component].count))
        return times[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return times[component][row]
    }
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return times[component][row]
//    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 1:
            return 80
        case 3:
            return 100
        default:
            return 40
        }
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = times[component][row]
        let str = NSMutableAttributedString(string:titleData)
        let strColor = UIColor.white
        let originalNSString = str.string as NSString
        let range = originalNSString.range(of: titleData)
        str.addAttribute(NSForegroundColorAttributeName, value: strColor, range: range)

        
        
        
        return str
    }
    


   
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let firstComponent = times[0][pickerView.selectedRow(inComponent: 0)]
        
        
        let secondComponent = times[2][pickerView.selectedRow(inComponent: 2)]
        
        hour = Int(firstComponent)!
        minute = Int(secondComponent)!
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="pickerTimer"{
            if let middleVC = segue.destination as? MiddleView {
                middleVC.hr = hour
                middleVC.min = minute
            }
        }
        if segue.identifier=="pickerStraightTimer"{
            if let timerVC = segue.destination as? TimerView {
                timerVC.hr = hour
                timerVC.min = minute
            }
        }
    }
}
