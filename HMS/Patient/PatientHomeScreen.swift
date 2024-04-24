//
//  HomeView.swift
//  HomeView
//
//  Created by shashwat singh   on 16/03/24.
//

import SwiftUI

struct PatientHomeScreen: View {
    var body: some View {
        ScrollView{
            VStack{
                HStack(spacing:-9){
                    Image(systemName: "person")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .aspectRatio(contentMode: .fit)
                        .padding(.trailing, 10)
                    
                    
                    VStack(alignment: .leading){
                        Text("Hello")
                            .bold()
                            .font(.title)
                            .padding(.leading)
                        
                        Text("Gaurav Ganju")
                            .padding(.horizontal)
                            .font(.title2)
                    }
                    Spacer()
                    
                }
                .padding()
                
                HStack{
                  VitalsView()
                }
                .padding()
                
                VStack {
                    Text("Health Events")
                        .font(.title)
                        .padding(.leading,-180)
                        .bold()
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: -60){
                            HealthEventTabs(title: "Blood Donation", subTitle: "Camp", time: "09:30 AM Onwards", eventCount: 12, dayOfWeek: "Tue")
                            HealthEventTabs(title: "Blood Donation", subTitle: "Camp", time: "09:30 AM Onwards", eventCount: 12, dayOfWeek: "Tue")
                        }
                        .padding(.leading,-15)
                    }
                }
//                .padding(.vertical)
                
                VStack {
                    Text("My Appointments")
                        .font(.title)
                        .bold()
                        .padding(.leading,-118)
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: -4){
                            DoctorInfoAppointmentTab(backgroundColor: .blue)
                            DoctorInfoAppointmentTab(backgroundColor: .blue)
                        }
                        .padding(.leading,4)
                    }
                }
                .padding(.vertical,6)
            }
        }.background(Color.white.opacity(0.2))
    }
}

#Preview {
    PatientHomeScreen()
}