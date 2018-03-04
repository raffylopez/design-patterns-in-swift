struct FibonacciSequence: IteratorProtocol {
    typealias Element = Int
    var values = (0,1)
    // mutating is only for structs
    mutating func next() -> Element? {
        self.values = (self.values.1, self.values.0 + self.values.1)
        return self.values.0
    }
}

exampleOf(description: "Iterator pattern") {
    var fibs = FibonacciSequence()
    (0..<10).forEach({ _ in
        print(fibs.next()!)
    })
}

struct RandomGenerator: IteratorProtocol, Sequence {
    typealias Element = Int
    var count = 10
    
    mutating func next()->Element? {
        self.count -= 1
        if count <= 0 {
            return nil
        }
        return Int(arc4random_uniform(200))
    }
}

exampleOf(description: "Using a custom collection") { (Void) in
    for i in RandomGenerator() {
        print("Random: \(i)")
    }
}

exampleOf(description: "Observer pattern") {
    class Publisher {
        var onPublish: ([(Int)->()])? = []
        
        func publish(num: Int) {
            // ... stuff
            print("ANNOUNCEMENT: We are publishing \(num)...")
            // notify subscribers
            for fn in onPublish! {
                fn(num)
            }
        }
    }
    let publisher = Publisher()
    publisher.onPublish?.append(
        { value in
            print("Wow! \(value) got published! So excited!")
    })
    
    publisher.onPublish?.append({value in
        print("Amazing, I always knew \(value) will get published at some point!")}
        
    )
    publisher.publish(num: 123)
    publisher.publish(num: 456)
}


