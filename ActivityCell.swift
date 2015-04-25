import UIKit

class activityCell: UITableViewCell {
    
    @IBOutlet weak var activityStartTimeLabel: UILabel!
    
    @IBOutlet weak var activityDurationLabel: UILabel!
    
    @IBOutlet weak var activityNameLabel: UILabel!
    
    @IBOutlet weak var activityLocationLabel: UILabel!
    
    @IBOutlet weak var activityTeacherLabel: UILabel!
    
    @IBOutlet weak var activityNeighborhoodLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}