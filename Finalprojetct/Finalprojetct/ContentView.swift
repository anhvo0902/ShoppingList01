//
//  ContentView.swift
//  Finalprojetct
//
//  Created by Vo, Anh Vo on 4/17/24.
//

import SwiftUI

struct ContentView: View {
    struct ShoppingItem: Identifiable {
        let id = UUID()
        var name: String
        var quantity: Int
        var category: ItemCategory
        var isChecked: Bool = false
    }
    
    enum ItemCategory: String {
        case fruit = "Fruit"
        case dairy = "Dairy"
        case bakery = "Bakery"
        case meat = "Meat"
        case beverage = "Beverage"
        // Add more categories as needed
        case other = "Other"
    }
    
    struct SearchBar: View {
        @Binding var text: String
        
        var body: some View {
            HStack {
                TextField("Search", text: $text)
                    .padding(.horizontal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    self.text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .padding(.trailing)
                }
            }
        }
    }
    
    struct ShoppingItemRow: View {
        @Binding var item: ShoppingItem
        
        var body: some View {
            HStack {
                Image(systemName: item.isChecked ? "checkmark.square.fill" : "square")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(item.isChecked ? .yellow : .primary) // Yellow if checked
                    .onTapGesture {
                        self.item.isChecked.toggle()
                    }
                    .padding(.trailing)
                
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.headline)
                        .foregroundColor(.primary) // Text color
                    Text("Category: \(item.category.rawValue)")
                        .font(.subheadline)
                        .foregroundColor(.secondary) // Text color
                }
                
                Spacer()
                
                Text("Qty: \(item.quantity)")
                    .foregroundColor(.primary) // Text color
            }
            .padding()
            .background(Color(UIColor.systemBackground)) // Background color
            .cornerRadius(8)
        }
    }
    
    struct CongratsView: View {
        @Binding var items: [ShoppingItem]
        @Environment(\.presentationMode) var presentationMode
        
        var removedItems: [ShoppingItem] {
            items.filter { $0.isChecked }
        }
        
        var body: some View {
            VStack {
                Spacer()
                Text("Congratulations!")
                    .font(.largeTitle) // Larger font
                    .fontWeight(.bold) // Bold font weight
                    .padding()
                    .foregroundColor(Color(red: 101/255, green: 67/255, blue: 33/255)) // Brown color
                
                if !removedItems.isEmpty {
                    Text("You have removed these items from the shopping list")
                        .font(.headline)
                        .padding()
                        .foregroundColor(.primary) // Text color
                    
                    List(removedItems) { item in
                        Text("\(item.name) - Qty: \(item.quantity)")
                            .foregroundColor(.primary) // Text color
                    }
                    .listStyle(InsetListStyle()) // Apply list style
                }
                
                Spacer()
                
                Button(action: {
                    // Clear items and return to the shopping list
                    self.items.removeAll(where: { $0.isChecked })
                    self.presentationMode.wrappedValue.dismiss() // Dismiss the view
                }) {
                    Text("Back to Shopping List")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.yellow) // Yellow button
                        .cornerRadius(8)
                }
                .padding()
            }
            .navigationBarBackButtonHidden(true) // Hide the default back button
            .navigationBarItems(leading: Button(action: {
                // Navigate back to the shopping list
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.yellow) // Yellow color
                    .imageScale(.large)
                    .padding()
            })
            .background(Color(UIColor(red: 245/255, green: 236/255, blue: 206/255, alpha: 1))) // Light brown background color
            .navigationBarTitle("Congratulations!", displayMode: .inline) // Navigation bar title style
        }
    }
    
    @State private var searchTerm: String = ""
    @State private var items: [ShoppingItem] = [
        ShoppingItem(name: "Apples", quantity: 2, category: .fruit),
        ShoppingItem(name: "Milk", quantity: 1, category: .dairy),
        ShoppingItem(name: "Bread", quantity: 1, category: .bakery),
        ShoppingItem(name: "Chicken", quantity: 1, category: .meat),
        ShoppingItem(name: "Strawberry", quantity: 1, category: .fruit),
        ShoppingItem(name: "Egg", quantity: 12, category: .dairy),
        ShoppingItem(name: "Diet Coke", quantity: 6, category: .beverage),
    ]
    @State private var newItemName: String = ""
    @State private var newItemQuantity: String = ""
    @State private var isCongratsViewPresented: Bool = false
    
    var filteredItems: [ShoppingItem] {
        if searchTerm.isEmpty {
            return items
        } else {
            return items.filter { $0.name.lowercased().contains(searchTerm.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                
                Text("This app will easily help you add or remove any shopping items ")
                    .font(.body) // Set font size to body
                    
                    .padding(.leading, 20)
                    .foregroundColor(.black) // Black text color
                   
                    .frame(maxWidth: .infinity, alignment: .leading) // left align
                    .padding(.bottom, 0)
                    .padding(.top, 10)
                
                
                
                
                
                    .frame(maxWidth: .infinity, alignment: .leading) // left align
                SearchBar(text: $searchTerm)
                    .padding(.horizontal)
                
                List(filteredItems) { item in
                    ShoppingItemRow(item: self.$items[self.items.firstIndex(where: { $0.id == item.id })!])
                }
                
                
                
                    
                HStack {
                    
                    TextField("Item Name", text: $newItemName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .foregroundColor(.yellow) // Yellow text color
                    TextField("Quantity", text: $newItemQuantity)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .keyboardType(.numberPad)
                        .foregroundColor(.yellow) // Yellow text color
                    Button(action: addItem) {
                        Text("Add")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.yellow) // Yellow button
                            .cornerRadius(8)
                    }
                    .padding(.trailing)
                }
                .padding(.top, -15)
               
                
                
                Button(action: {
                    isCongratsViewPresented.toggle()
                }) {
                    Text("Remove")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.yellow) // Yellow button
                        .cornerRadius(8)
                }
                .padding()
                .sheet(isPresented: $isCongratsViewPresented) {
                    CongratsView(items: $items)
                }
            }
            .navigationBarTitle("Shopping List", displayMode: .large) // Navigation bar title style
            .background(Color(UIColor(red: 245/255, green: 236/255, blue: 206/255, alpha: 1))) // Light brown background color
        }
    }
    
    func addItem() {
        guard let quantity = Int(newItemQuantity), quantity > 0 else {
            return
        }
        items.append(ShoppingItem(name: newItemName, quantity: quantity, category: .other))
        newItemName = ""
        newItemQuantity = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


#Preview {
    ContentView()
}


#Preview {
    ContentView()
}
