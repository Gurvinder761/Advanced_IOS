
import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var name: String?
    @NSManaged public var birthday: Date?
    @NSManaged public var gender: String?
    @NSManaged public var country: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var photoID: NSNumber?

}
