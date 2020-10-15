import UIKit

//var str = "Hello, playground"

//print(str)

public enum FigureType: String
{
    case king = "K"
    case queen = "Q"
    case rook = "R"
    case knight = "N"
    case bishop = "B"
    case pawn = "p"
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
    let x = ch=="a" ?0:(ch=="b" ?1:(ch=="c" ?2:(ch=="d" ?3:(ch=="e" ?4:(ch=="f" ?5:(ch=="g" ?6:7))))))
    let y = 8 - Int(String(str[str.index(after: str.startIndex)] ))!
    return (y, x)
}

protocol ChessProtocol
{
    func initGame() -> Void
    func isAnyFigureInCell(cell: String) -> Bool
    func getFigureFromCell(cell: String) -> Figure
    func setFigureInSell(cell: String, figure: Figure) -> Void
    func isStepAppopriate(from: String, to: String) -> Bool
    func step(from: String, to: String) -> Void
    func checkWin(isWhite: Bool) -> Bool
}

public class ChessGame: ChessProtocol
{
    var field = Array(repeating: Array<Figure?>(repeating: nil, count: 8), count: 8)
    let alphabet = ["a", "b", "c", "d", "e", "f", "g", "h"]
    
    func initGame() -> Void
    {
        for clr in [FigureColors.white, FigureColors.black]
        {
            var line = clr == FigureColors.white ? 1 : 8
            setFigureInSell(cell: "a\(line)", figure: Figure(type: FigureType.rook, clr: clr))
            setFigureInSell(cell: "b\(line)", figure: Figure(type: FigureType.knight, clr: clr))
            setFigureInSell(cell: "c\(line)", figure: Figure(type: FigureType.bishop, clr: clr))
            setFigureInSell(cell: "d\(line)", figure: Figure(type: FigureType.queen, clr: clr))
            setFigureInSell(cell: "e\(line)", figure: Figure(type: FigureType.king, clr: clr))
            setFigureInSell(cell: "f\(line)", figure: Figure(type: FigureType.bishop, clr: clr))
            setFigureInSell(cell: "g\(line)", figure: Figure(type: FigureType.knight, clr: clr))
            setFigureInSell(cell: "h\(line)", figure: Figure(type: FigureType.rook, clr: clr))
            
            line = clr == FigureColors.white ? 2 : 7
            for i in 0...7
            {
                setFigureInSell(cell: "\(alphabet[i])\(line)", figure: Figure(type: FigureType.pawn, clr: clr))
            }
        }
    }
    
    func printField() -> Void
    {
        
        print("   ", terminator: "")
        for i in 0...7
            {print("| \(alphabet[i]) ", terminator: "")}
        print("|")
        
        print("---", terminator: "")
        for _ in 0...7
            {print("|---", terminator: "")}
        print("|---")
        
        for i in 0...7
        {
            print(" \(8 - i) ", terminator: "")
            for cell in field[i]
            {
                if cell == nil
                {print("|   ", terminator: "")}
                else
                {
                    let fig = cell!
                    let isBlack = fig.color == FigureColors.black ? "-" : " "
                    print("|\(isBlack)\(fig.curentType.rawValue)\(isBlack)", terminator: "")
                }
            }
            print("| \(8 - i) ")
            print("---", terminator: "")
            for _ in 0...7
            {print("|---", terminator: "")}
            print("|---")
        }

        print("   ", terminator: "")
        for i in 0...7
        {print("| \(alphabet[i]) ", terminator: "")}
        print("|")
    }
    
    func isAnyFigureInCell(cell: String) -> Bool
    {
        let (i, j) = ChessNotation(str: cell)
        return field[i][j] != nil
    }
    
    func getFigureFromCell(cell: String) -> Figure
    {
        let (i, j) = ChessNotation(str: cell)
        return field[i][j]!
    }
    
    func setFigureInSell(cell: String, figure: Figure) -> Void
    {
        let (i, j) = ChessNotation(str: cell)
        field[i][j] = figure
    }
    
