//
//  ContentView.swift
//  SpinLetterTiles
//
//  Created by Mike Lewis on 11/11/25.
//

import SwiftUI


struct ContentView: View {
    @State private var tileAngles: [Double] = [0, 0, 0, 0]
    @State private var tilesLetters: [[String]] = [
        ["A", "B", "C", "D"],
        ["G", "H", "I", "J"],
        ["P", "Q", "R", "S"],
        ["W", "X", "Y", "Z"]
    ]

    private func rotatedIndices(for angle: Double) -> [Int] {
        let step = Int((angle.truncatingRemainder(dividingBy: 360) / 90).rounded()) % 4
        switch step {
        case 1: return [3, 0, 1, 2] // 90 deg
        case 2: return [2, 3, 0, 1] // 180 deg
        case 3: return [1, 2, 3, 0] // 270 deg
        default: return [0, 1, 2, 3] // 0 deg
        }
    }

    private func mappedLetters(for tileIndex: Int) -> [String] {
        let angle = tileAngles[tileIndex]
        let indices = rotatedIndices(for: angle)
        let letters = tilesLetters[tileIndex]
        return indices.map { letters[$0] }
    }

    private func mappedWords() -> [String] {
        var words: [String] = []
        
        let word = mappedLetters(for: 0)[0] + mappedLetters(for: 0)[3] + mappedLetters(for: 2)[0] + mappedLetters(for: 2)[3]
        
        words.append(word)
        
        return words
    }

    private func swapTiles(_ sourceIndex: Int, _ destinationIndex: Int) {
        withAnimation(.spring(duration: 1.0)) {
            tilesLetters.swapAt(sourceIndex, destinationIndex)
            tileAngles.swapAt(sourceIndex, destinationIndex)
        }
    }

    var body: some View {
        VStack {
            VStack(spacing: 10) {
                HStack {
                    RotatingTileView(
                        letters: tilesLetters[0],
                        rotationAngle: tileAngles[0],
                        tileIndex: 0,
                        onTap: { tileAngles[0] += 90 },
                        onDrop: { sourceIndex in swapTiles(sourceIndex, 0) }
                    )
                    RotatingTileView(
                        letters: tilesLetters[1],
                        rotationAngle: tileAngles[1],
                        tileIndex: 1,
                        onTap: { tileAngles[1] += 90 },
                        onDrop: { sourceIndex in swapTiles(sourceIndex, 1) }
                    )
                }
                HStack {
                    RotatingTileView(
                        letters: tilesLetters[2],
                        rotationAngle: tileAngles[2],
                        tileIndex: 2,
                        onTap: { tileAngles[2] += 90 },
                        onDrop: { sourceIndex in swapTiles(sourceIndex, 2) }
                    )
                    RotatingTileView(
                        letters: tilesLetters[3],
                        rotationAngle: tileAngles[3],
                        tileIndex: 3,
                        onTap: { tileAngles[3] += 90 },
                        onDrop: { sourceIndex in swapTiles(sourceIndex, 3) }
                    )
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                ForEach(0..<tilesLetters.count, id: \.self) { i in
                    let letters = mappedLetters(for: i)
                    Text("Tile \(i + 1): [\(letters.joined(separator: " "))]")
                        .font(.body.monospaced())
                        .foregroundColor(.primary)
                }
            }
            .padding(.top, 16)
            
            Text("\(mappedWords()[0])")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .padding()
    }
}

#Preview {
    ContentView()
}
