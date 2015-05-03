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

    var activityId = String()
    
    var activityName = String()

    @IBOutlet weak var activityNameLabel: UILabel!

    override func viewWillAppear(animated: Bool) {
        activityNameLabel.text = activityId
        println(activityId)

    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set up scroller size and color
        let scroller = UIScrollView()
        scroller.contentSize = CGSize(width: self.view.frame.width, height: 1050)
        scroller.backgroundColor = UIColor.purpleColor()
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
        let imageName = "babyyoga.jpg"
        let actPic = UIImage(named: imageName)
        let actPicView = UIImageView(image: actPic)
        actPicView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
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
        
        let classDetailLabel = UILabel()
//        var activityName = actvy!.objectForKey("testOutput") as! String
//        classDetailLabel.text = "hello \(activityName)"
        classDetailLabel.backgroundColor = UIColor.redColor()
        actPicView.addSubview(classDetailLabel)
        classDetailLabel.frame = CGRect(x: self.view.frame.width/2, y: actPicView.frame.height/2, width: 150, height: 30)
        classDetailLabel.center = CGPointMake(self.view.frame.width/2, actPicView.frame.height/2)
        classDetailLabel.textAlignment = NSTextAlignment.Center

        // pull PFObject detail
        var query = PFQuery(className:"Schedule")
        query.includeKey("sActivityName")
        query.includeKey("sActivityProvider")
        query.includeKey("sTeacher")
        query.getObjectInBackgroundWithId("\(activityId)") {
            (actvy: PFObject?, error: NSError?) -> Void in
            if error == nil && actvy != nil {
                println(actvy)
                var test: String = (actvy!.objectForKey("testOutput") as? String)!
                
                if let actProvPointer = actvy!.objectForKey("sActivityProvider") as? PFObject {
                    if let aN = actProvPointer.objectForKey("apName") as? String {
                        classDetailLabel.text = aN
                    }
                }


//                classDetailLabel.text = "hello \(test)"
                
            } else {
                println(error)
            }
        }
        
        // add button
        let button   = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        button.backgroundColor = UIColor(red: (248/255), green: (131/255), blue: (121/255), alpha: 1)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.setTitle("REGISTER", forState: UIControlState.Normal)
        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)

        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let buttonWidth = screenSize.width
        button.frame = CGRectMake(0, 397, buttonWidth, 50)

        scroller.addSubview(button)
        
    }
    
    func buttonAction(sender:UIButton!)
    {
        println("Button tapped")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
