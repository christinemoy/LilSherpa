import Parse
import UIKit

class TableVViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource {
    
    var activities = [PFObject]()
    
    var refreshControl : UIRefreshControl?
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadActivities()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "loadActivities", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableView.addSubview(refreshControl!)
        
    }
    
    
    func loadActivities(name: String? = nil, sortAsc: Bool? = nil) {
        var query = PFQuery(className:"Schedule")
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
                if let objects = objects as? [PFObject] {

                    
                    for object in objects {
                        var activityDetail = object["sActivityName"] as? PFObject
                        self.activities = objects
                        println("\(objects)")
                        println("\(activityDetail)")
                    }
                    
                }
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
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
    
}