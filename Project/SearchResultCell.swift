

import UIKit

class SearchResultCell: UITableViewCell {
  
  var coreDataStack: CoreDataStack!
//  var SearchResultCell: UITableViewCell!
  @IBOutlet weak var label1: UILabel!
   @IBOutlet weak var imageview: UIImageView!
  @IBOutlet weak var label2: UILabel!
  //
   @IBOutlet weak var label3: UILabel!
  @IBOutlet weak var label4: UILabel!
    var dueDate = Date()
 
  override func awakeFromNib()
  {
        super.awakeFromNib()
        // Initialization code
 
  }
  
  func configure(for person: Location) {

//    guard let cell = cell as? TeamCell else {
//      return
//    }

            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            //formatter.timeStyle = .short
            dueDate = person.birthday!
         label2.text = formatter.string(from: dueDate)
    
    let name : String = person.name!
    let country:String = person.country!
    let namecountry = "\(name) , \(country) "
    label1.text = namecountry
   // var gen : String! = String(person.gender!
 

    imageview.image = person.photoImage
    label3.text! = "Latitude = \(person.latitude)"
    label4.text! = "Latitude = \(person.longitude)"

  }

}
