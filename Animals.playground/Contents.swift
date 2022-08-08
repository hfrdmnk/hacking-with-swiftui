import Cocoa

class Animal {
    let legs: Int
    
    init(legs: Int) {
        self.legs = legs
    }
}

class Dog: Animal {
    func speak() {
        print("Woof, I'm a dog!")
    }
    
    init() {
        super.init(legs: 4)
    }
}

class Cat: Animal {
    let isTame: Bool
    
    func speak() {
        print("Meow, I'm a cat")
    }
    
    init(isTame: Bool) {
        self.isTame = isTame
        super.init(legs: 4)
    }
}

class Corgi: Dog {
    override func speak() {
        print("Wau, I'm a Corgi!")
    }
}

class Poodle: Dog {
    override func speak() {
        print("Wiff, I'm a Poodle!")
    }
}

class Persian: Cat {
    override func speak() {
        print("Purrr, I'm a Persian!")
    }
    
    init() {
        super.init(isTame: true)
    }
}

class Lion: Cat {
    override func speak() {
        print("Roar, I'm a Lion!")
    }
    
    init() {
        super.init(isTame: false)
    }
}

let simba = Lion()
print(simba.legs)
print(simba.isTame)
simba.speak()   
