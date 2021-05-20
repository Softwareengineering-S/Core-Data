import UIKit

var str = "Hello, playground"



class Gegner {
    
    var leben: Int = 100
    
}

let gegner1 = Gegner()
let gegner2 = Gegner()
let gegner3 = Gegner()
let gegner4 = Gegner()
let gegner5 = Gegner()
let gegner6 = Gegner()


// Konzept -> Singleton Pattern (Einzelstück)
class CoreDataService {
    
    static let defaults = CoreDataService() // Klassenvariable
    
    private init() {
        
    }
    
    func createData() {
        
    }
    
    func loadData() {
        
    }
    
    func deleteData() {
        
    }
}

CoreDataService.defaults

let a = CoreDataService()
