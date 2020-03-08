import Cocoa

class Company {
    var ceo: CEO?
    
    init() {
        ceo = CEO()
        ceo?.manager = ProductManager()
        ceo?.manager?.ceo = ceo
        ceo?.manager?.developer1 = Developer()
        ceo?.manager?.developer1?.manager = ceo?.manager
        ceo?.manager?.developer2 = Developer()
        ceo?.manager?.developer2?.manager = ceo?.manager
    }
    
    deinit {
        print("deinit Company")
    }
}

class CEO {
    var manager: ProductManager?
    
    lazy var printProductManager = { [weak self] in
        print("[CEO] \(String(describing: self?.manager))")
    }
    
    lazy var printProductManagerDevelopers = { [weak self] in
        self?.manager?.printDevelopers()
    }
    
    lazy var printProductManagerCompany = { [weak self] in
        self?.manager?.printCompany()
    }
    
    func receiveMessage(_ message: String) {
        print("[CEO] \(message)")
    }
    
    deinit {
        print("deinit CEO")
    }
}

class ProductManager {
    weak var ceo: CEO?
    var developer1: Developer?
    var developer2: Developer?
    
    func printDevelopers() {
        print("[ProductManager] \(developer1); \(developer2)")
    }
    
    func printCompany() {
        //print("[ProductManager] \(ceo); \(self); \(developer1); \(developer2)")
        print("[ProductManager] \(company)")
    }
    
    func receiveMessage(_ message: String) {
        print("[ProductManager] \(message)")
    }
    
    deinit {
        print("deinit ProductManager")
    }
}

class Developer {
    weak var manager: ProductManager?
    
    func receiveMessage(_ message: String) {
        print("[Developer] \(message)")
    }
    
    func sendMessageToOtherDeveloper() {
        if self === manager?.developer1 {
            if let otherDeveloper = manager?.developer2 {
                otherDeveloper.receiveMessage("Hi!")
            }
        } else {
            if let otherDeveloper = manager?.developer1 {
                otherDeveloper.receiveMessage("Hello!")
            }
        }
    }
    
    func sendMessageToProductManager() {
        manager?.receiveMessage("I need TZ.")
    }
    
    func sendMessageToCEO() {
        manager?.ceo?.receiveMessage("Give money.")
    }
    
    deinit {
        print("deinit Developer")
    }
}

func getCompany() -> Company? {
    return company
}

var company: Company? = Company()
company?.ceo?.manager?.developer1?.sendMessageToOtherDeveloper()
company?.ceo?.manager?.developer2?.sendMessageToOtherDeveloper()
company?.ceo?.manager?.developer1?.sendMessageToProductManager()
company?.ceo?.manager?.developer2?.sendMessageToCEO()
company?.ceo?.printProductManager()
company?.ceo?.printProductManagerDevelopers()
company?.ceo?.printProductManagerCompany()
company = nil
