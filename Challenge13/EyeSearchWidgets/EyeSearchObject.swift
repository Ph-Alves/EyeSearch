//
//  EyeSearchWidgets.swift
//  EyeSearchWidgets
//
//  Created by Paulo Henrique Costa Alves on 23/04/26.
//

import WidgetKit
import SwiftUI
import AppIntents

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping @Sendable (SimpleEntry) -> Void) {
        completion(SimpleEntry(date: Date()))
    }
    
    func getTimeline(in context: Context, completion: @escaping @Sendable (Timeline<SimpleEntry>) -> Void) {
        let entry = SimpleEntry(date: Date())
        let nextUpdate = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct EyeSearchObject: Widget {
    let kind: String = "group.eyesearch"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            Button(intent: OpenSearchObjectWidgetIntent()) {
                Image(systemName: "magnifyingglass")
                    .padding()
                    .background(Color.secondary)
                    .containerBackground(.fill.quaternary, for: .widget)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .supportedFamilies([.accessoryCircular])
        .configurationDisplayName("Procurar objeto")
        .description("Um botão que te envia diretamente para a tela de adicionar transação")
    }
}

#Preview(as: .accessoryCircular) {
    EyeSearchObject()
} timeline: {
    SimpleEntry(date: .now)
}
