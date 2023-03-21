//
//  CardView.swift
//  SetCardGame
//
//  Created by İbrahim Çetin on 14.03.2023.
//

import SwiftUI

struct CardView: View {
    let card: Card

    var aspectRatio = DrawingConstants.aspectRatio

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                .strokeBorder(lineWidth: DrawingConstants.lineWidth)

            VStack(spacing: DC.spacing) {
                ForEach(0..<card.number.rawValue, id: \.self) { index in
                    ZStack {
                        strokedSymbol
                            .foregroundColor(cardColor)

                        filledSymbol
                            .opacity(cardShading)
                    }
                    .aspectRatio(aspectRatio * 3, contentMode: .fit)
                }
            }
            .padding(DC.spacing)
        }
        .background(cardBackgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: DC.cornerRadius))
    }

    private var cardBackgroundColor: Color? {
        if card.state == .selected {
            return DC.selectedBackgroundColor
        } else if card.state == .unmatched {
            return DC.unmatchedBackgroundColor
        } else if card.state == .matched {
            return nil
        } else {
            return nil
        }
    }

    private var cardColor: Color {
        switch card.color {
        case .red:
            return .red
        case .green:
            return .green
        case .purple:
            return .purple
        }
    }

    private var cardShading: CGFloat {
        switch card.shading {
        case .solid:
            return 1
        case .striped:
            return 0.5
        case .open:
            return 0
        }
    }

    @ViewBuilder
    private var strokedSymbol: some View {
        switch card.shape {
        case .diamond:
            Diamond()
                .stroke(lineWidth: DrawingConstants.lineWidth * 1.5)
        case .squiggle:
            Rectangle()
                .stroke(lineWidth: DrawingConstants.lineWidth * 1.5)
        case .oval:
            Capsule()
                .stroke(lineWidth: DrawingConstants.lineWidth * 1.5)
        }
    }

    @ViewBuilder
    private var filledSymbol: some View {
        switch card.shape {
        case .diamond:
            Diamond()
                .fill(cardColor)
        case .squiggle:
            Rectangle()
                .fill(cardColor)
        case .oval:
            Capsule()
                .fill(cardColor)
        }
    }
}

extension CardView {
    private typealias DC = DrawingConstants

    private struct DrawingConstants {
        static let aspectRatio: CGFloat = 2/3
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
        static let spacing: CGFloat = 10

        static let selectedBackgroundColor: Color = .cyan.opacity(0.3)
        static let matchedBackgroundColor: Color = .green.opacity(0.3)
        static let unmatchedBackgroundColor: Color = .red.opacity(0.3)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.sample)
    }
}
