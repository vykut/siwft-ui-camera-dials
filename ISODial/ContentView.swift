//
//  ISODialApp.swift
//  ISODial
//
//  Created by Victor Socaciu on 23.11.2020.
//

import SwiftUI

struct ContentView: View {
    
    @State private var value: ISOValue = .twenty
    
    var body: some View {
        ZStack {
            DialView(isoValue: $value, scale: .constant(1))
        }
    }
}


struct Config {
    let minimumValue: CGFloat
    let maximumValue: CGFloat
    let totalValue: CGFloat
    let knobRadius: CGFloat
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.sizeThatFits)
    }
}
