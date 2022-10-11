//
//  CardView.swift
//  Flashzilla
//
//  Created by Dominik Hofer on 01.10.22.
//

import SwiftUI

extension Shape {
    func coloredCard(dragging: Bool, offset: CGSize) -> some View {
        self
            .fill(dragging ? (offset.width > 0 ? Color.green : Color.red) : Color.clear)
    }
}

struct CardView: View {
    let card: Card
    var removal: (() -> Void)? = nil
    var wrongRemoval: (() -> Void)? = nil
    let animationDuration = 0.5
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    
    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero
    @State private var cardIsDragging = false
    @State private var feedback = UINotificationFeedbackGenerator()
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(
                    differentiateWithoutColor
                    ? .white
                    : .white
                        .opacity(1 - Double(abs(offset.width / 50)))
                )
                .background(
                    differentiateWithoutColor
                    ? nil
                    : RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .coloredCard(dragging: cardIsDragging, offset: offset)
                )
                .shadow(radius: 10)
            
            VStack {
                if voiceOverEnabled {
                    Text(isShowingAnswer ? card.answer : card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                } else {
                    Text(card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                    
                    if isShowingAnswer {
                        Text(card.answer)
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(Double(offset.width) / 5))
        .offset(x: offset.width * 3, y: 0)
        .opacity(2 - Double(abs(offset.width / 50)))
        .accessibilityAddTraits(.isButton)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    cardIsDragging = true
                    offset = gesture.translation
                    feedback.prepare()
                }
                .onEnded { _ in
                    if abs(offset.width) > 100 {
                        if offset.width > 0 {
                            feedback.notificationOccurred(.success)
                            
                            
                            
                            removal?()
                        } else {
                            feedback.notificationOccurred(.error)
                            
                            wrongRemoval?()
                        }
                    } else {
                        withAnimation(.spring()) {
                            cardIsDragging = false
                            offset = .zero
                        }
                    }
                }
        )
        .onTapGesture {
            isShowingAnswer.toggle()
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.example)
    }
}
