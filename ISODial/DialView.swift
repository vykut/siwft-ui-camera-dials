//
//  DialView.swift
//  ISODial
//
//  Created by Victor Socaciu on 24.11.2020.
//

import SwiftUI

struct DialView: View {
    
    @Binding var isoValue: ISOValue
    @State var angleValue: CGFloat = 0.0
    @Binding var scale: CGFloat
    
    let minVal: Int = 0
    var maxVal: Int = ISOValue.allCases.count
    let hapticGenerator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        ZStack {
            Image("iso_dial_outer_ring")
            Image("iso_dial_numbers_ring")
                .rotationEffect(.degrees(Double(angleValue)))
                .gesture(DragGesture(minimumDistance: 2.0)
                            .onChanged({ value in
                                change(location: value.location, startLocation: value.startLocation)
                            }))
            Image("iso_dial_middle_knob")
            
            Text("\(isoValue.rawValue)")
                .font(.system(size: 50))
                .fontWeight(.medium)
                .foregroundColor(.white)
        } // zstack
        .scaleEffect(scale)
        .fixedSize()
        
    }
    
    private func change(location: CGPoint, startLocation: CGPoint) {
        // geting angle in radian need to subtract the knob radius and padding from the dy and dx
        
        //check how rotation gesture works explicitly
        
//        let position = location
//        let target = center of view
//        let angle = atan2(target.y-position.y, target.x-position.x)
        
        let angle = atan2(location.y - 115, location.x - 115) + .pi
        
        // convert angle range from (-pi to pi) to (0 to 2pi)
        let fixedAngle = angle < 0.0 ? angle + 2.0 * .pi : angle
        // convert angle value to base10 value
        let value = (fixedAngle * CGFloat(maxVal)) / (2.0 * .pi)
        // convert value to integer
        let intValue = Int(value.rounded())
        
        if intValue != self.isoValue.rawValue, intValue != 1 {
            print("value: \(value)")
            print("intValue: \(intValue)")
            print("self.isoValue: \(self.isoValue)")
            print("angleValue: \(angleValue)")
            print()
            
            hapticGenerator.impactOccurred()
        }
        
        if intValue != 1, intValue <= maxVal {
            self.isoValue = intValue == 0 ? ISOValue.twenty : ISOValue(rawValue: intValue)!
            
//            angleValue += CGFloat(intValue) * 30.0
            angleValue = CGFloat(intValue) * 30.0
//                        angleValue = (fixedAngle * 180 / .pi)
        }
    }
}

public enum ISOValue: Int, CaseIterable {
    case auto = 2
    case sixtyFourHundred
    case thirtyTwoHundred
    case tenHundred
    case eightHundred
    case fourHundred
    case twoHundred
    case hundred
    case fifty
    case twentyFive
    case twenty
}

struct DialView_Previews: PreviewProvider {
    static var previews: some View {
        DialView(isoValue: .constant(.twenty), scale: .constant(1))
    }
}
