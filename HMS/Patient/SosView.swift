//
//  SosView.swift
//  HMS
//
//  Created by Arul Gupta  on 02/05/24.
//

import SwiftUI

struct SosView: View {
    @State var isOn: Bool = false
    @State private var countdownTimer: Timer?
    @State var countdown: Int = 5
    
    var body: some View {
        ZStack{
            Image("BackBlur")
                .resizable()
                .blur(radius: 50.0)
            
            VStack {
                
                Text("Medical Emergency")
                    .font(.title)
                    .fontWeight(.bold)
                    
                    
                
                
                Toggle("", isOn: $isOn)
                    .toggleStyle(CustomToggleStyle(isOn: $isOn))
                    .padding(80)
                
        
                Circle()
                    .fill(.white.opacity(0.3))
                    .frame(width: 130)
                    .padding(80)
                    .overlay(
                        Text("\(countdown)")
                            .foregroundColor(.red)
                            .font(.title)
                    )
                    .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                        if isOn && countdown > 0 {
                            countdown -= 1
                        }
                    }
                
                
                VStack {
                    Button(action: {
                        countdownTimer?.invalidate()
                        countdown = 5
                        isOn = false
                       
                    }) {
                        
                        Image("closebutton")
                            .resizable()
                            .foregroundColor(.gray)
                            .frame(width: 70, height: 70)
                        
                            
                }
                    Text("Cancel")
                        
                }


            }
        }
    }
}



struct CustomToggleStyle: ToggleStyle {
    var onImageName: String = "img1"
    var offImageName: String = "img2"
    @Binding var isOn: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        let dragGesture = DragGesture(minimumDistance: 1)
            .onChanged { _ in
                withAnimation {
                    configuration.isOn.toggle()
                }
            }
        
        return HStack {
            configuration.label
            
            ZStack{
                Rectangle()
                    .foregroundColor(configuration.isOn ? .red : .gray.opacity(0.8))
                    .frame(width: 250, height: 80)
                    .overlay(
                        Image("imgSos")
                            .resizable()
                            .frame(width: 75,height: 75)
                            .offset(x: isOn ? 85 : -85, y: 0) // Adjust offset dynamically
                            .animation(Animation.linear(duration: 0.1))
                    )
                
                    .cornerRadius(40)
                    .gesture(dragGesture)
                
                Text("Emergency")
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SosView()
    }
}
