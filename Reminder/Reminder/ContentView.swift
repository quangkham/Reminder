//
//  ContentView.swift
//  ToDo_Note
//
//  Created by TechFun on 23/03/2020.
//  Copyright © 2020 TechFunMyanmar. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var showDetailTask = false
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: ToDoList.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \ToDoList.createdAt, ascending: true)] , predicate: NSPredicate(format  : "status != %@" , "Done")) var tasks : FetchedResults<ToDoList>
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor:UIColor.green]
        //UINavigationBar.appearance().backgroundColor = .green
    }
    
    var dateFormatter : DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }
    
    func updateTaskStatus(task : ToDoList) {
        let newStatus = task.taskStatus == .pending ? Status.inProgress : .done
        managedObjectContext.performAndWait {
            task.taskStatus = newStatus
            try! managedObjectContext.save()
        }
    }
    
    func removeTask(at offsets : IndexSet) {
        for index in offsets{
            let task = tasks[index]
            managedObjectContext.delete(task)
        }
        print("task delete")
    }
    
    var body: some View {
        
        NavigationView{
            List {
                ForEach(tasks){ task in
                    HStack {
                        VStack(alignment : .leading){
                            HStack{
                                
                                Text("\(task.priority)").foregroundColor(.red)
                                Text("\(task.task)")
                                    .font(.headline)
                            }
                                Spacer()
                                .frame(height  : 4)
                            HStack {
                                Text("\(task.createdAt , formatter : self.dateFormatter)")
                                    .font(.subheadline)
                            }
                            
                        }
                        
                        Spacer()
                        Button(action : {
                            print("Update task status")
                            self.updateTaskStatus(task: task)
                        }){
                            Text(task.taskStatus == .pending ? "In Progress" : "Done")
                                .foregroundColor(.green)
                        }
                    }
                }.onDelete(perform: removeTask(at:))
            }
                
            .navigationBarTitle("To Do")
            .navigationBarItems(trailing: Button(action: {
                self.showDetailTask = true
                
            }, label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width : 30 , height: 30 )
                    .foregroundColor(.green)
            })).sheet(isPresented: $showDetailTask){
                TaskSheet().environment(\.managedObjectContext, self.managedObjectContext)
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
