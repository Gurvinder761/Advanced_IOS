
import UIKit

class CountryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{

 
  var country = ["No Country","Canada","India","Australia","New Zealand","America","German","Pakistan","China","England"]
  var selectcountry = ""

  
  @IBOutlet weak var tableView: UITableView!
  
  
  
  
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  @IBAction func cancel(_ sender: Any)
  {
    navigationController?.popViewController(animated: true)
  
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return country.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "countries", for: indexPath)
     cell.textLabel?.text = country[indexPath.row]
    
    return cell
  }
  

  override func prepare(for segue: UIStoryboardSegue,
                           sender: Any?)
  {
  if segue.identifier == "countrypicker"
  {
  let cell = sender as! UITableViewCell
  if let indexPath = tableView.indexPath(for: cell) {
    selectcountry = country[indexPath.row] }
  }
    
  }


}
