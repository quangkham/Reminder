//
//  TaskSheet.swift
//  ToDo_Note
//
//  Created by TechFun on 23/03/2020.
//  Copyright © 2020 TechFunMyanmar. All rights reserved.
//

import SwiftUI
enum Priority : String{
    case Low  =  "!"
    case Medium  = "!!"
    case High  = "!!!"
    case None  = ""
}


struct TaskSheet: View {
    let priorityTypes = [Priority.Low , Priority.Medium , Priority.High ,Priority.None]
   @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedPriority = 3
    @State private var newTask = ""
    @State private var selectedDate = Date()
    @State private var isRemindADay = false
    @State private var isRemindTime = false
    
    init() {
         UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor:UIColor.green]
        //UINavigationBar.appearance().backgroundColor = .green
    }
    
    var body: some View {
      
        NavigationView {
            Form{
                Section(header: Text("Add To do task")){
                    TextField("Task" , text : self.$newTask )
                }
                
                Section{
                    Toggle(isOn: $isRemindADay){
                       Text("Remind me on a day")
                    }
                    if(isRemindADay){
                        DatePicker(selection: $selectedDate, in : Date()... , displayedComponents: .date){
                            Text("Alarm")
                        }
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                    
                    }
                    Toggle(isOn : $isRemindTime){
                        Text("Remind me at a time")
                    }
                    if(isRemindTime){
                        DatePicker(selection: $selectedDate, in : Date()... , displayedComponents: .hourAndMinute){
                            Text("Alarm")
                        }.labelsHidden()
                    }
                   
                   
                    Picker(selection : $selectedPriority , label : Text("Priority")){
                        ForEach(0 ..< priorityTypes.count){
                            Text(String(describing: self.priorityTypes[$0])).tag($0)
                        }
                    }
                    
                }
                
            }
            .navigationBarTitle(Text("Details") , displayMode:  .inline)
            .navigationBarItems(trailing: Button(action : {
               
                let newTask = ToDoList(context: self.managedObjectContext)
                newTask.task = self.newTask
                newTask.createdAt = self.selectedDate
                newTask.priority = self.priorityTypes[self.selectedPriority].rawValue
                newTask.taskStatus = .pending
                newTask.id = UUID()
                do {
                    try self.managedObjectContext.save()
                    print("task assign saved")
                    self.presentationMode.wrappedValue.dismiss()
                }catch {
                    print(error.localizedDescription)
                }
            }){
                Text("Save").bold().foregroundColor(.green)
            }
            )
        }
    }
}

struct TaskSheet_Previews: PreviewProvider {
    static var previews: some View {
        TaskSheet()
    }
}
