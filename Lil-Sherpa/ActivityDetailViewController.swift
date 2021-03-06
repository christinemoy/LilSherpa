//
//  ActivityDetailViewController.swift
//  
//
//  Created by Christine Moy on 4/26/15.
//
//
import Parse
import UIKit

class ActivityDetailViewController: UIViewController {
    
    var scheduleObject : PFObject!
    
    var arrayOfAttendanceObjects = [PFObject]()
    
    var firstMatchAttendanceObject : PFObject!
    
    var firstMatchAttendanceObjectId : String!
    
    var registrationStatus = String()
    
    var confirmationPageId = "confirmationpage"

    @IBOutlet weak var activityNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set up scroller size and color
        let scroller = UIScrollView()
        scroller.contentSize = CGSize(width: self.view.frame.width, height: 1050)
        scroller.backgroundColor = UIColor.whiteColor()
        scroller.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        //add scroller to self subview
        self.view.addSubview(scroller)
        
        // add scroller constraints
        let scrollTop = NSLayoutConstraint(
            item: scroller,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1.0,
            constant: 0
        )
        
        let scrollLeading = NSLayoutConstraint(
            item: scroller,
            attribute: NSLayoutAttribute.Leading,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Leading,
            multiplier: 1.0,
            constant: 0
        )
        
        let scrollTrailing = NSLayoutConstraint(
            item: scroller,
            attribute: NSLayoutAttribute.Trailing,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Trailing,
            multiplier: 1.0,
            constant: 0
        )
        
        let scrollBottom = NSLayoutConstraint(
            item: scroller,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1.0,
            constant: 0
        )
        
        self.view.addConstraints([scrollTop, scrollLeading, scrollTrailing, scrollBottom])
        
        // add image
        let imageName = "kidville.jpg"
        let actPic = UIImage(named: imageName)
        let actPicView = UIImageView(image: actPic)
        actPicView.frame = CGRect(x: 0, y: 0, width: 397, height: 397)
        actPicView.contentMode = UIViewContentMode.ScaleAspectFit
        actPicView.setTranslatesAutoresizingMaskIntoConstraints(false)
        //NEED TO CONVERT THIS PICTURE TO A PICTURE ON PARSE; NEED TO FIGURE OUT HOW TO INPUT PICTURES OF DIFFERENT SIZES HERE
        
        // add imageView to scroller
        scroller.addSubview(actPicView)
        
        // add imageView constraints
        let imageViewTop = NSLayoutConstraint(
            item: actPicView,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: scroller,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1.0,
            constant: 0
        )
        
        scroller.addConstraint(imageViewTop)
        

        
        // add class detail text overlay on imageView
        
        let classNameLabel = UILabel()
        actPicView.addSubview(classNameLabel)
        classNameLabel.frame = CGRect(x: self.view.frame.width/2, y: actPicView.frame.height/3, width: self.view.frame.width*0.8, height: 30)
        classNameLabel.center = CGPointMake(self.view.frame.width/2, actPicView.frame.height/3)
        classNameLabel.textAlignment = NSTextAlignment.Center
        classNameLabel.font = UIFont.boldSystemFontOfSize(25)
        classNameLabel.textColor = UIColor.whiteColor()
        
        let classLocationLabel = UILabel()
        actPicView.addSubview(classLocationLabel)
        classLocationLabel.frame = CGRect(x: self.view.frame.width/2, y: actPicView.frame.height/2, width: self.view.frame.width*0.8, height: 30)
        classLocationLabel.center = CGPointMake(self.view.frame.width/2, actPicView.frame.height/2)
        classLocationLabel.textAlignment = NSTextAlignment.Center
        classLocationLabel.font = UIFont.boldSystemFontOfSize(20)
        classLocationLabel.textColor = UIColor.whiteColor()
        
        let classTeacherLabel = UILabel()
        actPicView.addSubview(classTeacherLabel)
        classTeacherLabel.frame = CGRect(x: self.view.frame.width/2, y: (actPicView.frame.height/3)*2, width: 150, height: 30)
        classTeacherLabel.center = CGPointMake(self.view.frame.width/2, (actPicView.frame.height/3)*2)
        classTeacherLabel.textAlignment = NSTextAlignment.Center
        classTeacherLabel.font = UIFont.boldSystemFontOfSize(15)
        classTeacherLabel.textColor = UIColor.whiteColor()

        let classDateLabel = UILabel()
        actPicView.addSubview(classDateLabel)
        classDateLabel.frame = CGRect(x: self.view.frame.width/2, y: (actPicView.frame.height/3)*2.2, width: 150, height: 30)
        classDateLabel.center = CGPointMake(self.view.frame.width/2, (actPicView.frame.height/3)*2.2)
        classDateLabel.textAlignment = NSTextAlignment.Center
        classDateLabel.font = UIFont.boldSystemFontOfSize(15)
        classDateLabel.textColor = UIColor.whiteColor()
        
