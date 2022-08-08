import Cocoa 

struct Car {
    let model: String
    let numSeats: Int
    private(set) var currentGear = 1
    
    mutating func changeGear(up: Bool) {
        if up {
            if currentGear < 9 {
                currentGear += 1
                print("Changed gear to \(currentGear)")
            }
        } else {
            if currentGear > 1 {
                currentGear -= 1
                print("Changed gear to \(currentGear)")
            }
        }
    }
    
    init(model: String, numSeats: Int) {
        self.model = model
        self.numSeats = numSeats
    }
}

var peugeot = Car(model: "Peugeot", numSeats: 7)

peugeot.changeGear(up: true)
peugeot.changeGear(up: true)
peugeot.changeGear(up: false)
peugeot.changeGear(up: false)
peugeot.changeGear(up: false)
print(peugeot.currentGear)