    func isStepAppopriate(from: String, to: String) -> Bool
    {
        
        // is anything here
        if !isAnyFigureInCell(cell: from)
            {return false}
        
        // from and to don't have the same color
        
        let thisFig = getFigureFromCell(cell: from)
        
        let isToEmpty = !isAnyFigureInCell(cell: to)
        let toFig: Figure? = isToEmpty ? nil : getFigureFromCell(cell: to)
        if  !isToEmpty && toFig!.color  == thisFig.color
            {return false}
        
        let (fi, fj) = ChessNotation(str: from)
        let (ti, tj) = ChessNotation(str: to)
        
        if thisFig.curentType == FigureType.pawn
        {
            if thisFig.color == FigureColors.white && !(fi - 1 == ti || fi - 2 == ti && fi == 6)
            {return false}
            if thisFig.color == FigureColors.black && !(fi + 1 == ti || fi + 2 == ti && ti == 1)
            {return false}
            if !(fj - 1 == tj || fj + 1 == tj || ((fj == tj) && isToEmpty))
            {return false}
        }
        else if thisFig.curentType == FigureType.rook || thisFig.curentType == FigureType.queen
        {
            if !(fi == ti || fj == tj)
            {return false}
            if abs(fi - ti) > 1 || abs(fj - tj) > 1
            {
                if fi == ti
                {
                    if (fj < tj)
                    {
                        for i in fj+1..<tj
                        {
                            if field[fi][i] != nil
                            {return false}
                        }
                    }
                    else
                    {
                        for i in tj+1..<fj
                        {
                            if field[fi][i] != nil
                            {return false}
                        }
                    }
                }
                else // fj == tj
                {
                    if (fi < ti)
                    {
                        for i in fi+1..<ti
                        {
                            if field[i][fj] != nil
                            {return false}
                        }
                    }
                    else
                    {
                        for i in ti+1..<fi
                        {
                            if field[i][fj] != nil
                            {return false}
                        }
                    }
                }
            }
        }
        else if thisFig.curentType == FigureType.knight
        {
            if !((abs(fi - ti) == 2 && abs(fj - tj) == 1) || (abs(fi - ti) == 1 && abs(fj - tj) == 2))
            {return false}
        }
        else if thisFig.curentType == FigureType.bishop || thisFig.curentType == FigureType.queen
        {
            if abs(fi - ti) != abs(fj - tj)
            {return false}
            if abs(fi - ti) > 1
            {
                if fi > ti
                {
                    if fj > tj
                    {
                        for i in 1 ..< abs(fi - ti)
                        {
                            if field[ti+i][tj+i] != nil
                            {return false}
                        }
                    }
                    else // fj < tj
                    {
                        for i in 1 ..< abs(fi - ti)
                        {
                            if field[ti+i][tj-i] != nil
                            {return false}
                        }
                    }
                }
                else // fi < ti
                {
                    if fj > tj
                    {
                        for i in 1 ..< abs(fi - ti)
                        {
                            if field[ti-i][tj+i] != nil
                            {return false}
                        }
                    }
                    else // fj < tj
                    {
                        for i in 1 ..< abs(fi - ti)
                        {
                            if field[ti-i][tj-i] != nil
                            {return false}
                        }
                    }
                }
            }
        }
        else if thisFig.curentType == FigureType.king
        {
            if abs(fi - ti) != 1 || abs(fj - tj) != 1
            {return false}
        }
        
        if !isToEmpty && (toFig!).curentType == FigureType.king
        {return false}
        
        return true;
    }
    
    func step(from: String, to: String) -> Void
    {
        if isStepAppopriate(from: from, to: to)
        {
            let thisFig = getFigureFromCell(cell: from)
            let isToEmpty = !isAnyFigureInCell(cell: to)
            let toFig: Figure? = isToEmpty ? nil : getFigureFromCell(cell: to)
            if  !isToEmpty && toFig!.curentType == FigureType.king
            {
                print(" --- Error --- Nobody can't kill king")
            }
            if  !isToEmpty && toFig!.color  != thisFig.color
            {
                print(" \(toFig!.color) \(toFig!.curentType.rawValue) was killed")
            }
            let (fi, fj) = ChessNotation(str: from)
            let (ti, tj) = ChessNotation(str: to)
            field[ti][tj] = field[fi][fj]
            field[fi][fj] = nil
        }
        else
        {
            print(" --- Error --- unappopriate step from \(from) to \(to)")
        }
    }
    
