//
//  HUDProgressView.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 27.10.2020.
//

import SwiftUI

struct HUDProgressView: View {
    var placeHolder: String
    @Binding var show: Bool
    @State var animate = false
    
    var body: some View {
        VStack {
            Circle()
                .stroke(AngularGradient(gradient: .init(colors: [Color(.systemBlue), Color.primary.opacity(0)]), center: .center))
                .frame(width: 80, height: 80)
                .rotationEffect(.init(degrees: animate ? 360 : 0))
         
            Text(placeHolder)
                .fontWeight(.bold)
                
        }
        .padding(.vertical, 25)
        .padding(.horizontal, 35)
//        .background(BlueView())
        .cornerRadius(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color.clear
                .onTapGesture {
                    withAnimation {
                        show.toggle()
                    }
                }
        )
        .onAppear {
            withAnimation(
                Animation.linear(duration: 1.5)
                    .repeatForever(autoreverses: false)) {
                animate.toggle()
            }
        }
    }
}

struct BlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let effect = UIBlurEffect(style: .extraLight)
        let view = UIVisualEffectView(effect: effect)
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

