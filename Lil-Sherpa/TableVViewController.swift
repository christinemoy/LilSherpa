import Parse
import UIKit
import Foundation

class TableVViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var activities = [PFObject]()
    
    var refreshControl : UIRefreshControl?
    
    var todaysDate: NSDate!
    
    var middleButtonDate: NSDate!
    
    var middleButtonDatePlusOne: NSDate!
    
    let actdetSegueIdentifier = "showActivityDetailSegue"
    
    
    @IBOutlet weak var middleButton: UIButton!
    
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet weak var leftButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    func dateComponents(date: NSDate) -> NSDate {
        
        let flags: NSCalendarUnit = NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear
        let components = NSCalendar.currentCalendar().components(flags, fromDate: date)
        
        var dateFDYear = components.year
        var dateFDMonth = components.month
        var dateFDDay = components.day
        
        let middleButtonDateComponents = NSDateComponents()
        middleButtonDateComponents.year = dateFDYear
        middleButtonDateComponents.month = dateFDMonth
        middleButtonDateComponents.day = dateFDDay
        middleButtonDateComponents.hour = 0
        middleButtonDateComponents.minute = 0
        middleButtonDateComponents.second = 0
        
        let middleButtonDate = NSCalendar.currentCalendar().dateFromComponents(middleButtonDateComponents)!
        return middleButtonDate
    }
    
    func datePlusOne(date: NSDate) -> NSDate {
        var nextDate = date.dateByAddingTimeInterval(60*60*24)
        return nextDate
    }
    
    func programmaticButtonUpdate(){
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d"
        let timeZone = NSTimeZone(name: "EDT")
        dateFormatter.timeZone = timeZone
        
        if middleButtonDate == nil {
            middleButtonDate = NSDate()
        }
        
        var middleDate = dateFormatter.stringFromDate(middleButtonDate)
        
        var rightDateNs = middleButtonDate.dateByAddingTimeInterval(60*60*24)
        
        var rightDate = dateFormatter.stringFromDate(rightDateNs)
        
        var leftDateNs = middleButtonDate.dateByAddingTimeInterval(-(60*60*24))
        
        var leftDate = dateFormatter.stringFromDate(leftDateNs)
        
        middleButton.setTitle(middleDate, forState: UIControlState.Normal)
        rightButton.setTitle(rightDate, forState: UIControlState.Normal)
        leftButton.setTitle(leftDate, forState: UIControlState.Normal)
    }
    
    
    @IBAction func pressMiddleButton(sender: UIButton) {
        println("middle button pressed")
    }
    
    
    @IBAction func pressRightButton(sender: UIButton) {
        println("right button pressed")
        middleButtonDate = middleButtonDate.dateByAddingTimeInterval(60*60*24)
        middleButtonDatePlusOne = datePlusOne(middleButtonDate)
        programmaticButtonUpdate()
        loadActivities()
    }
    
    @IBAction func pressLeftButton(sender: UIButton) {
        println("left button pressed")
        middleButtonDate = middleButtonDate.dateByAddingTimeInterval(-(60*60*24))
        middleButtonDatePlusOne = datePlusOne(middleButtonDate)
        programmaticButtonUpdate()
        loadActivities()

    }

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        programmaticButtonUpdate()
        
        todaysDate = NSDate()
        middleButtonDate = dateComponents(todaysDate)
        println("viewDidLoad \(middleButtonDate)")
        middleButtonDatePlusOne = datePlusOne(middleButtonDate)
        println("viewDidLoad \(middleButtonDatePlusOne)")
        
        self.loadActivities()
        
//        refreshControl = UIRefreshControl()
        
//        refreshControl?.addTarget(self, action: "loadActivities", forControlEvents: UIControlEvents.ValueChanged)
        
