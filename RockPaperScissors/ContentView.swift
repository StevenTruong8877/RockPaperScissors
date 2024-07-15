//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Steven Truong on 10.07.24.
//

import SwiftUI

enum Moves: String, CaseIterable {
    case rock = "Rock"
    case paper = "Paper"
    case scissors = "Scissors"
}

enum Outcomes: String {
    case playerWinPromptWin = "Player wins, you win 1 point."
    case playerWinPromptLoose = "Player wins, you loose 1 point."
    case computerWinPromptWin = "Computer wins, you loose 1 point."
    case computerWinPromptLoose = "Computer wins, you win 1 point."
    case draw = "Draw, you loose 1 point."
}

struct ContentView: View {
    @State private var computersChoice = Moves.allCases.randomElement()!
    @State private var playersChoice : Moves?
    @State private var shouldWin = Bool.random()
    @State private var score = 0
    @State private var questionCounter = 0
    @State private var alertText = ""
    @State private var showingAlert = false
    @State private var triggerReset = false
    
    
    var body: some View {
        VStack {
            Text("Round \(questionCounter+1)")
                .font(.largeTitle.bold())
                .padding()
            Text("Current score: \(score)")
            Text("Computers choice: \(computersChoice)")
            Text("You should \(shouldWin ? "win" : "lose").")
                .bold()
            Text("Choose your move!")
            HStack {
                ForEach(Moves.allCases, id: \.self) { moves in
                    Button {
                        playersChoice = moves
                        moveTapped()
                        nextRound()
                    }
                label: {
                    Text(moves.rawValue)
                        .font(.system(size: 30))
                }
                }
            }
            .padding()
        }
        .alert(alertText, isPresented: $showingAlert) {
            Button("Continue") {
                if questionCounter == 9 {
                    alertText = "Your final Score is \(score)."
                    triggerReset.toggle()
                } else {
                    questionCounter += 1
                }
            }
        }
        .alert(alertText, isPresented: $triggerReset) {
            Button("Restart the Game", action: reset)
        }
    }
    
    func moveTapped() {
        switch(playersChoice, computersChoice) {
            
        case (.rock, .scissors), (.paper, .rock), (.scissors, .paper):
            if shouldWin {
                alertText = Outcomes.playerWinPromptWin.rawValue
                score += 1
            } else {
                alertText = Outcomes.playerWinPromptLoose.rawValue
                score = (score == 0) ? 0 : (score - 1)
            }
            
        case (.rock, .paper), (.paper, .scissors), (.scissors, .rock):
            if shouldWin {
                alertText = Outcomes.computerWinPromptWin.rawValue
                score = (score == 0) ? 0 : (score - 1)
            } else {
                alertText = Outcomes.computerWinPromptLoose.rawValue
                score += 1
            }
            
        default: alertText = Outcomes.draw.rawValue
            score = (score == 0) ? 0 : (score - 1)
        }
        showingAlert.toggle()
    }
    
    func nextRound() {
        computersChoice = Moves.allCases.randomElement()!
        shouldWin.toggle()
    }
    
    func reset() {
        score = 0
        questionCounter = 0
        nextRound()
    }
}

#Preview {
    ContentView()
}
