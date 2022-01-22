//
//  Demo.swift
//  ReceiptSplitter
//
//  Created by Hugo Queinnec on 22/01/2022.
//

import SwiftUI
import Combine

struct Demo: View {
    @State var count = 0
    @State private var canTouchDown = true
    
    let detector: CurrentValueSubject<CGFloat, Never>
    let publisher: AnyPublisher<CGFloat, Never>

    init() {
        let detector = CurrentValueSubject<CGFloat, Never>(0)
        self.publisher = detector
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .dropFirst()
            .eraseToAnyPublisher()
        self.detector = detector
    }
    
    var body: some View {
        VStack {
            Text("\(count)")
                .font(.largeTitle)
            Text(canTouchDown ? "true" : "false")
                .font(.largeTitle)
            
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(0...100, id: \.self) { i in
                        Rectangle()
                            .frame(width: 200, height: 100)
                            .foregroundColor(.green)
                            .overlay(Text("\(i)"))
                    }
                }
//                .gesture(
//                    DragGesture(minimumDistance: 0)
//                        .onChanged { value in
//                            if canTouchDown {
//                                //print(“Touch down”)
//                            }
//                            canTouchDown = false
//                        }
//                        .onEnded { value in
//                            //print(“Touch up”)
//                            canTouchDown = true
//                        }
//                )
                .frame(maxWidth: .infinity)
                .background(GeometryReader {
                    Color.clear.preference(key: ViewOffsetKey.self,
                        value: -$0.frame(in: .named("scroll")).origin.y)
                })
                .onPreferenceChange(ViewOffsetKey.self) { detector.send($0) }

            }
            .coordinateSpace(name: "scroll")
            .onReceive(publisher) {
                print("Stopped on: \($0)")
                count+=1
            }
        }
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

struct Demo_Previews: PreviewProvider {
    static var previews: some View {
        Demo()
    }
}
