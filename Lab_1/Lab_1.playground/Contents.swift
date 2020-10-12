import UIKit

var str = "Hello, playground"

print(str)

public enum FigureType
{
    case king
    case queen
    case rook
    case knight
    case bishop
    case pawn
}

public enum FigureColors
{
    case white
    case black
}

public class Figure
{
    var curentType: FigureType
    var color: FigureColors
    
    init(type: FigureType, clr: FigureColors)
    {
        curentType = type
        color = clr
    }
}

func ChessNotation(str: String) -> (x: Int, y:Int)
{
    if(  str.count != 2
    || !(str[str.startIndex] >= "a" && str[str.startIndex] <= "h")
    || !(str[str.index(after: str.startIndex)] >= "1" && str[str.index(after: str.startIndex)] <= "8") )
    {
        print(" --- Error! wrong chess notation! str = \(str)")
    }
    
    let ch = String(str[str.startIndex]);
    let x = ch=="a" ?0:(ch=="b" ?1:(ch=="c" ?2:(ch=="d" ?3:(ch=="e" ?4:(ch=="f" ?5:(ch=="e" ?6:(ch=="g" ?7:8)))))))
    let y = 8 - Int(String(str[str.index(after: str.startIndex)] ))!
    return (x,y)
}

public protocol GameProtocol {
    func initGame() -> Void
    func isStepAppopriate(from: String, to: String) -> Bool
    func step(from: String, to: String) -> Void
    func checkWin(isWhite: Bool) -> Bool
    func checkIsCellFree(whichCell: String) -> Bool
    func getFigureFromCell(whichCell: String) -> Figure
}
