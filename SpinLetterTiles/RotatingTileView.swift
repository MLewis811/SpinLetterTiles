//
//  RotatingTileView.swift
//  SpinLetterTiles
//
//  Created by Mike Lewis on 11/11/25.
//

import SwiftUI

struct RotatingTileView: View {
    let letters: [String] // must be 4
    let rotationAngle: Double
    let tileIndex: Int
    let onTap: () -> Void
    let onDrop: (Int) -> Void

    private func rotatedIndices() -> [Int] {
        return [0, 1, 3, 2]
    }

    var body: some View {
        let indices = rotatedIndices()
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            ZStack {
                RoundedRectangle(cornerRadius: size * 0.12, style: .continuous)
                    .fill(.thickMaterial)
                    .overlay(RoundedRectangle(cornerRadius: size * 0.12).stroke(.secondary, lineWidth: 2))
                VStack(spacing: 0) {
                    ForEach(0..<2, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<2, id: \.self) { col in
                                let letterIdx = indices[row * 2 + col]
                                ZStack {
                                    Text(letters[letterIdx])
                                        .font(.system(size: size * 0.32, weight: .bold, design: .rounded))
                                        .foregroundStyle(.primary)
                                        .rotationEffect(.degrees(-rotationAngle))
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                }
                            }
                        }
                    }
                }
            }
            .frame(width: size, height: size)
            .rotationEffect(.degrees(rotationAngle))
            .animation(.spring(duration: 1.0), value: rotationAngle)
            .onTapGesture {
                onTap()
            }
            .draggable(tileIndex)
            .dropDestination(for: Int.self) { items, location in
                guard let sourceIndex = items.first else { return false }
                if sourceIndex != tileIndex {
                    onDrop(sourceIndex)
                }
                return true
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .frame(minWidth: 120, minHeight: 120)
    }
}
