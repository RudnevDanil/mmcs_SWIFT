import UIKit

public class Dice
{
    var v1: Int
    var v2: Int
    
    init(val1: Int, val2: Int)
    {
        v1 = -1
        v2 = -1
        
        if (val1 < 0 || val1 > 6 || val2 < 0 || val2 > 6)
        {
            print(" --- Error --- Init values must be [0...6] val1 = \(val1)  val2 = \(val2)")
            return
        }
        v1 = val1
        v2 = val2
    }
    
    func isValInDice(val: Int) -> Bool
    {
        return (val == v1 || val == v2)
    }
    
    func diceAreSame(dice: Dice) -> Bool
    {
        if dice.v1 == v1 && dice.v2 == v2 || dice.v1 == v2 && dice.v2 == v1
        {
            return true
        }
        return false
    }
}

public class Player
{
    // collection hand arr of dices [0...28]
    var hand = Array<Dice>(repeating: Dice(val1: 6, val2: 6), count: 1)
    
    init()
    {
        hand.removeAll()
    }
    
    func getOnHand(dice: Dice) -> Void
    {
        hand.append(dice)
    }
    
    func getOnTable(val: Int) -> Dice?
    {
        if !isValOnHand(val:val)
        {
            return nil
        }
        
        var curentDice = Dice(val1: 6, val2: 6)
        var position: Int
        position = -1
        for i in 0..<hand.count
        {
            if hand[i].isValInDice(val: val)
            {
                curentDice = hand[i]
                position = i
            }
        }
        hand.remove(at: position)
        return curentDice
    }
    
    func isValOnHand(val: Int) -> Bool
    {
        for d in hand
        {
            if d.isValInDice(val: val)
            {
                return true
            }
        }
        return false
    }
}

public class DominoesGame
{
    var leftV = 6
    var rightV = 6
    var numberPlayers: Int
    var bank = Array<Dice>(repeating: Dice(val1: 6, val2: 6), count: 1)
    var players = Array<Player>(repeating: Player(), count: 1)
    
    init(nPlayers: Int)
    {
        numberPlayers = nPlayers
        
        players.removeAll()
        bank.removeAll()
        for i in 0...6
        {
            for j in i...6
            {
                addDiceToBank(val1: i, val2: j)
            }
        }
        
        leftV = 6
        rightV = 6
        addDiceToTable(dice: Dice(val1: 6, val2: 6))
        if !removeDiceFromBank(dice: bank[27])
        {
            print(" --- Error --- removing dice from bank")
        }
    }
    
    func start() -> Void
    {
        for _ in 0..<numberPlayers
        {
            players.append(Player())
        }
        
        for pl in players
        {
            for _ in 0..<5
            {
                let idDice = Int.random(in: 0..<bank.count)
                pl.getOnHand(dice: bank[idDice])
                if !removeDiceFromBank(dice: bank[idDice])
                {
                    print(" --- Error --- removing dice from bank")
                }
            }
        }
        
        var currentPlayertId = 0
        var freeHandCounter = 0
        while !isWin()  && freeHandCounter < numberPlayers
        {
            if currentPlayertId >= numberPlayers
            {
                currentPlayertId = 0
            }
            
            let d1 = players[currentPlayertId].getOnTable(val: leftV)
            let d2 = players[currentPlayertId].getOnTable(val: rightV)
            var founded = false
            var counter = 0
            let maxCouner = 3
            
            while counter < maxCouner && !founded
            {
                print("Player \(currentPlayertId) ... ", terminator: "")
                if d1 != nil || d2 != nil
                {
                    let curDice = d1 == nil ? d2! : d1!
                    print("add to the table dice \(curDice.v1)|\(curDice.v2)")
                    addDiceToTable(dice: curDice)
                    founded = true
                    freeHandCounter = 0
                }
                else
                {
                    if bank.count != 0
                    {
                        print("takes dice from the bank")
                        let index = Int.random(in: 0..<bank.count)
                        players[currentPlayertId].getOnHand(dice: bank[index])
                        bank.remove(at: index)
                        freeHandCounter = 0
                    }
                    else
                    {
                        print("don't have dice and bank is empty")
                        founded = true
                        freeHandCounter += 1
                    }
                }
                counter += 1
            }
            
            currentPlayertId += 1
        }
        if freeHandCounter >= numberPlayers
        {
            print("All players naven't appopriate dice and bank is empty")
            for i in 0..<players.count
            {
                print("Player \(i) have \(players[i].hand.count) dices")
                for d in players[i].hand
                {
                    print("Player \(i)       \(d.v1)|\(d.v2)")
                }
                print("")
            }
            print("On table left value = \(leftV) and right value = \(rightV)")
            print("Today is no winners.")
        }
    }
    
    func addDiceToBank(val1: Int, val2: Int) -> Void
    {
        bank.append(Dice(val1:val1, val2: val2))
    }
    
    func removeDiceFromBank(dice: Dice) -> Bool
    {
        for i in 0..<bank.count
        {
            if bank[i].diceAreSame(dice: dice)
            {
                bank.remove(at: i)
                return true
            }
        }
        return false
    }
    
    func addDiceToTable(dice: Dice) -> Void
    {
        if dice.isValInDice(val: leftV)
        {
            leftV = dice.v1 == leftV ? dice.v2 : dice.v1
        }
        else if dice.isValInDice(val: rightV)
        {
            rightV = dice.v1 == rightV ? dice.v2 : dice.v1
        }
    }
    
    func isAppopriateAddDiceToTable(dice: Dice) -> Bool
    {
        if (dice.isValInDice(val: leftV) || dice.isValInDice(val: rightV))
        {
            return true
        }
        return false
    }
    
    func isWin() -> Bool
    {
        for i in 0..<players.count
        {
            if players[i].hand.count == 0
            {
                print("Player \(i) WIN")
                return true
            }
        }
        return false
    }
}

var game = DominoesGame(nPlayers: 3)
game.start()
