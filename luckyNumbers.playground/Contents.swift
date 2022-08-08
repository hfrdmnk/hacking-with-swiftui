import Cocoa

let luckyNumbers = [7, 4, 38, 21, 16, 15, 12, 33, 31, 49]

let trueLuckyNumbers = luckyNumbers.filter {
    !$0.isMultiple(of: 2)
} .sorted {
    $0 > $1
} .map {
    "\($0) is a lucky number"
}

for i in 0..<trueLuckyNumbers.count {
    print(trueLuckyNumbers[i])
}
