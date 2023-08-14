//
//  CaffeineTrackerWidget.swift
//  CS193p
//
//  Created by WisidomCleanMaster on 2023/8/11.
//

///
/// Toggle样式可交互小组件

import WidgetKit
import SwiftUI
import AppIntents

// MARK: - TaskModel
class TaskModel: Identifiable {
    let id: String = UUID().uuidString
    let taskTitle: String
    var isCompleted: Bool = false
    
    init(taskTitle: String) {
        self.taskTitle = taskTitle
    }
}

// MARK: - DrinksLogStore
class TaskDataModel {
    static let shared = TaskDataModel()
    
    var tasks: [TaskModel] = [
        .init(taskTitle: "3公里11分钟"),
        .init(taskTitle: "5公里22分钟"),
        .init(taskTitle: "11点入睡, 6点起床")
    ]
}

// MARK: - AppIntents
struct ToggleStateIntent: AppIntent {
    static var title: LocalizedStringResource = "Toggle Task State"

    @Parameter(title: "Task ID")
    var id: String

    init() {}

    init(id: String) {
        self.id = id
    }

    func perform() async throws -> some IntentResult {
        // 处理小组件交互逻辑
        if let index = TaskDataModel.shared.tasks.firstIndex(where: { $0.id == id }) {
            TaskDataModel.shared.tasks[index].isCompleted.toggle()
        }
        return .result()
    }
}


/// 定义 Toggle 的样式
struct ToDoToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .foregroundColor(.blue)
            if configuration.isOn {
                configuration.label.strikethrough()
            } else {
                configuration.label
            }
        }
    }
}



// MARK: - CaffeineIntentProvider
struct TaskProvider: TimelineProvider {
    public typealias Entry = TaskEntry
    
    func placeholder(in context: Context) -> TaskEntry {
        TaskEntry(lastThreeTasks: Array(TaskDataModel.shared.tasks.prefix(3)))
    }
    
    func getSnapshot(in context: Context, completion: @escaping (TaskEntry) -> Void) {
        let entry = TaskEntry(lastThreeTasks: Array(TaskDataModel.shared.tasks.prefix(3)))
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<TaskEntry>) -> Void) {
        let lastThreeTasks = Array(TaskDataModel.shared.tasks.prefix(3))
        let entries = [TaskEntry(lastThreeTasks: lastThreeTasks)]
        
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}


// MARK: - CaffeineTrackerWidget

struct TaskEntry: TimelineEntry {
    let date: Date = Date()
    var lastThreeTasks: [TaskModel]
}

struct TaskWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: TaskEntry

    var body: some View {
        VStack(alignment: .leading, content: {
            VStack(alignment: .leading, spacing: 0.0) {
                Text("Task's")
                    .fontWeight(.semibold)
                    .padding(.bottom, 10)
                
                VStack(alignment: .leading, spacing: 6.0) {
                    if entry.lastThreeTasks.isEmpty {
                        Text("No Task's Found.")
                            .font(.caption)
                            .foregroundStyle(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity)
                    } else {
                        ForEach(entry.lastThreeTasks.sorted(by: {
                            !$0.isCompleted && $1.isCompleted
                        })) { task in
                            Toggle(isOn: task.isCompleted, intent: ToggleStateIntent(id: task.id)) {
                                VStack(alignment: .leading, spacing: 4.0) {
                                    Text(task.taskTitle)
                                        .textScale(.secondary)
                                        .lineLimit(1)
                                    Divider()
                                }
                            }
                            .toggleStyle(ToDoToggleStyle())
                            if task.id != entry.lastThreeTasks.last?.id {
                                Spacer(minLength: 0)
                            }
                        }
                    }
                }
            }
        })
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct TodoListWidget: Widget {
    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: "TodoListWidget", provider: TaskProvider()) { entry in
            TaskWidgetEntryView(entry: entry)
        }
    }
}

#Preview(as: .systemSmall, widget: {
    TodoListWidget()
}, timeline: {
    TaskEntry(lastThreeTasks: Array(TaskDataModel.shared.tasks.prefix(3)))
})

