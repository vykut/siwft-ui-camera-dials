//
//  ISODialView.swift
//  ISODialView
//
//  Created by Victor Socaciu on 24.11.2020.
//

import SwiftUI

struct ISODialView: View {
    
    @Binding var isoValue: ISOValue
    @Binding var scale: CGFloat
    
    @State var temporaryRotation: CGFloat = 0.0 // radians
    @State var rotation: CGFloat = 0.0 // radians
    
    let minVal: Int = 0
    var maxVal: Int = ISOValue.allCases.count
    let hapticGenerator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        ZStack {
            Image("iso_dial_outer_ring")
            Image("iso_dial_values_ring")
                .rotationEffect(.radians(Double(temporaryRotation)))
                .gesture(
                    DragGesture(minimumDistance: 2.0)
                        .onChanged({ value in
                            change(dragValue: value)
                        })
                        .onEnded({ _ in
                            withAnimation {
                                temporaryRotation = CGFloat(angle(isoValue: isoValue).radians)
                            }
                            rotation = temporaryRotation
                        })
                )
            Image("iso_dial_middle")
        } // zstack
        .scaleEffect(scale)
        .fixedSize()
    }
    
    private func change(dragValue: DragGesture.Value) {
        let startAngle = atan2(dragValue.startLocation.y - 115, dragValue.startLocation.x - 115)
        let endAngle = atan2(dragValue.location.y - 115, dragValue.location.x - 115)
        // get angle of swipe
        let angle = startAngle - endAngle
        
        // convert angle of swipe to rotation of the dial
        let rotationAngle = rotation - angle
        // convert rotation from -pi...pi to 0...2pi
        let rotationAngleConverted =  rotationAngle + 2 * .pi
        // make sure rotation is always between 0...2pi
        temporaryRotation = CGFloat(fmodf(Float(rotationAngleConverted), 2 * .pi))
        let oldIsoValue = isoValue
        // update the isoValue
        isoValue = ISOValue(angle: temporaryRotation)
        // if the new isoValue != oldIsoValue then provide haptic feedback
        if isoValue != oldIsoValue {
            hapticGenerator.impactOccurred()
        }
    }
    
    private func angle(isoValue: ISOValue) -> Angle {
        let cases = ISOValue.allCases.count
        let caseRadians = 2.0 * .pi / CGFloat(cases)
        
        var angle: CGFloat
        if isoValue == .twenty, temporaryRotation > .pi {
            angle = 2 * .pi
        } else if isoValue == .twenty, temporaryRotation < .pi {
            angle = 0
        } else {
            angle = caseRadians * CGFloat(isoValue.rawValue)
        }
        
        return Angle(radians: Double(angle))
    }
}

public enum ISOValue: Int, CaseIterable {
    case twenty = 0
    case empty // empty spot on the wheel - do not remove
    case auto
    case sixtyFourHundred
    case thirtyTwoHundred
    case tenHundred
    case eightHundred
    case fourHundred
    case twoHundred
    case oneHundred
    case fifty
    case twentyFive
    
    init(angle radians: CGFloat) {
        
        let cases = ISOValue.allCases.count
        let caseRadians = 2.0 * .pi / CGFloat(cases)
        
        let midVal = caseRadians / 2
        
        switch true {
        case radians < caseRadians:
            self = ISOValue.twenty
        case radians >= 2 * caseRadians && radians < 2 * caseRadians + midVal:
            self = ISOValue.auto
        case radians >= 3 * caseRadians - midVal && radians < 3 * caseRadians + midVal:
            self = ISOValue.sixtyFourHundred
        case radians >= 4 * caseRadians - midVal && radians < 4 * caseRadians + midVal:
            self = ISOValue.thirtyTwoHundred
        case radians >= 5 * caseRadians - midVal && radians < 5 * caseRadians + midVal:
            self = ISOValue.tenHundred
        case radians >= 6 * caseRadians - midVal && radians < 6 * caseRadians + midVal:
            self = ISOValue.eightHundred
        case radians >= 7 * caseRadians - midVal && radians < 7 * caseRadians + midVal:
            self = ISOValue.fourHundred
        case radians >= 8 * caseRadians - midVal && radians < 8 * caseRadians + midVal:
            self = ISOValue.twoHundred
        case radians >= 9 * caseRadians - midVal && radians < 9 * caseRadians + midVal:
            self = ISOValue.oneHundred
        case radians >= 10 * caseRadians - midVal && radians < 10 * caseRadians + midVal:
            self = ISOValue.fifty
        case radians >= 11 * caseRadians - midVal && radians < 11 * caseRadians + midVal:
            self = ISOValue.twentyFive
        case radians >= 12 * caseRadians - midVal:
            self = ISOValue.twenty
        default:
            self = ISOValue.auto
        }
    }
}

struct DialView_Previews: PreviewProvider {
    static var previews: some View {
        ISODialView(isoValue: .constant(.twenty), scale: .constant(1))
    }
}
