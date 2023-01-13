import Foundation

let inputSizeTorah = readLine()
let inputPointSF = readLine()

let inputSizeTorahTest = inputSizeTorah ?? "4 4"
let inputPointSFTest = inputPointSF ?? "0 1 3 2"

let sizeTorah = inputSizeTorahTest.split(separator: " ").compactMap({ Int(String($0)) })
let pointSF = inputPointSFTest.split(separator: " ").compactMap({ Int(String($0)) })

var startPoint = Array<Int>()
startPoint.append(pointSF[0])
startPoint.append(pointSF[1])

var finishPoint = Array<Int>()
finishPoint.append(pointSF[2])
finishPoint.append(pointSF[3])

func generateObstaclePoints() -> [Array<Int>: Int] {
    var totalObstaclePoints = [Array<Int>: Int]()
    var row = 0
    var col = 0
    for _ in 0 ..< sizeTorah[0] {
        let data = readLine()
        let obstacle = data?.split(separator: " ").compactMap({ Int(String($0)) }) ?? [1, 0, 1, 0]
        
        for item in obstacle {
            if item > 0 {
                totalObstaclePoints[[row,col]] = 1
            } else {
                totalObstaclePoints[[row,col]] = 0
            }
            col += 1
        }
        col = 0
        row += 1
    }
    return totalObstaclePoints
}

var obstaclePoints  = generateObstaclePoints()
obstaclePoints[finishPoint] = 2

var completedStep  = [(point: startPoint, pathTraveled: " ")]
var shortPath = "-1"

var noWay = false
var finishStep = false

func stepVerification(step: (point: [Int], pathTraveled: String)) -> (finish: Bool, stepWay: Bool) {
    
    var totalFinish = false
    var stepPath = true
    
    if !totalFinish {
        switch obstaclePoints[step.point] {
        case 0:
            stepPath = true
        case 1:
            stepPath = false
        case 2:
            shortPath = step.pathTraveled
            totalFinish = true
        case .none:
            print("none")
        case .some(_):
            print("some")
        }
    }
    return (finish: totalFinish, stepWay: stepPath)
}

func findingPath(way: [(point: [Int], pathTraveled: String)]) -> Array<(point: [Int], pathTraveled: String)> {
    
    var total = 0
    var stepWay = [(point: [Int], pathTraveled: String)]()
    var noDoublePoint = Set<[Int]>()
    let wayString = ["S","N","E","W"]
    let invertSade = ["N","S","W","E"]
    let wayInt = [1,-1,1,-1]
    
    for step in way {
        var checkStep = (finish: false, stepWay: true)
        
        for index in wayString.indices {
            var newStep = step
            if checkStep.finish {
                total += 1
                break
            }
            let lastChar = newStep.pathTraveled.last ?? "Q"
            if String(lastChar) == invertSade[index] {
                continue
            }
            
            newStep.pathTraveled += wayString[index]
            
            if index < 2 {
                switch newStep.point[0] + wayInt[index] {
                case sizeTorah[0]:
                    newStep.point[0] = 0
                case -1:
                    newStep.point[0] = sizeTorah[0] - 1
                case 0..<sizeTorah[0]:
                    newStep.point[0] += wayInt[index]
                default:
                    print("error")
                }
            } else {
                switch newStep.point[1] + wayInt[index] {
                case sizeTorah[1]:
                    newStep.point[1] = 0
                case -1:
                    newStep.point[1] = sizeTorah[1] - 1
                case 0..<sizeTorah[1]:
                    newStep.point[1] += wayInt[index]
                default:
                    print("error")
                }
            }
            
            checkStep = stepVerification(step: newStep)
            
            if checkStep.finish {
                finishStep = true
                break
            }
            if checkStep.stepWay && !noDoublePoint.contains(newStep.point) {
                stepWay.append(newStep)
                noDoublePoint.insert(newStep.point)
                total += 1
            }
        }
        if total == 0  {
            noWay = true
            shortPath = " -1"
        } else {
            total = 1
        }
    }
    
    return stepWay
}

while !finishStep && !noWay {
    completedStep = findingPath(way: completedStep)
}
shortPath.removeFirst()
print(shortPath)

