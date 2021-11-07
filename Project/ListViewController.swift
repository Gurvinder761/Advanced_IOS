
import CoreData
import UIKit

class ListViewController: UIViewController, NSFetchedResultsControllerDelegate
{
  var searchResults = [String]()
  var locations = [Location] ()
   var hassearched = false
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var SearchBar: UISearchBar!
  struct TableViewCellIdentifiers
  {
    static let searchResultCell = "SearchResultCell"
  }
  
  var coreDataStack: CoreDataStack!

lazy var fetchedResultsController: NSFetchedResultsController<Location> = {

let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
let zoneSort = NSSortDescriptor(key: #keyPath(Location.name), ascending: false)
fetchRequest.sortDescriptors = [zoneSort]


let fetchedResultsController = NSFetchedResultsController( fetchRequest: fetchRequest,
managedObjectContext: coreDataStack.managedContext, sectionNameKeyPath: nil,
  cacheName: nil)
fetchedResultsController.delegate = self
return fetchedResultsController
}()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
     
      do
         {
            try fetchedResultsController.performFetch()
                }
             catch let error as NSError
             {
                print("Fetching error: \(error), \(error.userInfo)")
                
                   }
  
      var cellNib = UINib(nibName: "NothingFound", bundle: nil)
      tableView.register(cellNib, forCellReuseIdentifier: "NothingFound")
  
      cellNib = UINib(nibName: "SearchResultCells", bundle: nil);
      tableView.register(cellNib,forCellReuseIdentifier: "SearchResultCells")
    
      tableView.rowHeight = 140
      tableView.reloadData()
    
                       }
 
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
   
  {
  
    if (segue.identifier == "additem")
     {
      let navController = segue.destination as? itemDetailViewController
      if let indexPath = sender as? IndexPath
          {
        let team = fetchedResultsController.object(at: indexPath)
       navController!.locationToEdit = team
        navController!.coreDataStack = coreDataStack
          }
       }
     }
  }

  // search bar text
extension ListViewController : UISearchBarDelegate {
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
  {
    hassearched = false
    searchBar.text = ""
    tableView.reloadData()
  }
  
  
func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
{
  //searchResults = []
  SearchBar.becomeFirstResponder()
  if searchBar.text == ""
  {
       let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
       let location = try?  coreDataStack.managedContext.fetch(fetchRequest)

      locations = location!
      hassearched = true
      tableView.reloadData()
  
  }
  else{
  let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
  var predicate = NSPredicate(format: "name contains %@", searchBar.text as! CVarArg )
    fetchRequest.predicate = predicate

     
    let location = try?  coreDataStack.managedContext.fetch(fetchRequest)
   
  locations = location!
  
  
  hassearched = true

tableView.reloadData()
  
   }
  }
}
 

// tableview working
  



extension ListViewController: UITableViewDelegate,UITableViewDataSource, UITextViewDelegate
{
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
  {
    tableView.deselectRow(at: indexPath, animated: true)
   
  }

  func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
      //Pass the indexPath as sender
      self.performSegue(withIdentifier: "additem", sender: indexPath)

          }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    if ((hassearched) && (locations.count != 0))
    {
      return locations.count
    }
   else if ((hassearched) && (locations.count == 0))
    {

     return 1

     }
   
    else
         {
          let sectionInfo = fetchedResultsController.sections![section]
            return sectionInfo.numberOfObjects
         }
      
    tableView.reloadData()
   // hassearched = false
    }

  func tableView(_ tableView: UITableView,
  cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
 
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCells", for: indexPath) as! SearchResultCell
  
    if ((hassearched) && (locations.count == 0))
    {
  
     let cell = tableView.dequeueReusableCell(withIdentifier: "NothingFound", for: indexPath)
         return cell
     }
       
       if hassearched {
      let person = locations[indexPath.row]
    cell.configure(for: person)
 
       return cell
      }
    else{
        let person = fetchedResultsController.object(at: indexPath);
         cell.configure(for: person)
          return cell
        }
      }
  
   func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
   {
     let sectionInfo = fetchedResultsController.sections?[section]
     return sectionInfo?.name
     }

  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
     
  }
      

func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
 if      ( editingStyle  == .delete)
 
    {
 
   let personToRemove = fetchedResultsController.object(at: indexPath)
       personToRemove.removePhotoFile()
       coreDataStack.managedContext.delete(personToRemove)
  
  do  {
      
    try   coreDataStack.managedContext.save()
    } catch let error as NSError {
      print("Saving error: \(error), description: \(error.userInfo)")
   }

}
}
  }
extension ListViewController
          
  {
 
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
  {
      print("*** controllerWillChangeContent")
  tableView.beginUpdates()
    
  }
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
  {
  switch type
  {
  case .insert:
  print("*** NSFetchedResultsChangeInsert (object)")
    tableView.insertRows(at: [newIndexPath!], with: .fade)
  case .delete:
  print("*** NSFetchedResultsChangeDelete (object)")
    tableView.deleteRows(at: [indexPath!], with: .fade)
  case .update:
  print("*** NSFetchedResultsChangeUpdate (object)")
    if let cell = tableView.cellForRow(at: indexPath!) as? SearchResultCell
    {
      let person = controller.object(at: indexPath!)
  as! Location
      cell.configure(for: person)
  }
  case .move:
  print("*** NSFetchedResultsChangeMove (object)")
    tableView.deleteRows(at: [indexPath!], with: .fade)
    tableView.insertRows(at: [newIndexPath!], with: .fade)
  }
    
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int,for type: NSFetchedResultsChangeType)
  {
  switch type
  {
  case .insert:
  print("*** NSFetchedResultsChangeInsert (section)")
    tableView.insertSections(IndexSet(integer: sectionIndex),with: .fade)
  case .delete:
  print("*** NSFetchedResultsChangeDelete (section)")
    tableView.deleteSections(IndexSet(integer: sectionIndex),with: .fade)
  case .update:
  print("*** NSFetchedResultsChangeUpdate (section)")
  case .move:
        print("*** NSFetchedResultsChangeMove (section)")
      }
  }
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
  {
      print("*** controllerDidChangeContent")
  tableView.endUpdates()
    
  }
  }
