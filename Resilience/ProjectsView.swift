import SwiftUI

// MARK: - Data Model
struct ProjectItem: Identifiable {
    let id = UUID()
    var title: String
    var description: String
    var category: String   // "Projects" or "Skills"
    var isAIGenerated: Bool
    var progress: Double   // 0.0 – 1.0
    var createdAt: Date = Date()
}

// MARK: - Main View
struct ProjectsView: View {
    @State private var selectedTab = "Projects"
    @State private var items: [ProjectItem] = []

    // Sheet states
    @State private var showManualAdd   = false
    @State private var showAIGenerate  = false

    var filteredItems: [ProjectItem] {
        items.filter { $0.category == selectedTab }
    }

    var body: some View {
        ResiliencePage(showBackButton: true) {
            VStack(spacing: 24) {
                // ── Header + Tab Switcher ──────────────────────────────
                VStack(spacing: 16) {
                    Text("Productivity Hub")
                        .font(.title2).fontWeight(.black).foregroundColor(.white)

                    HStack {
                        tabButton(title: "Projects", color: .blue)
                        tabButton(title: "Skills",   color: .pink)
                    }
                    .padding(4)
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(16)
                }
                .padding(.horizontal)

                ScrollView {
                    VStack(spacing: 24) {
                        // ── Action Buttons ─────────────────────────────
                        HStack(spacing: 16) {
                            actionCard(
                                icon: "plus.circle.fill",
                                title: "Manual Add",
                                subtitle: "Create new",
                                color: selectedTab == "Projects" ? .blue : .pink
                            ) {
                                showManualAdd = true
                            }

                            actionCard(
                                icon: "sparkles",
                                title: "AI Generate",
                                subtitle: "Let AI Build",
                                color: selectedTab == "Projects" ? .cyan : .purple
                            ) {
                                showAIGenerate = true
                            }
                        }
                        .padding(.horizontal)

                        // ── Item List or Empty State ───────────────────
                        if filteredItems.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: selectedTab == "Projects" ? "hammer.fill" : "brain.head.profile")
                                    .font(.system(size: 60))
                                    .foregroundColor(.gray.opacity(0.3))

                                Text("No \(selectedTab) Yet")
                                    .font(.headline)
                                    .foregroundColor(.white)

                                Text("Start building your legacy today.")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(.top, 40)
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(filteredItems) { item in
                                    itemCard(item)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 50)
                }
            }
        }
        // ── Sheets ────────────────────────────────────────────────────
        .sheet(isPresented: $showManualAdd) {
            ManualAddSheet(selectedTab: selectedTab) { newItem in
                items.append(newItem)
            }
        }
        .sheet(isPresented: $showAIGenerate) {
            AIGenerateSheet(selectedTab: selectedTab) { newItem in
                items.append(newItem)
            }
        }
    }

    // MARK: - Sub-views
    @ViewBuilder
    private func tabButton(title: String, color: Color) -> some View {
        Button(action: { selectedTab = title }) {
            Text(title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(selectedTab == title ? color : Color.white.opacity(0.1))
                .foregroundColor(selectedTab == title ? .white : .gray)
                .cornerRadius(12)
        }
    }

    @ViewBuilder
    private func actionCard(icon: String, title: String, subtitle: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: icon)
                    .font(.largeTitle)
                    .foregroundColor(color)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline).bold().foregroundColor(.white)
                    Text(subtitle)
                        .font(.caption).foregroundColor(.gray)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 120)
            .background(Color(UIColor.systemGray6).opacity(0.15))
            .cornerRadius(16)
        }
    }

    @ViewBuilder
    private func itemCard(_ item: ProjectItem) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(item.title)
                            .font(.headline).bold().foregroundColor(.white)
                        if item.isAIGenerated {
                            Image(systemName: "sparkles")
                                .font(.caption)
                                .foregroundColor(.cyan)
                        }
                    }
                    Text(item.description)
                        .font(.caption).foregroundColor(.gray)
                        .lineLimit(2)
                }
                Spacer()
                Text("\(Int(item.progress * 100))%")
                    .font(.caption).bold().foregroundColor(.white)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.white.opacity(0.1)).frame(height: 6)
                    Capsule()
                        .fill(item.category == "Projects" ? Color.blue : Color.pink)
                        .frame(width: geo.size.width * item.progress, height: 6)
                }
            }
            .frame(height: 6)
        }
        .padding()
        .background(Color(UIColor.systemGray6).opacity(0.15))
        .cornerRadius(16)
    }
}

// MARK: - Manual Add Sheet
struct ManualAddSheet: View {
    let selectedTab: String
    var onAdd: (ProjectItem) -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var title       = ""
    @State private var description = ""

    var accentColor: Color { selectedTab == "Projects" ? .blue : .pink }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Icon
                        Circle()
                            .fill(accentColor.opacity(0.15))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 36))
                                    .foregroundColor(accentColor)
                            )
                            .padding(.top, 20)

                        Text("Add \(selectedTab == "Projects" ? "Project" : "Skill")")
                            .font(.title2).bold().foregroundColor(.white)

                        // Form
                        VStack(spacing: 16) {
                            fieldBox(label: "Name") {
                                TextField(selectedTab == "Projects" ? "e.g. Build a Portfolio" : "e.g. Swift Programming",
                                          text: $title)
                                    .foregroundColor(.white)
                            }

                            fieldBox(label: "Description") {
                                TextField("Brief description...", text: $description, axis: .vertical)
                                    .foregroundColor(.white)
                                    .lineLimit(3...6)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.gray)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                        let item = ProjectItem(
                            title: title,
                            description: description.isEmpty ? "No description" : description,
                            category: selectedTab,
                            isAIGenerated: false,
                            progress: 0.0
                        )
                        onAdd(item)
                        dismiss()
                    }
                    .fontWeight(.bold)
                    .foregroundColor(accentColor)
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }

    @ViewBuilder
    private func fieldBox<Content: View>(label: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.caption).foregroundColor(.gray).textCase(.uppercase)
            content()
                .padding()
                .background(Color.white.opacity(0.07))
                .cornerRadius(12)
        }
    }
}

