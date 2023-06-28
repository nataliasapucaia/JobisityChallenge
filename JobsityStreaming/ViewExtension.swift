//
//  ViewExtension.swift
//  JobsityStreaming
//
//  Created by Natália Sapucaia on 28/06/23.
//

import SwiftUI

extension View {
    func navigationBarBackground(_ background: Color = Color("DarkBlue")) -> some View {
        return self
            .modifier(ColoredNavigationBar(background: background))
    }

}

struct ColoredNavigationBar: ViewModifier {
    var background: Color

    func body(content: Content) -> some View {
        content
            .toolbarBackground(
                background,
                for: .navigationBar
            )
            .toolbarBackground(.visible, for: .navigationBar)
    }
}
