import Foundation

let input = readLine()

var inputTest = """
10 10
1 0 8 8
1 0 1 0 0 0 0 0 0 1
0 0 0 0 1 0 0 1 0 0
0 0 0 0 0 0 0 0 0 0
0 0 0 1 0 0 1 1 0 0
0 0 1 0 0 0 0 0 0 0
1 0 0 0 0 0 0 0 0 1
1 0 0 0 0 0 0 0 0 0
0 1 1 1 1 1 1 1 1 0
0 0 0 0 0 0 0 0 0 1
1 1 1 1 1 1 1 1 1 1
"""

let inputString = input ?? inputTest

let dataInput =  inputString
    .components(separatedBy: "\n")
let sizeTorah = dataInput[0]
    .split(separator: " ")
    .compactMap({ Int(String($0)) })
sizeTorah
let pointSF = dataInput[1]
    .split(separator: " ")
    .compactMap({ Int(String($0)) })

var startPoint = Array<Int>()
startPoint.append(pointSF[0] + sizeTorah[0])
startPoint.append(pointSF[1] + sizeTorah[1])
startPoint
var finishPoint = [Array<Int>]()
finishPoint.append([pointSF[2] + sizeTorah[0], pointSF[3] + sizeTorah[1]])
finishPoint

func generateObstaclePoints(
    points: [String],
    sizeTorah: [Int] ) -> [Array<Int>] {
        var totalObstaclePoints = [Array<Int>]()
        var row = sizeTorah[0]
        var col = sizeTorah[1]
        for index in 2 ... row + 1 {
            let obstacle = dataInput[index].split(separator: " ").compactMap({ Int(String($0)) })
            for item in obstacle {
                if item > 0 {
                    totalObstaclePoints.append([row,col])
                }
                col += 1
            }
            col = sizeTorah[1]
            row += 1
        }
        return totalObstaclePoints
    }

var obstaclePoints  = generateObstaclePoints(
    points: dataInput,
    sizeTorah: sizeTorah)

func generationPoints(
    point: [Array<Int>],
    row: Int,
    col: Int) -> [Array<Int>]
{
    var totalPoints = [Array<Int>]()
    for item in point {
        var newPoint = [item[0], item[1]]
        totalPoints.append(newPoint)
        newPoint = [item[0], item[1] - col]
        totalPoints.append(newPoint)
        newPoint = [item[0], item[1] + col]
        totalPoints.append(newPoint)
        newPoint = [item[0] - row, item[1]]
        totalPoints.append(newPoint)
        newPoint = [item[0] + row, item[1]]
        totalPoints.append(newPoint)
    }
    return totalPoints
}

finishPoint = generationPoints(
    point: finishPoint,
    row: sizeTorah[0],
    col: sizeTorah[1])

obstaclePoints = generationPoints(
    point: obstaclePoints,
    row: sizeTorah[0],
    col: sizeTorah[1])

var completedStep  = [(point: startPoint, pathTraveled: " ")]

var shortPath = "-1"

var noWay = false
var finishStep = false

func stepVerification(step: (
    point: [Int],
    pathTraveled: String)) -> (
        finish: Bool,
        stepWay: Bool) {
            
            var totalFinish = false
            var stepPath = true
            
            if !totalFinish {
                for finish in finishPoint {
                    print("finish \(finish) == step.point \(step.point)")
                    if finish == step.point {
                        shortPath = step.pathTraveled
                        totalFinish = true
                        print("shortPath \(shortPath)  # totalFinish \(totalFinish)")
                        break
                    }
                    print("shortPath \(shortPath)  # totalFinish \(totalFinish)")
                }
                
                for obstacle in obstaclePoints {
                    if totalFinish || !stepPath {
                        print("---")
                        break
                    }
                    print("obstacle \(obstacle) == step.point \(step.point)")
                    if obstacle == step.point {
                        stepPath = false
                    } else {
                        stepPath = true
                    }
                    print("stepPath \(stepPath)")
                }
            }
            return (finish: totalFinish,
                    stepWay: stepPath)
        }

func findingPath(
    way: [(
        point: [Int],
        pathTraveled: String)]) {
            
            var total = 0
            var stepWay = [(
                point: [Int],
                pathTraveled: String)]()
            let wayString = ["E","W","N","S"]
            let wayInt = [1,-1,1,-1]
            
            for step in way {
//                var newStep = step
                var checkStep = (
                    finish: false,
                    stepWay: true)
                
                print("findingPath 1 step \(step)")
                
                for index in wayString.indices {
                    var newStep = step
                    if checkStep.finish {
                        break
                    }
                    
                    var str = newStep.pathTraveled.last ?? "W"
                    print("wayString \(String(str)) != wayString[index] \(wayString[index])")
                    if String(str) != wayString[index] {
                        print("newStep.pathTraveled = \(newStep.pathTraveled)")
                        newStep.pathTraveled += wayString[index]
                        print(" + abc  newStep.pathTraveled = \(newStep.pathTraveled)")
                        if index < 2 {
                            newStep.point[1] += wayInt[index]
                        } else {
                            newStep.point[0] += wayInt[index]
                        }
                        print("newStep.point = \(newStep.point)")
                    }
                    checkStep = stepVerification(step: newStep)
                    print(checkStep)
                    if checkStep.finish {
                        finishStep = true
                    }
                    if checkStep.stepWay {
                        stepWay.append(newStep)
                        total += 1
                    }
                }
                if total == 0  {
                    noWay = true
                    shortPath = " -1"
                } else {
                    total = 0
                }
            }
            stepWay
            completedStep = stepWay
        }

//findingPath(way: completedStep)

while !finishStep && !noWay {
    print("+++")
    findingPath(way: completedStep)
}
shortPath.removeFirst()
print(shortPath)