// MARK: - AI Generate Sheet
struct AIGenerateSheet: View {
    let selectedTab: String
    var onAdd: (ProjectItem) -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var prompt    = ""
    @State private var isLoading = false
    @State private var errorMsg: String? = nil
    @State private var generatedTitle: String       = ""
    @State private var generatedDescription: String = ""
    @State private var showResult = false

    var accentColor: Color { selectedTab == "Projects" ? .cyan : .purple }
    var noun: String       { selectedTab == "Projects" ? "project" : "skill" }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Icon
                        Circle()
                            .fill(accentColor.opacity(0.15))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image(systemName: "sparkles")
                                    .font(.system(size: 36))
                                    .foregroundColor(accentColor)
                            )
                            .padding(.top, 20)

                        Text("AI Generate \(selectedTab == "Projects" ? "Project" : "Skill")")
                            .font(.title2).bold().foregroundColor(.white)

                        Text("Describe your goal and AI will generate a \(noun) plan for you.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        // Prompt box
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Your Goal")
                                .font(.caption).foregroundColor(.gray).textCase(.uppercase)
                            TextField(
                                selectedTab == "Projects"
                                    ? "e.g. Build a personal finance app in 3 months"
                                    : "e.g. Become proficient in public speaking",
                                text: $prompt,
                                axis: .vertical
                            )
                            .foregroundColor(.white)
                            .lineLimit(3...6)
                            .padding()
                            .background(Color.white.opacity(0.07))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)

                        // Error
                        if let errorMsg {
                            Text(errorMsg)
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.horizontal)
                        }

                        // Result preview
                        if showResult {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "sparkles")
                                        .foregroundColor(accentColor)
                                    Text("AI Suggestion")
                                        .font(.caption).bold().foregroundColor(accentColor)
                                }

                                Text(generatedTitle)
                                    .font(.headline).bold().foregroundColor(.white)

                                Text(generatedDescription)
                                    .font(.caption).foregroundColor(.gray)
                                    .fixedSize(horizontal: false, vertical: true)

                                Button(action: {
                                    let item = ProjectItem(
                                        title: generatedTitle,
                                        description: generatedDescription,
                                        category: selectedTab,
                                        isAIGenerated: true,
                                        progress: 0.0
                                    )
                                    onAdd(item)
                                    dismiss()
                                }) {
                                    Label("Add to \(selectedTab)", systemImage: "plus.circle.fill")
                                        .fontWeight(.bold)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(accentColor)
                                        .foregroundColor(.white)
                                        .cornerRadius(14)
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.07))
                            .cornerRadius(16)
                            .padding(.horizontal)
                        }

                        // Generate button
                        if !showResult {
                            Button(action: generate) {
                                if isLoading {
                                    HStack(spacing: 10) {
                                        ProgressView()
                                            .tint(.white)
                                            .scaleEffect(0.9)
                                        Text("Generating…")
                                    }
                                } else {
                                    Label("Generate with AI", systemImage: "sparkles")
                                }
                            }
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(prompt.trimmingCharacters(in: .whitespaces).isEmpty ? Color.gray.opacity(0.3) : accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(14)
                            .disabled(prompt.trimmingCharacters(in: .whitespaces).isEmpty || isLoading)
                            .padding(.horizontal)
                        } else {
                            Button(action: { showResult = false; generatedTitle = ""; generatedDescription = "" }) {
                                Label("Regenerate", systemImage: "arrow.clockwise")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white.opacity(0.08))
                                    .foregroundColor(.white)
                                    .cornerRadius(14)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.gray)
                }
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }

    // MARK: - AI Call
    private func generate() {
        let trimmed = prompt.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }

        isLoading = true
        errorMsg  = nil
        showResult = false

        Task {
            do {
                let aiPrompt = """
                You are a productivity coach. The user wants to \(trimmed).
                Generate a concise \(noun) plan with:
                - A short, catchy title (max 8 words)
                - A 1–2 sentence description of the plan

                Respond ONLY in this exact format (no markdown, no JSON):
                TITLE: <the title>
                DESCRIPTION: <the description>
                """

                let response = try await AIService.shared.sendMessage(history: [], newMessage: aiPrompt)

                // Parse
                var parsedTitle       = ""
                var parsedDescription = ""
                for line in response.components(separatedBy: "\n") {
                    let clean = line.trimmingCharacters(in: .whitespaces)
                    if clean.hasPrefix("TITLE:") {
                        parsedTitle = clean.replacingOccurrences(of: "TITLE:", with: "").trimmingCharacters(in: .whitespaces)
                    } else if clean.hasPrefix("DESCRIPTION:") {
                        parsedDescription = clean.replacingOccurrences(of: "DESCRIPTION:", with: "").trimmingCharacters(in: .whitespaces)
                    }
                }

                // Fallback if parsing fails
                if parsedTitle.isEmpty {
                    parsedTitle       = trimmed.prefix(50).description
                    parsedDescription = response.prefix(200).description
                }

                await MainActor.run {
                    generatedTitle       = parsedTitle
                    generatedDescription = parsedDescription
                    showResult           = true
                    isLoading            = false
                }
            } catch {
                await MainActor.run {
                    errorMsg  = "AI generation failed: \(error.localizedDescription)"
                    isLoading = false
                }
            }
        }
    }
}
