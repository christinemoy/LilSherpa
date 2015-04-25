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
        var query = PFQuery(className:"Activity_Provider")
        if let name = name {
            query.whereKey("name", equalTo:name)
        }
        
        if let sortAsc = sortAsc {
            if sortAsc {
                query.orderByAscending("name")
            } else {
                query.orderByDescending("name")
            }
        }
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    self.activities = objects
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
        var cell = tableView.dequeueReusableCellWithIdentifier("activityCell") as! UITableViewCell
        
        let activity = activities[indexPath.row]
        cell.textLabel!.text = activity["name"] as? String
        
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