    func checkDoKingCanMoveHere(place: String, whichKingWantToMove: FigureColors) -> Bool
    {
        let isToEmpty = !isAnyFigureInCell(cell: place)
        if(!isToEmpty)
        {
            let figPlace = getFigureFromCell(cell: place)
            if(figPlace.color == whichKingWantToMove)
            {return false}
        }
        
        for i in 0...7
        {
            for j in 0...7
            {
                if field[i][j] != nil && field[i][j]!.color != whichKingWantToMove
                {
                    if(isStepAppopriate(from: "\(alphabet[j])\(8-i)", to: place))
                    {
                        return false
                    }
                }
            }
        }
        
        return true
    }
    
    func checkWin(isWhite: Bool) -> Bool
    {
        let anotherKingColor = isWhite ? FigureColors.black : FigureColors.white
        
        // finding another color king
        var ki = 0, kj = 0;
        for i in 0...7
        {
            for j in 0...7
            {
                if field[i][j] != nil && field[i][j]!.curentType == FigureType.king && field[i][j]!.color == anotherKingColor
                {
                    ki = i;
                    kj = j;
                }
            }
        }
        
        if ki > 0
        {
            if checkDoKingCanMoveHere(place: "\(alphabet[kj])\(8-ki+1)", whichKingWantToMove: anotherKingColor)
            {return false}
            if kj > 0 && checkDoKingCanMoveHere(place: "\(alphabet[kj-1])\(8-ki+1)", whichKingWantToMove: anotherKingColor)
            {return false}
            if kj < 7 && checkDoKingCanMoveHere(place: "\(alphabet[kj+1])\(8-ki+1)", whichKingWantToMove: anotherKingColor)
            {return false}
        }
        else if ki < 7
        {
            if checkDoKingCanMoveHere(place: "\(alphabet[kj])\(8-ki-1)", whichKingWantToMove: anotherKingColor)
            {return false}
            if kj > 0 && checkDoKingCanMoveHere(place: "\(alphabet[kj-1])\(8-ki-1)", whichKingWantToMove: anotherKingColor)
            {return false}
            if kj < 7 && checkDoKingCanMoveHere(place: "\(alphabet[kj+1])\(8-ki-1)", whichKingWantToMove: anotherKingColor)
            {return false}
        }
        
        if kj > 0 && checkDoKingCanMoveHere(place: "\(alphabet[kj-1])\(8-ki)", whichKingWantToMove: anotherKingColor)
        {return false}
        
        if kj < 7 && checkDoKingCanMoveHere(place: "\(alphabet[kj+1])\(8-ki)", whichKingWantToMove: anotherKingColor)
        {return false}
        
        if !checkDoKingCanMoveHere(place: "\(alphabet[kj])\(8-ki)", whichKingWantToMove: anotherKingColor)
        {return false}
        
        return true;
    }
    
}

var game = ChessGame()

game.initGame()
game.printField()
print("white are win \(game.checkWin(isWhite: true))    black are win \(game.checkWin(isWhite: false))")

game.step(from: "f2", to: "f4")
game.printField()
print("white are win \(game.checkWin(isWhite: true))    black are win \(game.checkWin(isWhite: false))")

game.step(from: "e7", to: "e6")
game.printField()
print("white are win \(game.checkWin(isWhite: true))    black are win \(game.checkWin(isWhite: false))")

game.step(from: "g2", to: "g4")
game.printField()
print("white are win \(game.checkWin(isWhite: true))    black are win \(game.checkWin(isWhite: false))")

game.step(from: "d8", to: "h4")
//game.printField()
//print("white are win \(game.checkWin(isWhite: true))    black are win \(game.checkWin(isWhite: false))")



