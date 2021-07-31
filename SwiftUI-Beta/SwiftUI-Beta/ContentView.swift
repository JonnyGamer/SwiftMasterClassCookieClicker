//
//  ContentView.swift
//  SwiftUI-Beta
//
//  Created by Jonathan Pappas on 7/26/21.
//

import SwiftUI

//extension Binding {
//    init(_ a: UnsafeMutablePointer<Value>) {
//        self.init(get: {
//            return a.pointee
//        }, set: {
//            a.pointee = $0
//        })
//        wrappedValue = a.pointee
//    }
//}

extension Color {
    static var cream: Color = .init(red: 0.95, green: 0.93, blue: 0.84)
    static var waveBlue: Color = .init(red: 0.57, green: 0.71, blue: 0.74)
    static var waveBlue2: Color = .init(red: 0.23, green: 0.37, blue: 0.51)
    static var brown: Color = .init(red: 0.81, green: 0.69, blue: 0.42)
    //static var lightBlue: NSColor = .init
}
//static var cream: Color {
//    let wo = Color(red: 0.95, green: 0.93, blue: 0.84)
//    wo.description = "Cream"
//    return wo
//}
//static var waveBlue: Color {
//    let wo = Color(red: 0.57, green: 0.71, blue: 0.74)
//    wo.description = "Wave Blue"
//    return wo
//}
//static var waveBlue2: Color {
//    let wo = Color(red: 0.23, green: 0.37, blue: 0.51)
//    wo.description = "Deep Wave Blue"
//    return wo
//}
//static var brown: Color {
//    let wo = Color(red: 0.81, green: 0.69, blue: 0.42)
//    wo.description = "Deep Brown"
//    return wo
//}



//extension AppStorage {
//    init<T, U>(wo: KeyPath<T, U>) {
//
//    }
//}

extension Binding where Value == Optional<Bool> {
    func def(_ this: Bool) -> Binding<Bool> {
        return .init(get: { return wrappedValue ?? this }, set: { wrappedValue = $0 })
    }
}
extension Binding where Value == Optional<Double> {
    func def(_ this: Double) -> Binding<Double> {
        return .init(get: { return wrappedValue ?? this }, set: { wrappedValue = $0 })
    }
}



struct MicroView: View {
    var title: String
    static var created: Set<String> = []
    
    init(title: String) {
        self.title = title
        Self.created.insert(title)
    }
    
    @AppStorage("sliders") var s1: [String:Double] = [:]
    @AppStorage("toggles") var woke: [String:Bool] = [:]
    @State var isEditing: Bool = false
    
    var body: some View {
        print(s1)
        return ZStack {
            Rectangle()
                .colorInvert()
                .cornerRadius(10)
                .padding()
            
            VStack {
                
                Toggle(
                    "\(title)",
                    isOn: $woke[title].def(true))
                    .toggleStyle(SwitchToggleStyle(tint: .cream))
                
                if woke[title, true] {
                    Slider(
                        value: $s1[title].def(0.0),
                        in: 0...100,
                        onEditingChanged: {
                            isEditing = $0
                        }, minimumValueLabel:
                            Text("0"),
                        maximumValueLabel:
                            Text("100"),
                        label: {
                            EmptyView()
                        })
                    Text(String(Int(s1[title, 0.0])))
                        .foregroundColor(isEditing ? .waveBlue : .waveBlue2)
                }
                
            }.padding().padding()
        }
    }
}

struct ColorDetail: View {
    var color: Color
    var title: String
    var body: some View {
        color
            .frame(width: 200, height: 200)
            .navigationTitle(color.description.capitalized)
            //.navigationTitle(title)
    }
}

struct ContentView_: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Scroll View", destination: ContentView2())
                NavigationLink("Stepper View", destination: ContentView())
                ForEach.init(1..<100, content: { _ in
                    NavigationLink("Purple", destination: ColorDetail(color: .purple, title: "Purple"))
                })
                NavigationLink("Pink", destination: ColorDetail(color: .pink, title: "Pink"))
                NavigationLink("Orange", destination: ColorDetail(color: .orange, title: "Orange"))
                NavigationLink("Cream", destination: ColorDetail(color: .cream, title: "Cream"))
                NavigationLink("Wave Blue", destination: ColorDetail(color: .waveBlue, title: "Wave Blue"))
            }
            .navigationTitle("Colors")
            Text("Select a Color") // A placeholder to show before selection.
        }
    }
}


struct ContentView: View {
    @State private var value = 0
    let colors: [String] = ["a", "b", "c", "d"]

    func incrementStep() {
        value += 1
        if value >= colors.count { value = 0 }
    }

    func decrementStep() {
        value -= 1
        if value < 0 { value = colors.count - 1 }
    }
    
    var body: some View {
        Stepper.init("Value: \(value) Color: \(colors[value].description)",
        onIncrement: {
            incrementStep()
        }, onDecrement: {
            decrementStep()
        }, onEditingChanged: { o in
            print(o)
        })
        .padding(5)
        .background(Text(colors[value]))
    }
}

struct ContentView2: View {
    
    //static var foo: Double = 5.0
    @State var s1: Double = 5.0
    @State var s2: Double = 5.0
    @State var s3: Double = 5.0
    @State var s4: Double = 5.0
    
    var body: some View {
        

        
        ZStack {
            HStack {
                Button.init("􀯶", action: {
                    print("Clickod")
                }).accentColor(.cream)
                Spacer()
            }.padding()
            Text("Swift Master Class")
        }
        
        HStack {
            ScrollView {
                MicroView(title: "Hello, World!")
                MicroView(title: "Rating")
                MicroView(title: "yes")
                MicroView(title: "Help")
                HStack {
                    MicroView(title: "one hundred")
                    MicroView(title: "more hundred")
                    MicroView(title: "more hundred")
                }
                MicroView(title: "magical")
                MicroView(title: "slide me")
            }
            
            ScrollView {
                MicroView(title: "Hello, World!")
                MicroView(title: "Rating")
                MicroView(title: "yes")
                MicroView(title: "Help")
                HStack {
                    MicroView(title: "one hundred")
                    MicroView(title: "more hundred")
                    MicroView(title: "more hundred")
                }
                MicroView(title: "magical")
                MicroView(title: "slide me")
            }
        }
        
//        Slider.init(value: $foo, in: 0...10)
//        Slider.init(value: $foo, in: 0...10)
//        Slider.init(value: $foo, in: 0...10)
        
        ZStack {
            HStack {
                Spacer()
                Text(.init(systemName: "circle"))
                Spacer()
                Text(.init(systemName: "circle"))
                Spacer()
                Text(.init(systemName: "circle"))
                Spacer()
            }.padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
