//
//  ContentView.swift
//  Inventory
//
//  Created by Merouane Bellaha on 18/09/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
    }
}

struct ContentView_Previews: PreviewProvider {

    struct WrapperView: View {
        @State var item = Item(name: "keyboard", color: .green, status: .inStock(quantity: 1))
        var body: some View {
            ItemView(item: $item)
        }
    }
    static var previews: some View {
        return NavigationView {
            WrapperView()
        }
    }
}

struct Item {
    var name: String
    var color: Color?
    var status: Status
    
    enum Status {
        case inStock(quantity: Int)
        case outOfStock(isOnBackOrder: Bool)

        var isInStock: Bool {
            guard case .inStock = self else { return false }
            return true
        }

        var quantity: Int {
            get {
                switch self {
                case .inStock(quantity: let quantity):
                    return quantity
                case .outOfStock:
                    return 0
                }
            }
            set {
                self = .inStock(quantity: newValue)
            }
        }

        var isOnBackOrder: Bool {
            get {
                guard case let .outOfStock(isOnBackOrder) = self else {
                    return false
                }
                return isOnBackOrder
            }
            set {
                self = .outOfStock(isOnBackOrder: newValue)
            }
        }
    }

    enum Color: String, CaseIterable {
        case blue
        case green
        case black
        case red
        case yellow
        case white
    }
}

struct ItemView: View {

    @Binding var item: Item

    var body: some View {
        Form {
            TextField("Name", text: $item.name)
            Picker(selection: $item.color, label: Text("Color")) {
                Text("none")
                    .tag(Item.Color?.none)
                ForEach(Item.Color.allCases, id: \.self) { color in
                    Text(color.rawValue)
                        .tag(Optional(color))
                }
            }

            if self.item.status.isInStock {
                Section(header: Text("In Stock")) {
                    Stepper("Quantity: \(item.status.quantity)", value: $item.status.quantity)
                    Button("Mark as sold out") {
                        self.item.status = .outOfStock(isOnBackOrder: false)
                    }
                }
            } else {
                Section(header: Text("Out of stock")) {
                    Toggle("Is on back order?", isOn: $item.status.isOnBackOrder)
                    Button("is back in stock!") {
                        self.item.status = .inStock(quantity: 1)
                    }
                }
            }
        }
    }
}