exampleOf(description: "Notification center") { (<#Void#>) in
    class AwesomeNotificationCenter {
        typealias Fn = ((Int)->())?
        var observers: [String: Fn] = [:]
        
        func addObserver(key: String, fn: Fn) {
            observers[key] = fn
        }
        
        func trigger(value: Int) {
            for o in observers {
                o.value!(value)
            }
        }
        
        func removeObserver(key: String) {
            observers[key] = nil
        }
    }
    let notificationCenter = AwesomeNotificationCenter()
    notificationCenter.addObserver(key: "cool", fn: {num in print(num)})
    notificationCenter.addObserver(key: "bar", fn: {num in print("hmmm ", num)})
    notificationCenter.trigger(value: 20)
}

protocol Preset {
    var indentation: Int {get}
    var presetName: String {get}
    var wordWrap: Bool {get}
}

exampleOf(description: "Builder pattern") { (Void) in
    class DefaultPreset : Preset {
        let indentation = 4
        let presetName = "Default"
        let wordWrap = true
    }
    class CompactPreset : Preset {
        let indentation = 4
        let presetName = "Compact"
        let wordWrap = false
    }
    
    class Profile {
        let indentation: Int
        let presetName: String
        let wordWrap: Bool
        
        init(preset: Preset) {
            indentation = preset.indentation
            presetName = preset.presetName
            wordWrap = preset.wordWrap
        }
    }
    class Client {
        func main() {
            let profile0 = Profile(preset: DefaultPreset())
            let profile1 = Profile(preset: CompactPreset())
            
        }
    }
}

class Employee {
    var name: String?
    var age: Int?
    var dept: Department
    
    init(name: String, age: Int, dept: Department) {
        self.name = name
        self.age = age
        self.dept = dept
    }
}

extension Employee: CustomStringConvertible {
    var description: String {
        return name!
    }
}

class Department: CustomStringConvertible {
    var name: String?
    var employees: [Employee] = []
    
    init(name: String) {
        self.name = name
    }
    var description: String {
        return name!
    }
    
    subscript (name:String)->Department? {
        return Organization.findDepartment(name: name)
    }
    static func get (_ name:String)->Department? {
        return Organization.findDepartment(name: name)
    }
}

class Organization {
    static var departments: [Department] = []
    static func addDepartment(name: String)->Department? {
        let newDept = Department(name: name)
        departments.append(newDept)
        return newDept
    }
    static func findDepartment(name: String)->Department? {
        return departments.filter({ (dept: Department) -> Bool in
            dept.name == name
        }).first
    }
}

class EmployeeFactory {
    static func new(name: String, age: Int, departmentName: String)->Employee? {
        let search = Organization.departments.filter({ (dept) -> Bool in
            dept.name == departmentName
        }).first
        
        if let found = search {
            let emp = Employee(name: name, age: age, dept: found)
            search?.employees.append(emp)
            return emp
        } else {
            let newDept = Department(name: departmentName)
            let emp = Employee(name: name, age: age, dept: newDept)
            Organization.departments.append(newDept)
            newDept.employees.append(emp)
            return emp
        }
        
    }
}
exampleOf(description: "Simple Factory") { (Void) in
    
    let john = EmployeeFactory.new(name: "John", age: 24, departmentName: "Sales")
    let mary = EmployeeFactory.new(name: "Mary", age: 21, departmentName: "Sales")
    let todd = EmployeeFactory.new(name: "Todd", age: 21, departmentName: "Information Group")
    
    Organization.addDepartment(name: "Marketing")
    Organization.departments.forEach({ (dept) in
        print(dept)
    })
    print(Organization.findDepartment(name: "Information Group")?.employees as Any)
    print(Organization.findDepartment(name: "Sales")?.employees as Any)
    print(Department.get("Sales")?.employees)
}


class Actor {
    var name: String = ""
    func sing()->String {
        return "Oooh la la, snow in a sunny day!"
    }
}

class Director {
    var actor: Actor? = nil
    var sword: Sword?
    func action() {
        actor = Actor()
        sword = Props.FlamingSword()
        if let actor = actor, let sword = sword {
            actor.name = "Phil"
            print("Our hero,", (actor.name) ,"wields", (sword.what()))
            print("And sings,\"", actor.sing(), "\"")
        }
    }
}
protocol Sword {
    func what()->String
}

class Props {
    class FlamingSword : Sword {
        func what()->String {
            return "a flaming sword"
        }
    }
}

exampleOf(description: "Playwright Pattern") { (Void) in
    let d = Director()
    d.action()
}

protocol Hero {
    var name: String? { get }
    var drone: Drone? { get }
}

extension Hero {
    func run() {
        print(self.name!, "is running!")
        if let drone = self.drone {
            drone.tagAlong()
            
        }
    }
}

class ClassicalHero: Hero {
    internal var drone: Drone? = FlameDrone()
    internal var name: String? = ""
}

protocol Drone {
    func action()-> Void
    func tagAlong()->Void
}

class FlameDrone: Drone {
    func action() {
        print("Flambeau!!!")
    }
    func tagAlong() {
        print("Flamedrone is tagging along!")
    }
}

exampleOf(description: "Factory method") { (<#Void#>) in
    let hero = ClassicalHero()
    hero.name = "Classy Quinn"
    if let name = hero.name {
        hero.run()
    }
}



// --- Abstract Factory ---

protocol Computer {}
protocol Storage {}

class DesktopComputer:Computer {
}

class HardDisk:Storage {
}

class MobilePhone:Computer {
    
}

class NandFlashMemory:Storage {
    
}

protocol Factory {
    static func makeComputer()->Computer
    static func makeStorage()->Storage
}
class DesktopComputerSystemFactory:Factory {
    
    internal static func makeStorage() -> Storage {
        return HardDisk()
    }
    
    
    internal static func makeComputer()->Computer { return DesktopComputer() }
}

class MobilePhoneSystemFactory:Factory {
    internal static func makeStorage() -> Storage {
        return NandFlashMemory()
    }
    
    internal static func makeComputer()->Computer { return MobilePhone() }
}

exampleOf(description: "Abstract Factory") {
    let desktop = DesktopComputerSystemFactory.makeComputer()
    let hdd = DesktopComputerSystemFactory.makeStorage()
    
    let mphone = MobilePhoneSystemFactory.makeComputer()
    let internalMemory = MobilePhoneSystemFactory.makeStorage()
    
    print(desktop, hdd)
    print(mphone, internalMemory)
}


class Person: NSCopying, CustomStringConvertible{
    let name: String
    init(name: String) {
        self.name = name
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        return Person(name: name)
    }
    
    var description: String {
        return self.name
    }
}

exampleOf(description: "Prototype") { (<#Void#>) in
    let john = Person(name: "John")
    let johnCopy = john.copy() as! Person
    print(johnCopy)
}

protocol Language {
    func greet()->String
}

class Page {
    var lang: Language? = nil
    init (lang: Language) {
        self.lang = lang
    }
    
    func render()->String {
        if let lang = lang {
            return "\(lang.greet())!"
        }
        return "Greetings!"
    }
}

class English: Language {
    func greet()->String {
        return "Hello"
    }
}

class French: Language {
    func greet()->String {
        return "Bonjour"
    }
}

exampleOf(description: "Bridge") { (<#Void#>) in
    let page = Page(lang: French())
    print(page.render())
}

protocol Letter {
    var letter: Letter { get }
    var char: String { get}
    func value()->Letter
}

class T : Letter {
    internal var char: String = "T"
    internal var letter: Letter
    
    init(letter:Letter?) {
        self.letter = letter!
    }
    
    func value()->Letter{
        return self.letter
    }
}

class O : Letter {
    internal var char: String = "O"
    internal var letter: Letter
    
    init(letter:Letter) {
        self.letter = letter
    }
    
    func value()->Letter{
        return self.letter
    }
}

print(O(letter:T(letter:nil)).value())
print("Done")
