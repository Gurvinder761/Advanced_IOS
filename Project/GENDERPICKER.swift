

import UIKit

class SecondViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{
  //var gender: [String] = []
  var gender = ["No Gender","Male","Female","TransGender"]
  var selectgender = ""

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
    return gender.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "genders", for: indexPath)
     cell.textLabel?.text = gender[indexPath.row]
    
    return cell
  }
  

  override func prepare(for segue: UIStoryboardSegue,
                           sender: Any?)
  {
  if segue.identifier == "Genderpicker"
  {
  let cell = sender as! UITableViewCell
  if let indexPath = tableView.indexPath(for: cell) {
    selectgender = gender[indexPath.row] }
  }
    
  }

}
