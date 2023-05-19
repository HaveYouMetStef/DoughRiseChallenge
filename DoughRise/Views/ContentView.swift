//
//  ContentView.swift
//  DoughRise
//
//  Created by Stef Castillo on 5/16/23.
//

import SwiftUI

struct ContentView: View {
    @State private var budget = Budget(id: UUID(), amount: 2000)
    @State private var transactions: [Transaction] = []
    @State private var isPresentingAddTransaction = false
    @State private var selectedTab = 0
    @State private var tempTransactionType = ""
    @State private var transactionAmount = ""
    @State private var spentAmount = ""
    @State private var totalAmount = ""
    
    // Menu Button
    @State private var currentDate = Date()
    @State private var isPresentingDatePicker = false
    
    // Calculate the remaining available amount after deducting spent amount from the budget
    var availableAmount: Double {
        let spentAmount = transactions.reduce(0) { $0 + $1.amount }
        return budget.amount - spentAmount
    }
    
    // Calculate the utilization of the budget as a ratio
    var budgetUtilization: Double {
        return (budget.amount - availableAmount) / budget.amount
    }
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                ZStack {
                    RadialGradient(stops: [
                        .init(color: Color(red: 0.39, green: 0.21, blue: 0.59), location: 0.3),
                        .init(color: Color(red: 1.0, green: 1.0, blue: 1.0), location: 0.3)],
                                   center: .top, startRadius: 200, endRadius: 700)
                        .ignoresSafeArea()
                    
                    VStack(alignment: .leading) {
                        Spacer()
                        
                        HStack {
                            Text("Monthly Budget")
                                .font(.title)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                            Image(systemName: "chevron.down")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Spacer()
                        Spacer()
                        
                        VStack {
                            Text(dateFormatter.string(from: currentDate))
                                .font(.title)
                                .foregroundColor(.green)
                            
                            HStack {
                                Spacer()
                                Text("Spent: $\(String(format: "%.0f", budget.amount - availableAmount))")
                                    .font(.body)
                                
                                Spacer()
                                
                                Text("Available: $\(String(format: "%.0f", availableAmount))")
                                    .font(.body)
                                    .foregroundColor(.green)
                                
                                Spacer()
                                
                                Text("Budget: $2,000")
                                    .font(.body)
                            }
                            HStack {
                                Spacer()
                                
                                ProgressView(value: budgetUtilization)
                                    .accentColor(.white)
                                    .frame(width: 200, height: 10)
                                    .scaleEffect(1.8)
                                
                                Spacer()
                            }
                            .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        
                        Form {
                            ForEach(transactions, id: \.id) { transaction in
                                HStack {
                                    transactionTypeImage(for: transaction.type)
                                        .foregroundColor(.purple)
                                    
                                    VStack(alignment: .leading) {
                                        Text("Spent: $\(transaction.amount, specifier: "%.0f") of $\(transaction.totalAmount, specifier: "%.0f")")
                                        ProgressView(value: transaction.amount / transaction.totalAmount)
                                            .accentColor(.purple)
                                            .frame(height: 10)
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            // Open a modal to add a new transaction
                            isPresentingAddTransaction = true
                            addTransaction(transactionType: "", spentAmount: spentAmount, totalAmount: totalAmount)
                        }) {
                            HStack {
                                Spacer()
                                Image(systemName: "plus")
                                    .padding()
                                    .background(Color.purple)
                                    .foregroundColor(.white)
                                    .cornerRadius(50)
                            }
                            .padding()
                            .sheet(isPresented: $isPresentingAddTransaction) {
                                AddTransactionView(isPresented: $isPresentingAddTransaction) { transactionType, spentAmount, totalAmount in
                                    self.tempTransactionType = transactionType
                                    self.spentAmount = spentAmount
                                    self.totalAmount = totalAmount
                                    addTransaction(transactionType: transactionType, spentAmount: spentAmount, totalAmount: totalAmount)
                                }
                            }
                        }
                    }
                }
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
                
                Text("Trends")
                    .tabItem {
                        Label("Trends", systemImage: "chart.bar.xaxis")
                    }
                    .tag(1)
                
                Text("Transactions")
                    .tabItem {
                        Label("Transactions", systemImage: "creditcard")
                    }
                    .tag(2)
                
                Text("Community")
                    .tabItem {
                        Label("Community", systemImage: "person.3")
                    }
                    .tag(3)
                
                Text("Profile")
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
                    .tag(4)
            }
            .sheet(isPresented: $isPresentingDatePicker) {
                DatePicker("Select Month/Year", selection: $currentDate, displayedComponents: [.date])
                    .datePickerStyle(.compact)
            }
            .onAppear {
                updateBudgetValues()
            }
        }
    }
    
    // Update the budget values based on the spent amount of transactions
    func updateBudgetValues() {
        let spentAmount = transactions.reduce(0.0) { $0 + $1.amount }
        let initialBudget = 2000.0
        budget.amount = Double(initialBudget) - spentAmount
    }
    
    // Add a new transaction to the list
    func addTransaction(transactionType: String, spentAmount: String, totalAmount: String) {
        guard !transactionType.isEmpty, let amount = Double(spentAmount), let total = Double(totalAmount) else {
            return
        }
        
        let newTransaction = Transaction(id: UUID(), amount: amount, date: Date(), type: transactionType, totalAmount: total)
        transactions.append(newTransaction)
        
        updateBudgetValues()
    }
    
    // Helper function to return the appropriate system image based on the transaction type
    func transactionTypeImage(for transactionType: String) -> Image {
        switch transactionType {
        case "Food":
            return Image(systemName: "cart.fill")
        case "Shopping":
            return Image(systemName: "bag.fill")
        case "Transportation":
            return Image(systemName: "car.fill")
        default:
            return Image(systemName: "creditcard")
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
