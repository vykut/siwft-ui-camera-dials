//
//  CameraDialsApp.swift
//  ISODial
//
//  Created by Victor Socaciu on 23.11.2020.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isoValue: ISOValue = .twenty
    @State private var exposureValue: ExposureValue = .zero
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Group {
                Text("ISO Dial")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("ISO value: \(isoValue.rawValue)")
                    .font(.title2)
                    .fontWeight(.medium)
                
                ISODialView(isoValue: $isoValue, scale: .constant(0.6))
            }
            
            Group {
                ExposureDialView(exposureValue: $exposureValue, scale: .constant(0.6))
                
                Text("Exposure Dial")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("ExposureValue value: \(exposureValue.rawValue)")
                    .font(.title2)
                    .fontWeight(.medium)
            }
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iphone 8")
    }
}
