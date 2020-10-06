import Foundation

public class SnakesAndLaddersPlayer: Player {
    public let name: String
    public var score: Int = 0
    
    public init(name: String) {
        self.name = name
    }
}

public class SnakesAndLaddersTracker: SnakesAndLaddersDelegate {
    public init(){}
    
    public func gameDidStartTurn(_ game: TurnbasedGame) {
        print("===-===-===")
    }

    public func playerDidStartTurn(_ player: Player) {
        print("\(player.name) rolls the dice")
    }
}
