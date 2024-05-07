//
//  AppointmentManage.swift
//  HMS
//
//  Created by Sarthak on 06/05/24.
//

import SwiftUI
import Firebase

struct AppointmentsView: View {
    @State private var selectedTab: Tab = .upcoming
    @State private var appointments: [AppointmentModel] = []
    @State private var completedAppointments: [AppointmentModel] = []
    @State private var upcomingAppointments: [AppointmentModel] = []
    @EnvironmentObject var userTypeManager: UserTypeManager

    enum Tab {
        case upcoming
        case completed
    }

    var body: some View {
        VStack {
            // All Appointments Text Section
            Text("All Appointments")
                .font(.title)
                .padding(.top, 20) // Add padding to the top of the text

            // Tab Selection Buttons
            HStack {
                // Upcoming Appointments Button
                Button(action: {
                    selectedTab = .upcoming
                }) {
                    Text("Upcoming")
                        .padding()
                        .foregroundColor(selectedTab == .upcoming ? .blue : .black)
                }
                .background(selectedTab == .upcoming ? Color.blue.opacity(0.2) : Color.clear)
                .cornerRadius(10)

                // Completed Appointments Button
                Button(action: {
                    selectedTab = .completed
                }) {
                    Text("Completed")
                        .padding()
                        .foregroundColor(selectedTab == .completed ? .blue : .black)
                }
                .background(selectedTab == .completed ? Color.blue.opacity(0.2) : Color.clear)
                .cornerRadius(10)
            }
            .padding()

            // Display Content Based on Selected Tab
            switch selectedTab {
            case .upcoming:
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(upcomingAppointments, id: \.id) { appointment in
                            DoctorInfoAppointmentTab(appointments: $appointments, appointment: appointment, backgroundColor: .blue)

                        }
                    }
                    .padding()
                }
            case .completed:
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(completedAppointments, id: \.id) { appointment in
                            DoctorInfoAppointmentTab(appointments: $appointments, appointment: appointment, backgroundColor: .blue)

                        }
                    }
                    .padding()
                }
            }

            Spacer()
        }
        .navigationTitle("Appointments")
        .onAppear {
            fetchAppointments()
        }
    }

    private func fetchAppointments() {
        let db = Firestore.firestore()
        let appointmentsRef = db.collection("appointments")
        let today = Date()
        appointmentsRef
            .whereField("PatID", isEqualTo: userTypeManager.userID)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting appointments: \(error.localizedDescription)")
                } else if let querySnapshot = querySnapshot {
                    var fetchedAppointments: [AppointmentModel] = []
                    var completedAppointments: [AppointmentModel] = []
                    var upcomingAppointments: [AppointmentModel] = []
                    for document in querySnapshot.documents {
                        if let appointment = AppointmentModel(document: document.data(), id: document.documentID) {
                            fetchedAppointments.append(appointment)
                            if appointment.isComplete || appointment.date < today {
                                completedAppointments.append(appointment)
                            } else {
                                upcomingAppointments.append(appointment)
                            }
                        }
                    }
                    // Sort fetched appointments by date and time
                    fetchedAppointments.sort {
                        $0.date < $1.date || ($0.date == $1.date && $0.timeSlot < $1.timeSlot)
                    }
                    DispatchQueue.main.async {
                        self.appointments = fetchedAppointments
                        self.completedAppointments = completedAppointments
                        self.upcomingAppointments = upcomingAppointments
                    }
                }
            }
    }


}

struct AppointmentView: View {
    let appointment: AppointmentModel

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Dr. \(appointment.doctorName ?? "")")
                        .font(.subheadline)
                    Text(appointment.doctorSpecialisation ?? "")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("Appointment Date: \(appointment.formattedDate)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 4)
    }
}
