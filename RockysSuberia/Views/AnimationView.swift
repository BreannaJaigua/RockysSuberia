//
//  AnimationView.swift
//  RockysSuberia
//
//  Created by Andrea Alave on 11/19/25.
//

/*TO DO LIST: Add the text(Caption to images)
 - elongate duration so people have time to read
 - potentially choose the background music for it (8-bit maybe)
 - Work on Case 1 and Case 5 animations
 
 [ALL COMPLETED]
 */

import SwiftUI

struct AnimationView: View {
    
    struct Panel {
        let image: String
        let text: String
    }
    
    //callback
    var onFinish: () -> Void
    
    @State private var index: Int = 0
    @State private var animate: Bool = false
    
    //panel array for images and the text accompanied with them
    let panels: [Panel] = [
        .init(image: "littlejacket", text: "It all started with a simple yellow jacket..."),
        .init(image: "2", text: "who took a bite out of an interesting piece of food..."),
        .init(image: "3", text: "and turned into..."),
        .init(image: "4", text: "A Michelin Star Chef named Rocky!!!"),
        .init(image: "5", text: "And now Rocky takes his hunger to the US to terrorize American sub shops..."),
        .init(image: "6", text: "Starting with Rocky's at the University of Rochester! Complete his sub order to save the university from being a BIG. SUB!")
    ]
    
    let panelDuration: Double = 5.0
    
    var body: some View {
        ZStack {
            Color("AnimationBackgroundColor").ignoresSafeArea()
            ForEach(panels.indices, id: \.self) { i in
                panelView(panel: panels[i], index: i)
                    .opacity(index == i ? 1 : 0)
            }
        }
        .onAppear {
            runSequence()
        }
    }
    
    func runSequence() {
        animate = true
        
        for step in 1..<panels.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + panelDuration * Double(step)) {
                animate = false
                index = step
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    animate = true
                }
            }
        }
        
        //calls the completion handler after last panel
        let totalTime = panelDuration * Double(panels.count)
        DispatchQueue.main.asyncAfter(deadline: .now() + totalTime + 0.1) {
            onFinish()
        }
    }
    //panel view with image and text
    @ViewBuilder
    func panelView(panel: Panel, index panelIndex: Int) -> some View {
        VStack(spacing: 20) {
            
            animatedPanel(image: panel.image, panelIndex: panelIndex)
                .frame(maxHeight: 420)
            // slow fade-in effect
            Text(panel.text)
                .font(.title3)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.accentColor)
                .padding(.horizontal, 30)
                .opacity(animate && self.index == panelIndex ? 1 : 0)
                .animation(.easeIn(duration: 0.6), value: animate)
        }
    }
    //animation cases for each image and word
    @ViewBuilder
    func animatedPanel(image: String, panelIndex: Int) -> some View {
        switch panelIndex {
        case 0: // zoom in
            Image(image)
                .resizable()
                .scaledToFit()
                .scaleEffect(animate ? 1.0 : 0.0)
                .animation(.easeOut(duration: 1.0), value: animate)
        case 1:// slide from right
            Image(image)
                .resizable()
                .scaledToFit()
                .offset(x: animate && index == panelIndex ? 0 : UIScreen.main.bounds.width)
                .animation(.easeOut(duration: 1.0), value: animate)
        case 2:// pop
            Image(image)
                .resizable()
                .scaledToFit()
                .scaleEffect(animate ? 1.0 : 0.0)
                .animation(.spring(response: 0.4, dampingFraction: 0.5), value: animate)
        case 3:// cut
            Image(image)
                .resizable()
                .scaledToFit()
        case 4:// cut
            Image(image)
                .resizable()
                .scaledToFit()
        case 5:// slide from bottom
            Image(image)
                .resizable()
                .scaledToFit()
                .offset(y: animate && index == panelIndex ? 0 : UIScreen.main.bounds.height)
                .animation(.easeOut(duration: 1.0), value: animate)
        default:
            EmptyView()
        }
    }
}


#Preview {
    AnimationView(onFinish: { })
}
