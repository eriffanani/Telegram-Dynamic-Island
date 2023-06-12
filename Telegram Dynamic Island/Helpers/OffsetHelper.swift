//
//  OffsetHelper.swift
//  Telegram Dynamic Island
//
//  Created by Erif Fanani on 05/06/23.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

extension View {
    @ViewBuilder
    func offsetExtractor(coordinateSpace: String, completition: @escaping (CGRect) -> ()) -> some View {
        self.overlay {
            GeometryReader {
                let rect = $0.frame(in: .named(coordinateSpace))
                Color.clear
                    .preference(key: OffsetKey.self, value: rect)
                    .onPreferenceChange(OffsetKey.self, perform: completition)
            }
        }
    }
}

struct OffsetHelper_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
