import Foundation


let iOSKeywordsMarkdown = """
**iOS Keywords & Phrases**

A comprehensive reference for modern iOS development vocabulary, patterns, and best practices.

━━━━━━

**1. Core iOS Concepts**

**App Lifecycle**
App launch, Cold start, Warm start, Scene phase, Scene lifecycle, Foreground, Background, Suspended state, Terminated state, Active, Inactive, State restoration, Multi-window support

**Modern App Architecture**
MVVM, Clean Architecture, Feature-driven architecture, Modular architecture, Dependency injection, Protocol-oriented design, Composition over inheritance, Single source of truth, Unidirectional data flow, State-driven UI, Reactive architecture, Coordinator pattern, Repository pattern, Domain layer, Interface abstraction

**Core Apple Frameworks**
SwiftUI, UIKit, SwiftData, Foundation Models, AppIntents, WidgetKit, ActivityKit, StoreKit, CloudKit, Core Animation, Core Graphics, AVFoundation, Vision, MapKit, Core Location, UserNotifications, RealityKit, Metal

━━━━━━

**2. Swift Language & Concurrency**

Swift 6, Strict concurrency, Data-race safety, Actor isolation, Sendable, @MainActor, Nonisolated, Structured concurrency, async/await, Task, TaskGroup, Detached task, Cancellation, Cooperative cancellation, AsyncSequence, AsyncStream

**Testing**
Swift Testing framework, #expect assertions, Test tags, Parallel testing, Snapshot testing

━━━━━━

**3. SwiftUI Vocabulary (Modern)**

**Core Structure**
View, Scene, App protocol, WindowGroup, NavigationStack, NavigationSplitView, TabView, List, ScrollView, Grid, LazyVGrid, LazyHGrid, ZStack, VStack, HStack, ViewThatFits, ContentUnavailableView

**State Management**
@State, @Binding, @Observable, @ObservationTracking, @Environment, @EnvironmentObject, Observable macro, State mutation, Derived state, Single source of truth, View invalidation, State graph, Data flow

**Layout System**
Layout protocol, Custom layout, Safe area, SafeAreaInset, GeometryReader, ContainerRelativeFrame, Alignment guides, Padding, Spacer, Layout priority, Intrinsic size, Adaptive layout, Responsive layout, Dynamic Type, Size classes

**Navigation & Presentation**
NavigationStack, NavigationPath, navigationDestination, Sheet, FullScreenCover, Popover, Inspector, Programmatic navigation, Deep linking, Universal links, Handoff

━━━━━━

**4. UIKit (Still Relevant)**

UIView, UIViewController, UINavigationController, UITabBarController, UITableView, UICollectionView, Diffable data source, Compositional layout, UIHostingController, Auto Layout, NSLayoutConstraint, Programmatic UI, Responder chain

**Interop**
SwiftUI–UIKit interoperability, UIViewRepresentable, UIViewControllerRepresentable, Hosting configuration

━━━━━━

**5. Visual Design & System UI**

Human Interface Guidelines (HIG), Liquid Glass design language, Materials, Blur, Vibrancy, Depth, Layered UI, Motion hierarchy, Spatial depth, Native feel, Platform conventions, Dynamic type, Accessibility-first design

**Common Components**
Button, Label, TextField, TextEditor, Toggle, Slider, Stepper, Picker, Menu, Toolbar, Searchable, Bottom sheet, Inspector panel, Context menu, Swipe actions, Cards, Empty states

━━━━━━

**6. Animation & Motion**

**SwiftUI Animation**
withAnimation, PhaseAnimator, KeyframeAnimator, Spring animation, Smooth animation, MatchedGeometryEffect, Content transitions, Symbol effects, TimelineView, Transaction, Interruptible animation

**Performance Motion**
120Hz ProMotion, Frame pacing, GPU rendering, Core Animation layers, Metal rendering pipeline

━━━━━━

**7. Data & Persistence**

**Local Data**
SwiftData, @Model, ModelContext, Query, PersistentModel, UserDefaults, FileManager, Keychain, On-device storage, Cache layer, In-memory store

**Networking**
URLSession, Async networking, REST API, GraphQL, Codable, Streaming responses, WebSockets, Pagination, Retry logic, Background transfers, Offline mode, Sync engine

**Cloud & Sync**
CloudKit, iCloud sync, Real-time sync, Conflict resolution, Local-first architecture, Eventual consistency

━━━━━━

**8. AI & Apple Intelligence**

Foundation Models framework, Apple Intelligence, On-device LLM, Prompt sessions, Tool calling, Guided generation, Structured output, Streaming tokens, Context window, Embeddings, Local AI inference, Privacy-first AI

**AI App Patterns**
AI copilots, AI summarization, Smart search, Semantic indexing, AI tagging, Natural language UI, Agent workflows, Intent-driven actions

━━━━━━

**9. System Integrations**

App Intents, Shortcuts integration, Siri integration, Spotlight indexing, Interactive widgets, Live Activities, Dynamic Island, Lock Screen widgets, StandBy widgets, SharePlay, Universal links, Handoff, Background tasks

━━━━━━

**10. Performance & Optimization**

Lazy loading, Memory management, ARC, Retain cycle prevention, Weak references, Instruments profiling, Main thread isolation, Background processing, Task prioritization, Debouncing, Throttling, Rendering performance, Launch time optimization, Battery efficiency

━━━━━━

**11. Accessibility**

VoiceOver, Dynamic Type, Reduce Motion, High contrast, Accessibility label, Accessibility identifier, Focus state, Switch Control, Screen reader support, Color contrast compliance, Hit target sizing

━━━━━━

**12. Spatial & 3D**

RealityKit, visionOS compatibility, 3D transforms, Spatial layout, Immersive space, Volumetric UI, Scene understanding, Metal rendering, ARKit integration

━━━━━━

**13. Prompt Phrases for LLM-Driven iOS Development**

**UI Construction**
"Create a modern native iOS SwiftUI interface"
"Use state-driven architecture with SwiftUI Observation"
"Follow Apple Human Interface Guidelines and Liquid Glass design"
"Ensure accessibility and performance optimization"
"Use modern navigation and presentation patterns"

**Architecture**
"Use modular MVVM architecture"
"Maintain single source of truth"
"Use unidirectional data flow"
"Ensure scalability and testability"

**AI Integration**
"Integrate on-device Foundation Models"
"Use structured AI output and tool calling"
"Design privacy-first AI experiences"

**Animation**
"Add smooth, interruptible SwiftUI animations"
"Use spring-based motion and matched geometry"
"Maintain 60–120fps performance"

**Interaction**
"Use native gestures and system behaviors"
"Provide subtle haptic feedback"
"Ensure responsive, low-latency UI"

━━━━━━

**14. Example Master Prompt**

*Build a modern native iOS app using SwiftUI, Swift 6 concurrency, and SwiftData. Follow Apple Human Interface Guidelines and the Liquid Glass design language. Use state-driven architecture with a single source of truth and modular MVVM structure. Integrate App Intents, interactive widgets, and on-device Foundation Models where appropriate. Ensure accessibility, performance optimization, smooth animations, and a responsive production-quality experience.*
"""
