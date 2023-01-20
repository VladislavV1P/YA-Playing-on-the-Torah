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

var shortPath = "-1"

var noWay = false
var finishStep = false

var checkStep = (finish: false, stepWay: true)

func costSoFar(currentPoint: [Int], sizeTorah: [Int], finish: [Int]) -> Int {
    let midleSizeRow = sizeTorah[0] / 2
    let midleSizeCol = sizeTorah[1] / 2
    let deltaRow = finish[0] - midleSizeRow
    let deltaCol = finish[1] - midleSizeCol
    let xRow = abs(currentPoint[0] - finish[0])
    let yCol = abs(currentPoint[1] - finish[1])
    let sum = xRow + yCol
    let sumX = abs(xRow - midleSizeRow + deltaRow - finish[0])
    let sumY = abs(yCol - midleSizeCol + deltaCol - finish[1])
    let sumXY = sumX + sumY
    
    if xRow <= midleSizeRow && yCol <= midleSizeCol {
        return sum
    } else if  xRow > midleSizeRow && yCol > midleSizeCol{
        return sumXY
    } else if xRow > midleSizeRow {
      return sumX + abs(currentPoint[1] - finish[1])
    } else {
       return sumY + abs(currentPoint[0] - finish[0])
    }
}

let сostStarPoint = costSoFar(currentPoint: startPoint, sizeTorah: sizeTorah, finish: finishPoint)

var completedStep  = [(point: startPoint, pathTraveled: " ", stepCost: сostStarPoint)]

var wayPoints = completedStep
var passedPoints = Set<Array<Int>>()
var totalFinish = false
var stepPath = true

func stepVerification(step: (point: [Int], pathTraveled: String, stepCost: Int)) {
    
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
    
    checkStep = (finish: totalFinish, stepWay: stepPath)
}

func findingPath(way: (point: [Int], pathTraveled: String, stepCost: Int)) {
    
    var stepWay = [(point: [Int], pathTraveled: String, stepCost: Int)]()
    let wayString = ["S","N","E","W"]
    let invertSade = ["N","S","W","E"]
    let wayInt = [1,-1,1,-1]
    checkStep = (finish: false, stepWay: true)
    var step = way
    checkStep.stepWay = true
    
    for index in wayString.indices {
        var newStep = step
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
        stepVerification(step: newStep)
        
        if checkStep.finish {
            finishStep = true
            shortPath = newStep.pathTraveled
            break
        }
        
        if checkStep.stepWay {
            let costPath = costSoFar(currentPoint: newStep.point, sizeTorah: sizeTorah, finish: finishPoint) + costSoFar(currentPoint: newStep.point, sizeTorah: sizeTorah, finish: startPoint)
            newStep.stepCost = costPath
            stepWay.append(newStep)
        }
    }
    completedStep = stepWay
}

var countPath = wayPoints.last!.pathTraveled.count

func findingPath() {
    var minCostPath = wayPoints.last!.stepCost
    var minCostPathPoint = wayPoints.last!
    var passedPointIndex = wayPoints.count - 1
    for index in wayPoints.indices {
        if wayPoints[index].pathTraveled.count < countPath  {
            continue
        }
        if wayPoints[index].stepCost < minCostPath {
            minCostPath = wayPoints[index].stepCost
            minCostPathPoint = wayPoints[index]
            passedPointIndex = index
        }
    }
    countPath = minCostPathPoint.pathTraveled.count - 2
    findingPath(way: minCostPathPoint)
    //    print("minCostPath = \(minCostPath), minCostPathPoint = \(minCostPathPoint)")
    passedPoints.insert(wayPoints[passedPointIndex].point)
    wayPoints.remove(at: passedPointIndex)
    for item in completedStep {
        if passedPoints.contains(item.point) {
            continue
        }
        wayPoints.append(item)
    }
}

while !finishStep && !noWay {
    findingPath()
    if wayPoints.count == 0  {
        noWay = true
        shortPath = " -1"
    }
}
shortPath.removeFirst()
print(shortPath)
