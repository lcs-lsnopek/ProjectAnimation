//
//  CompletionMeterView.swift
//  ComposableViewsAndAnimations
//
//  Created by Russell Gordon on 2021-02-23.
//

import SwiftUI
import UIKit

struct CompletionMeterView: View {
    
    // MARK: Stored properties
    
    // Show completion up to what percentage?
    let fillToValue: CGFloat
    
    // Controls the amount of trim to show, as a percentage
    @State private var completionAmount: CGFloat = 0.0
    
    // Whether to apply the animation
    @State private var useAnimation = false
    
   @State var opacity1 = 0.0
    
    @State var opacity2 = 1.0
    
    
    // NOTE: Here, we use a timer to initiate the state changes.
    //       In the implicit animation examples given earlier, the USER
    //       initiated state changes by, for example, clicking on the red circle.
    //
    // Set timer so that completion amount changes on a regular basis
    let timer = Timer.publish(every: 0.03, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        ZStack {
            
            Circle()
                
                // Traces, or makes a trim, for the outline of a shape
                // 0 is no trim, 1 is trim around the entire outline of the shape
                .trim(from: 0, to: completionAmount)
                .stroke(Color.red, lineWidth: 20)
                .frame(width: 200, height: 200)
                .rotationEffect(.degrees(-90))
                .opacity(opacity2)
                // When the timer fires, the code in this block will run.
                .onReceive(timer) { _ in
                    
                    // Stop when completion amount reaches the fill to value
                    guard completionAmount < fillToValue / 100.0 else {
                        
                        // Stop the timer from continuing to fire
                        timer.upstream.connect().cancel()
                        opacity1 = 1.0
                        opacity2 = 0.0
                        return
                    }
                    
            
                    
                    // Animate the trim being closed
                    withAnimation(.default) {
                        completionAmount += fillToValue / 100.0 / 100.0
                    }
                    
                }
            
            Text("emoji")
                .opacity(opacity1)
                .animation(.easeInOut(duration: 2))
                .scaleEffect(4)
            
            Text("\(String(format: "%3.0f", (completionAmount) * 100.0))%")
                .font(Font.custom("Courier-Bold", size: 24.0))
                .opacity(opacity2)
                .animation(.default)
                

        }
    }
    
}

struct CompletionMeterView_Previews: PreviewProvider {
    static var previews: some View {
        CompletionMeterView(fillToValue: 75)
    }
}