//        self.tableView.addSubview(refreshControl!)
        
        self.tableView.reloadData()
        
    }
    
    
    func loadActivities(name: String? = nil, sortAsc: Bool? = nil) {
        
//        activities.removeAll(keepCapacity: false)
        
        var query = PFQuery(className:"Schedule")
        query.whereKey("sDate", lessThan: middleButtonDatePlusOne)
        query.whereKey("sDate", greaterThanOrEqualTo: middleButtonDate)
        
        println("Middle button date is \(middleButtonDate)")
        println("Middle button date plus one is \(middleButtonDatePlusOne)")

        query.includeKey("sActivityName")
        query.includeKey("sActivityProvider")
        query.includeKey("sTeacher")
        
//        if let name = name {
//            query.whereKey("testOutput", equalTo:name)
//        }
    
//        if let sortAsc = sortAsc {
//            if sortAsc {
//                query.orderByAscending("testOutput")
//            } else {
//                query.orderByDescending("testOutput")
//            }
//        }
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                if let unwrappedObjects = objects as? [PFObject] {

                    self.activities = unwrappedObjects
                    
//                    for object in unwrappedObjects {
////                        var activityDetail = object["sActivityName"] as? PFObject
////                        self.activities.append(object)
////                        println("\(objects)")
////                        println("\(activityDetail)")
//                    }
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
 
//                self.refreshControl?.endRefreshing()
            } else {
                // Log details of the failure
            }
        }
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        loadActivities(name: searchBar.text)
    }
    
    
    func sortActivities(asc: Bool){
        loadActivities(sortAsc: asc)
    }
    
    
    @IBAction func sortOptions(sender: AnyObject) {
//        var sortOptions = UIAlertController(title: "Sort", message: "Select sort options", preferredStyle: UIAlertControllerStyle.ActionSheet)
//        
//        let asc = UIAlertAction(title: "Ascending", style: UIAlertActionStyle.Default) { (action) -> Void in
//            self.sortStudents(true)
//        }
//        
//        let desc = UIAlertAction(title: "Descending", style: UIAlertActionStyle.Default) { (action) -> Void in
//            self.sortStudents(false)
//        }
//        
//        sortOptions.addAction(asc)
//        sortOptions.addAction(desc)
//        sortOptions.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
//        
//        presentViewController(sortOptions, animated: true, completion: nil)
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        loadActivities()
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("activityCell") as! ActivityCell
        
        let activity = activities[indexPath.row]
        
        let date = activity["sDate"] as? NSDate
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let timeZone = NSTimeZone(name: "EDT")
        dateFormatter.timeZone = timeZone
        //need to figure out how to adjust when EDT converts to EST
        
//        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        var dateString = dateFormatter.stringFromDate(date!)
        
        cell.activityStartTimeLabel.text = dateString
        
        if let actDetPointer = activity["sActivityName"] as? PFObject {
            if let dur = actDetPointer["aDuration"] as? String {
                cell.activityDurationLabel.text = ("\(dur) min")
                cell.activityNameLabel.text = actDetPointer["aName"] as? String
            }
        }
        
        if let actProvPointer = activity["sActivityProvider"] as? PFObject {
            cell.activityLocationLabel.text = actProvPointer["apName"] as? String
            cell.activityNeighborhoodLabel.text = actProvPointer["apNeighborhoodL2"] as? String
        }
        
        if let actTeacherPointer = activity["sTeacher"] as? PFObject {
            if let tchrfn = actTeacherPointer["tFirstName"] as? String {
                if let tchrln = actTeacherPointer["tLastName"] as? String {
                    cell.activityTeacherLabel.text = ("\(tchrfn) \(tchrln)")
                }
            }
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let activity = activities[indexPath.row]
            activity.deleteInBackgroundWithBlock{ (_, error) -> Void in
                if let error = error {
                    println("you dont have rights delete it - \(error.description)")
                } else {
                    self.activities.removeAtIndex(indexPath.row)
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                    println("deleted successfully")
                }
                
            }
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == actdetSegueIdentifier {
            
            if let destination = segue.destinationViewController as? ActivityDetailViewController {
                
                if let activityIndex = self.tableView.indexPathForSelectedRow()?.row {
                    
                    destination.activityId = (activities[activityIndex].valueForKey("objectId") as? String)!
                }
            }
        }
    }
    
}