        let classTimeLabel = UILabel()
        actPicView.addSubview(classTimeLabel)
        classTimeLabel.frame = CGRect(x: self.view.frame.width/2, y: (actPicView.frame.height/3)*2.4, width: 150, height: 30)
        classTimeLabel.center = CGPointMake(self.view.frame.width/2, (actPicView.frame.height/3)*2.4)
        classTimeLabel.textAlignment = NSTextAlignment.Center
        classTimeLabel.font = UIFont.boldSystemFontOfSize(15)
        classTimeLabel.textColor = UIColor.whiteColor()
        
        
        // pull PFObject detail
//        var scheduleQuery = PFQuery(className:"Schedule")
//        scheduleQuery.includeKey("sActivityName")
//        scheduleQuery.includeKey("sActivityProvider")
//        scheduleQuery.includeKey("sTeacher")
//        scheduleQuery.getObjectInBackgroundWithId("\(scheduleObjectId)") {
//            (actvy: PFObject?, error: NSError?) -> Void in
//            if error == nil && actvy != nil {
//                
//                self.scheduleObject = actvy as PFObject?
        
                //ACTIVITY CLASS NAME
                
        if let actPointer = scheduleObject.objectForKey("sActivityName") as? PFObject {
            if let a = actPointer.objectForKey("aName") as? String {
                classNameLabel.text = a
            }
        }
            
            //ACTIVITY PROVIDER & LOCATION NAME
        if let actPointer = scheduleObject.objectForKey("sActivityProvider") as? PFObject {
            if let a = actPointer.objectForKey("apName") as? String {
                classLocationLabel.text = a
            }
        }
            
            //ACTIVITY TEACHER NAME
            
        if let actPointer = scheduleObject.objectForKey("sTeacher") as? PFObject {
            if let a = actPointer.objectForKey("tFirstName") as? String {
                if let b = actPointer.objectForKey("tLastName") as? String {
                    classTeacherLabel.text = "\(a) \(b)"
                }
            }
        }
            
            //ACTIVITY DATE
            
        if let a = scheduleObject.objectForKey("sDate") as? NSDate {
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "EEEE, MMMM d"
            classDateLabel.text = dateFormatter.stringFromDate(a)
        }

            
            //ACTIVITY START AND END TIME (IN LOCAL TIME)
            
        if let a = scheduleObject.objectForKey("sActivityName") as? PFObject {

            if let date = scheduleObject.objectForKey("sDate") as? NSDate {
                
                if let duration = a.objectForKey("aDuration") as? String {
            
                    var dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "h:mm a"
                    let timeZone = NSTimeZone(name: "EDT")
                    dateFormatter.timeZone = timeZone
                    var durationInt = duration.toInt()
                    var timeIntervalToAdd = NSTimeInterval(durationInt! * 60)
                    var endTime = date.dateByAddingTimeInterval(timeIntervalToAdd)
                    var endTimeString = dateFormatter.stringFromDate(endTime)
                    var startTimeString = dateFormatter.stringFromDate(date)
                    classTimeLabel.text = "\(startTimeString) - \(endTimeString)"
                    
                }
            }
        }
                
                //ACTIVITY AGE GROUP
                
                //ACTIVITY CLASS CATEGORY
                
                //ACTIVITY CLASS ABOUT
                
                //ACTIIVITY PROVIDER ADDRESS
                
                //ACTIVITY PROVIDER ABOUT
                
//            } else {
//                println(error)
//            }
//        }
        
        //get attendance object
        var attendanceObjectQuery = PFQuery(className: "Attendance")
        attendanceObjectQuery.whereKey("scheduleIdPointer", equalTo: scheduleObject)
        attendanceObjectQuery.whereKey("userIdPointer", equalTo: PFUser.currentUser()!)
        
        attendanceObjectQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                if let unwrappedObjects = objects as? [PFObject] {
                    
                    self.arrayOfAttendanceObjects = unwrappedObjects
                    println(self.arrayOfAttendanceObjects)
                    
                    if self.arrayOfAttendanceObjects.isEmpty {
                        // do nothing
                    } else {
                        self.firstMatchAttendanceObject = self.arrayOfAttendanceObjects[0]
                        self.firstMatchAttendanceObjectId = self.firstMatchAttendanceObject.objectId
                        self.registrationStatus = self.firstMatchAttendanceObject.objectForKey("registrationStatus") as! String
                    }

                }
        
        // add button
        let button   = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
            if self.registrationStatus == "Registered" {
                button.backgroundColor = UIColor(red: (248/255), green: (131/255), blue: (121/255), alpha: 1)
                button.setTitle("CANCEL", forState: UIControlState.Normal)
            } else {
                button.backgroundColor = UIColor(red: (248/255), green: (131/255), blue: (121/255), alpha: 1)
                button.setTitle("REGISTER", forState: UIControlState.Normal)
            }

 

        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let buttonWidth = screenSize.width
        button.frame = CGRectMake(0, 397, buttonWidth, 50)

        scroller.addSubview(button)

            } else {
                // Log details of the failure
            }
        }
        
    }

    
    func buttonAction(sender:UIButton!) {

        println("Button tapped")
        
        self.performSegueWithIdentifier(confirmationPageId, sender: sender)
        
        

        
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == confirmationPageId {
            
            if let destination = segue.destinationViewController as? ConfirmViewController {
                
                destination.scheduleObject = scheduleObject
                destination.registrationStatus = registrationStatus
                destination.firstMatchAttendanceObject = firstMatchAttendanceObject
                
            }
        }
    }

}


