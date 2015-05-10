//
//  ConfirmViewController.swift
//  Lil-Sherpa
//
//  Created by Christine Moy on 5/9/15.
//  Copyright (c) 2015 Christine Moy. All rights reserved.
//

import UIKit
import Parse

class ConfirmViewController: UIViewController {
    
    var scheduleObject : PFObject!
    var activityName : String = ""
    var activityProvider : String!
    var activityTeacher : String!
    var activityDate: String!
    var activityStartAndEndTime: String!
    
    @IBOutlet weak var classNameLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var startEndTimeLabel: UILabel!
    
    override func viewDidAppear(animated: Bool) {
        
        println("actOb is \(scheduleObject)")
        
        //ACTIVITY CLASS NAME
        
        if let actPointer = self.scheduleObject.objectForKey("sActivityName") as? PFObject {
            if let a = actPointer.objectForKey("aName") as? String {
                activityName = a
            }

        }
        println("actName is \(activityName)")
        
        //ACTIVITY PROVIDER & LOCATION NAME
        
        if let actPointerB = self.scheduleObject.objectForKey("sActivityProvider") as? PFObject {
            if let b = actPointerB.objectForKey("apName") as? String {
                activityProvider = b
            }
        }
        
        println("actProv is \(activityProvider)")
        
        //ACTIVITY TEACHER NAME
        
        if let actPointerC = scheduleObject.objectForKey("sTeacher") as? PFObject {
            if let c = actPointerC.objectForKey("tFirstName") as? String {
                if let d = actPointerC.objectForKey("tLastName") as? String {
                    activityTeacher = "\(c) \(d)"
                }
            }
        }
        
        println("teacher is \(activityTeacher)")
        
        //ACTIVITY DATE
        
        if let e = scheduleObject.objectForKey("sDate") as? NSDate {
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "EEEE, MMMM d"
            activityDate = dateFormatter.stringFromDate(e)
        }
        
        println(activityDate)
        
        //ACTIVITY START AND END TIME (IN LOCAL TIME)
        
        if let f = scheduleObject.objectForKey("sActivityName") as? PFObject {
        
            if let date2 = scheduleObject.objectForKey("sDate") as? NSDate {
        
                if let duration = f.objectForKey("aDuration") as? String {
        
                    var dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "h:mm a"
                    let timeZone = NSTimeZone(name: "EDT")
                    dateFormatter.timeZone = timeZone
                    var durationInt = duration.toInt()
                    var timeIntervalToAdd = NSTimeInterval(durationInt! * 60)
                    var endTime = date2.dateByAddingTimeInterval(timeIntervalToAdd)
                    var endTimeString = dateFormatter.stringFromDate(endTime)
                    var startTimeString = dateFormatter.stringFromDate(date2)
                    activityStartAndEndTime = "\(startTimeString) - \(endTimeString)"
                }
            }
        }
        
        println("activity starts \(activityStartAndEndTime)")
        
        //POPULATING THE LABELS
        classNameLabel.text = activityName
        locationLabel.text = activityProvider
        dateLabel.text = activityDate
        startEndTimeLabel.text = activityStartAndEndTime
        
    }
        
    @IBAction func pressedConfirmRes(sender: UIButton) {
    }
    
    @IBAction func pressedCancel(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
