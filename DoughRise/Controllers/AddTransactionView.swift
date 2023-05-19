//
//  AddTransactionView.swift
//  DoughRise
//
//  Created by Stef Castillo on 5/16/23.
//

import SwiftUI

struct AddTransactionView: View {
    @Binding var isPresented: Bool
    
    @State private var transactionAmount = ""
    @State private var spentAmount = ""
    @State private var totalAmount = ""
    @State private var selectedTransactionType = "Food"
    
    let transactionTypes = ["Food", "Shopping", "Transportation"]
    
    var transactionAdded: ((String, String, String) -> Void)?
    
    var body: some View {
        NavigationView {
            VStack {
                // Picker for selecting transaction type
                Picker("Transaction Type", selection: $selectedTransactionType) {
                    ForEach(transactionTypes, id: \.self) { type in
                        Text(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Text field for entering spent amount
                TextField("Spent Amount", text: $spentAmount)
                    .keyboardType(.decimalPad)
                    .padding()
                
                // Text field for entering total amount
                TextField("Total Amount", text: $totalAmount)
                    .keyboardType(.decimalPad)
                    .padding()
                
                // Button to save the transaction
                Button(action: {
                    // Save the transaction and dismiss the modal
                    isPresented = false
                    transactionAdded?(selectedTransactionType, spentAmount, totalAmount)
                }) {
                    Text("Save")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("Add Transaction")
        }
        .onDisappear {
            isPresented = false
        }
    }
}
