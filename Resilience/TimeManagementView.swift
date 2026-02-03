import SwiftUI

struct TimeManagementView: View {
    @State private var tasks: [TodoItem] = [
        TodoItem(text: "Review project proposal", isCompleted: false, order: 0),
        TodoItem(text: "Email marketing team", isCompleted: true, order: 1),
        TodoItem(text: "Update website content", isCompleted: false, order: 2)
    ]
    @State private var newTaskText = ""
    @State private var focusDuration: Double = 25
    @State private var isFocusing = false
    
    var body: some View {
        ResiliencePage(showBackButton: true) {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    HStack {
                        Text("Time Management")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top)

                    // Focus Timer
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "timer")
                                .font(.title2)
                                .foregroundColor(.purple)
                            Text("Quick Focus")
                                .font(.headline)
                            Spacer()
                        }
                        
                        if isFocusing {
                            Text("24:59") // Placeholder for running timer
                                .font(.system(size: 48, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                            
                            Button(action: { isFocusing = false }) {
                                Text("Stop Focus")
                                    .fontWeight(.semibold)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.red.opacity(0.2))
                                    .foregroundColor(.red)
                                    .cornerRadius(12)
                            }
                        } else {
                            VStack {
                                Text("\(Int(focusDuration)) min")
                                    .font(.title)
                                    .bold()
                                Slider(value: $focusDuration, in: 5...60, step: 5)
                                    .accentColor(.purple)
                            }
                            
                            Button(action: { isFocusing = true }) {
                                Text("Start Focus")
                                    .fontWeight(.semibold)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.purple)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                    )
                    
                    // Todo List
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Tasks")
                            .font(.headline)
                        
                        HStack {
                            TextField("Add a new task...", text: $newTaskText)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(10)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                            
                            Button(action: addTask) {
                                Image(systemName: "plus")
                                    .padding(10)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                        
                        ForEach($tasks) { $task in
                            HStack {
                                Button(action: { task.isCompleted.toggle() }) {
                                    Image(systemName: task.isCompleted ? "checkmark.square.fill" : "square")
                                        .foregroundColor(task.isCompleted ? .green : .gray)
                                        .font(.title3)
                                }
                                
                                Text(task.text)
                                    .strikethrough(task.isCompleted)
                                    .foregroundColor(task.isCompleted ? .gray : .white)
                                
                                Spacer()
                                
                                Button(action: { deleteTask(task) }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                }
                            }
                            .padding()
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(8)
                        }
                    }
                }
                .padding()
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .foregroundColor(.white)
        }
    }
    
    func addTask() {
        guard !newTaskText.isEmpty else { return }
        tasks.append(TodoItem(text: newTaskText, isCompleted: false, order: tasks.count))
        newTaskText = ""
    }
    
    func deleteTask(_ task: TodoItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks.remove(at: index)
        }
    }
}

