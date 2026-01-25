import SwiftUI
import SwiftData

struct TodoListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TodoItem.order) private var todos: [TodoItem]
    @State private var newTodoText = ""
    @State private var selectedTask: TodoItem?
    
    var body: some View {
        ResiliencePage(showBackButton: true) {
            VStack(spacing: 0) {
                Text("Daily Tasks")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                
                ScrollView {
                    VStack(spacing: 0) {
                        VStack(spacing: 0) {
                            // Quick Add Row
                            HStack(spacing: 16) {
                                Image(systemName: "plus.circle")
                                    .font(.title3)
                                    .foregroundColor(.gray)
                                
                                TextField("Add task...", text: $newTodoText, onCommit: addTodo)
                                    .font(.title3)
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .frame(height: 70)
                            
                            Divider().background(Color.blue.opacity(0.3))
                            
                            // Existing Tasks
                            ForEach(todos) { todo in
                                TodoRowView(todo: todo, onSchedule: {
                                    selectedTask = todo
                                })
                                Divider().background(Color.blue.opacity(0.1))
                            }
                        }
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(24)
                        .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.blue.opacity(0.2), lineWidth: 1))
                        .padding(.horizontal)
                        
                        // Filler rows (Notepad aesthetic)
                        if todos.count < 6 {
                            VStack(spacing: 0) {
                                ForEach(0..<(6 - todos.count), id: \.self) { _ in
                                    Divider().background(Color.blue.opacity(0.05)).padding(.horizontal, 32)
                                    Color.clear.frame(height: 60)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 100)
                }
            }
        }
        .sheet(item: $selectedTask) { task in
            ScheduleTaskSheet(task: task)
        }
    }
    
    func addTodo() {
        guard !newTodoText.isEmpty else { return }
        let new = TodoItem(text: newTodoText, isCompleted: false, order: todos.count)
        modelContext.insert(new)
        newTodoText = ""
    }
}

struct TodoRowView: View {
    @Bindable var todo: TodoItem
    var onSchedule: () -> Void
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        HStack(spacing: 16) {
            Button(action: {
                withAnimation { todo.isCompleted.toggle() }
            }) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(todo.isCompleted ? .green : .gray)
            }
            
            // Inline Editing
            TextField("Task", text: $todo.text)
                .font(.title3)
                .strikethrough(todo.isCompleted)
                .foregroundColor(todo.isCompleted ? .gray : .white)
            
            Spacer()
            
            // Set Time / Calendar Link
            Button(action: onSchedule) {
                HStack(spacing: 4) {
                    Image(systemName: "calendar.badge.clock")
                    if let date = todo.date {
                        Text(formatDate(date))
                            .font(.caption2)
                    }
                }
                .foregroundColor(.cyan)
                .padding(6)
                .background(Color.cyan.opacity(0.1))
                .cornerRadius(8)
            }
            
            // Delete
            Button(action: { modelContext.delete(todo) }) {
                Image(systemName: "xmark")
                    .font(.caption)
                    .foregroundColor(.gray.opacity(0.6))
            }
        }
        .padding()
        .frame(height: 70)
    }
    
    func formatDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "h:mm a"
        return f.string(from: date)
    }
}
