//
//  Color.swift
//  Nonymous
//
//  Created by Bruke Wondessen on 10/12/23.
//

import SwiftUI

extension Color {
    static var theme = ColorThemeMain()
}

struct ColorThemeMain {
    let accent = Color("AccentColor")
    let background = Color("AppBackgroundColor")
    let othersBubbleBackground = Color("OthersBubbleColor")
    let SendersBubbleBackground = Color("SendersBubbleColor")
    //let secondaryText = Color("SecondaryTextColor")
}
