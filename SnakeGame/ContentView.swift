//
//  ContentView.swift
//  SnakeGame
//
//  Created by Caroline Cruz on 18/10/2024.
//

import SwiftUI


struct ContentView: View {
    
    @State private var snake: [(CGFloat, CGFloat)] = [(1, 1), (0, 1), (0, 0)]
    @State private var food: (CGFloat, CGFloat) = (3, 3)
    @State private var direction: (CGFloat, CGFloat) = (1, 0)
    @State private var timer: Timer?
    @State private var gameOver: Bool = false
    private let gridSize: CGFloat = 20
    private let gridCount: CGFloat = 20

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.black)
                .frame(width: gridSize * gridCount, height: gridSize * gridCount)

            // Snake
            ForEach(snake.indices, id: \.self) { index in
                Rectangle()
                    .fill(Color.green)
                    .frame(width: gridSize, height: gridSize)
                    .position(x: snake[index].0 * gridSize + gridSize / 2, y: snake[index].1 * gridSize + gridSize / 2)
            }

            // Food
            Rectangle()
                .fill(Color.red)
                .frame(width: gridSize, height: gridSize)
                .position(x: food.0 * gridSize + gridSize / 2, y: food.1 * gridSize + gridSize / 2)

            // Restart Button
            if gameOver {
                Button(action: restartGame) {
                    Text("Restart")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .position(x: gridSize * gridCount / 2, y: gridSize * gridCount / 2)
            }
        }
        .onAppear(perform: startGame)
        .gesture(DragGesture(minimumDistance: 10)
            .onEnded { value in
                let horizontal = value.translation.width
                let vertical = value.translation.height
                if abs(horizontal) > abs(vertical) {
                    direction = horizontal > 0 ? (1, 0) : (-1, 0)
                } else {
                    direction = vertical > 0 ? (0, 1) : (0, -1)
                }
            }
        )
    }

    func startGame() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            updateGame()
        }
    }

    func updateGame() {
        let newHead = (snake[0].0 + direction.0, snake[0].1 + direction.1)

        // Check for food collision
        if newHead == food {
            snake.insert(newHead, at: 0)
            spawnFood()
        } else {
            snake.insert(newHead, at: 0)
            snake.removeLast()
        }

        // Check for wall collision
        if newHead.0 < 0 || newHead.0 >= gridCount || newHead.1 < 0 || newHead.1 >= gridCount {
            endGame()
        }
    }


    func spawnFood() {
        let randomX = CGFloat(Int.random(in: 0..<Int(gridCount)))
        let randomY = CGFloat(Int.random(in: 0..<Int(gridCount)))
        food = (randomX, randomY)
    }

    func endGame() {
        timer?.invalidate()
        gameOver = true
    }
    
    func restartGame() {
        snake = [(1, 1), (0, 1), (0, 0)] // Reset snake
        food = (3, 3) // Reset food position
        direction = (1, 0) // Reset direction
        gameOver = false // Reset game over state
        startGame() // Restart the timer
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


