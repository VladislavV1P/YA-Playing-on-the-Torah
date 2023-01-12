import Foundation

let input = readLine()

var inputTest = """
4 4
0 1 3 2
1 0 0 0
1 0 1 0
0 0 0 0
0 0 0 0
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

var startPoint = pointSF[0...1]
startPoint[0] += sizeTorah[0]
startPoint[1] += sizeTorah[1]
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



var way  = [(point: startPoint, pathTraveled: " 1")]

way[0].point[0] += 1
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
            
            for finish in finishPoint {
                if finish == step.point {
                    shortPath = step.pathTraveled
                    totalFinish = true
                }
            }
            
            for obstacle in obstaclePoints {
                if obstacle == step.point {
                    stepPath = false
                } else {
                    stepPath = true
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
            var stepWay = [([Int], String)]()
            let wayString = ["E","W","N","S"]
            let wayInt = [1,-1,1,-1]
            
            for step in way {
                var newStep = step
                var checkStep = (
                    finish: false,
                    stepWay: true)
                
                
                for index in wayString.indices {
                    
                    var str = newStep.pathTraveled.last ?? "W"
                    if String(str) != wayString[index] {
                        newStep.pathTraveled += wayString[index]
                        if index < 2 {
                            newStep.point[1] += wayInt[index]
                        } else {
                            newStep.point[0] += wayInt[index]
                        }
                    }
                    checkStep = stepVerification(step: newStep)
                    print(checkStep)
                    if checkStep.finish {
                        finishStep = true
                    }
                    if checkStep.stepWay {
                        stepWay.append(newStep)
                        newStep.pathTraveled.removeLast()
                        newStep.point = step.point
                        
                    } else {
                        total += 1
                    }
                }
                if total == way.count  {
                    noWay = true
                }
            }
        }

findingPath(way: [(point: [4,5], pathTraveled: " "), (point: [5,6], pathTraveled: " N")])
