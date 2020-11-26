//
//  ExposureDialView.swift
//  ExposureDialView
//
//  Created by Victor Socaciu on 26.11.2020.
//

import SwiftUI

struct ExposureDialView: View {
    
    @Binding var exposureValue: ExposureValue
    @Binding var scale: CGFloat
    
    @State var temporaryRotation: CGFloat = 0.0 // radians
    @State var rotation: CGFloat = 0.0 // radians
    
    let minVal: Int = 0
    var maxVal: Int = ExposureValue.allCases.count
    let hapticGenerator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        ZStack {
            Image("exposure_background")
            Image("exposure_dial_values_ring")
                .rotationEffect(.radians(Double(temporaryRotation)))
                .gesture(
                    DragGesture(minimumDistance: 2.0)
                        .onChanged({ value in
                            change(dragValue: value)
                        })
                        .onEnded({ _ in
                            withAnimation {
                                temporaryRotation = CGFloat(angle(exposureValue: exposureValue).radians)
                            }
                            rotation = temporaryRotation
                        })
                )
        } // zstack
        .scaleEffect(scale)
        .fixedSize()
    }
    
    private func change(dragValue: DragGesture.Value) {
        let startAngle = atan2(dragValue.startLocation.y - 103.5, dragValue.startLocation.x - 103.5)
        let endAngle = atan2(dragValue.location.y - 103.5, dragValue.location.x - 103.5)
        // get angle of swipe
        let angle = startAngle - endAngle
        
        // convert angle of swipe to rotation of the dial
        let rotationAngle = rotation - angle
        // convert rotation from -pi...pi to 0...2pi
        let rotationAngleConverted =  rotationAngle + 2 * .pi
        // make sure rotation is always between 0...2pi
        temporaryRotation = CGFloat(fmodf(Float(rotationAngleConverted), 2 * .pi))
        let oldExposureValue = exposureValue
        // update the exposureValue
        exposureValue = ExposureValue(angle: temporaryRotation)
        // if the new exposureValue != oldExposureValue then provide haptic feedback
        if exposureValue != oldExposureValue {
            hapticGenerator.impactOccurred()
        }
    }
    
    private func angle(exposureValue: ExposureValue) -> Angle {
        let cases = ExposureValue.allCases.count
        let caseRadians = 2.0 * .pi / CGFloat(cases)
        
        var angle: CGFloat
        if exposureValue == .zero, temporaryRotation > .pi {
            angle = 2 * .pi
        } else if exposureValue == .zero, temporaryRotation < .pi {
            angle = 0
        } else {
            angle = caseRadians * CGFloat(exposureValue.rawValue)
        }
        
        return Angle(radians: Double(angle))
    }
}

public enum ExposureValue: Int, CaseIterable {
    case zero = 0
    case negativeOne
    case negativeTwo
    case negativeThree
    case empty // empty spot on the wheel - do not remove
    case positiveThree
    case positiveTwo
    case positiveOne
    
    init(angle radians: CGFloat) {
        
        let cases = ExposureValue.allCases.count
        let caseRadians = 2.0 * .pi / CGFloat(cases)
        
        let midVal = caseRadians / 2
        
        switch true {
        case radians < 1 * caseRadians - midVal:
            self = ExposureValue.zero
        case radians >= 1 * caseRadians - midVal && radians < 1 * caseRadians + midVal:
            self = ExposureValue.negativeOne
        case radians >= 2 * caseRadians - midVal && radians < 2 * caseRadians + midVal:
            self = ExposureValue.negativeTwo
        case radians >= 3 * caseRadians - midVal && radians < 4 * caseRadians:
            self = ExposureValue.negativeThree
        case radians >= 4 * caseRadians && radians < 5 * caseRadians + midVal:
            self = ExposureValue.positiveThree
        case radians >= 6 * caseRadians - midVal && radians < 6 * caseRadians + midVal:
            self = ExposureValue.positiveTwo
        case radians >= 7 * caseRadians - midVal && radians < 7 * caseRadians + midVal:
            self = ExposureValue.positiveOne
        case radians >= 8 * caseRadians - midVal:
            self = ExposureValue.zero
        default:
            self = ExposureValue.zero
        }
    }
}

struct Exposure_DialView_Previews: PreviewProvider {
    static var previews: some View {
        ExposureDialView(exposureValue: .constant(.zero), scale: .constant(1))
    }
}
