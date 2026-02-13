## Diagram Templates and Basic Patterns

### Mermaid Diagram Templates

#### Architecture Diagram Template
```mermaid
architecture-beta
    group api(cloud)[API Layer]

    service db(database)[Database] in api
    service backend(server)[Backend Service] in api
    service frontend(internet)[Frontend App] in api

    backend:L --> db:T : queries
    frontend:R --> backend:L : API calls
```

#### Flowchart Template
```mermaid
flowchart TD
    A[Start] --> B{Decision}
    B -->|Yes| C[Process A]
    B -->|No| D[Process B]
    C --> E[End]
    D --> E
```

#### Sequence Diagram Template
```mermaid
sequenceDiagram
    participant U as User
    participant F as Frontend
    participant B as Backend
    participant D as Database

    U->>F: Request Data
    F->>B: API Call
    B->>D: Query
    D-->>B: Results
    B-->>F: Response
    F-->>U: Display Data
```

#### Entity Relationship Diagram Template
```mermaid
erDiagram
    USER ||--o{ ORDER : places
    ORDER ||--|{ LINE-ITEM : contains
    CUSTOMER }|..|{ DELIVERY-ADDRESS : uses

    USER {
        int id PK
        string name
        string email
    }
    ORDER {
        int id PK
        int user_id FK
        datetime created_at
    }
```

#### Gantt Chart Template
```mermaid
gantt
    title Project Timeline
    dateFormat  YYYY-MM-DD
    section Phase 1
    Planning           :plan1, 2024-01-01, 7d
    Development        :dev1, after plan1, 14d
    section Phase 2
    Testing            :test1, after dev1, 7d
    Deployment         :deploy1, after test1, 3d
```

#### Git Graph Template
```mermaid
gitgraph
    commit id: "Initial"
    branch feature
    checkout feature
    commit id: "Feature A"
    commit id: "Feature B"
    checkout main
    commit id: "Hotfix"
    merge feature
    commit id: "Release"
```

#### State Diagram Template
```mermaid
stateDiagram-v2
    [*] --> Idle
    Idle --> Processing : start
    Processing --> Complete : success
    Processing --> Error : failure
    Error --> Idle : reset
    Complete --> [*]
```

#### Class Diagram Template
```mermaid
classDiagram
    class User {
        +String name
        +String email
        +login()
        +logout()
    }
    class Order {
        +int id
        +Date created_at
        +calculateTotal()
    }
    User "1" --> "*" Order : places
```

### Graphviz DOT Templates

#### Simple Directed Graph Template
```dot
digraph G {
    rankdir=TB;
    node [shape=box, style=rounded];

    A -> B -> C;
    A -> D -> C;
    B -> E;

    A [label="Start"];
    C [label="End"];
}
```

#### System Architecture Template
```dot
digraph Architecture {
    rankdir=TB;
    compound=true;

    subgraph cluster_frontend {
        label="Frontend Layer";
        style=filled;
        color=lightblue;

        UI [label="User Interface"];
        Components [label="React Components"];
    }

    subgraph cluster_backend {
        label="Backend Layer";
        style=filled;
        color=lightgreen;

        API [label="REST API"];
        Services [label="Business Logic"];
    }

    subgraph cluster_data {
        label="Data Layer";
        style=filled;
        color=lightyellow;

        Database [label="MySQL Database"];
        Cache [label="Redis Cache"];
    }

    UI -> API [ltail=cluster_frontend,lhead=cluster_backend];
    API -> Database [ltail=cluster_backend,lhead=cluster_data];
}
```

#### Process Flow Template
```dot
digraph Process {
    rankdir=LR;
    node [shape=box, style=rounded];

    start [shape=ellipse, label="Start"];
    decision [shape=diamond, label="Valid?"];
    process [label="Process Data"];
    error [label="Handle Error", color=red];
    end [shape=ellipse, label="End"];

    start -> decision;
    decision -> process [label="Yes"];
    decision -> error [label="No"];
    process -> end;
    error -> end;
}
```

### FUB-Specific Templates

#### FUB Architecture Overview
```mermaid
architecture-beta
    group web(cloud)[Web Layer]
    group api(cloud)[API Layer]
    group data(database)[Data Layer]

    service frontend(internet)[React Frontend] in web
    service lithium(server)[Lithium Backend] in api
    service mysql(database)[MySQL Database] in data
    service redis(database)[Redis Cache] in data

    frontend:B --> lithium:T : HTTP/REST
    lithium:B --> mysql:T : SQL
    lithium:L --> redis:R : Cache
```

#### FUB Integration Flow
```mermaid
sequenceDiagram
    participant F as FUB Frontend
    participant L as Lithium API
    participant Z as Zillow Service
    participant DB as Database

    F->>L: Request Property Data
    L->>Z: Zillow API Call
    Z-->>L: Property Response
    L->>DB: Store/Update Data
    DB-->>L: Confirmation
    L-->>F: Formatted Response
```

#### FUB Database Schema
```mermaid
erDiagram
    users ||--o{ contacts : owns
    users ||--o{ properties : manages
    contacts ||--o{ property_interests : has
    properties ||--o{ property_interests : generates

    users {
        int id PK
        string email
        string name
        datetime created_at
    }

    contacts {
        int id PK
        int user_id FK
        string name
        string email
        string phone
    }

    properties {
        int id PK
        int user_id FK
        string address
        decimal price
        string status
    }
```

### Quick Reference Patterns

#### Common Node Shapes (Mermaid)
```mermaid
flowchart LR
    A[Rectangle] --> B(Rounded)
    B --> C([Stadium])
    C --> D[[Subroutine]]
    D --> E[(Database)]
    E --> F((Circle))
    F --> G>Asymmetric]
    G --> H{Diamond}
    H --> I{{Hexagon}}
```

#### Common Edge Types
```mermaid
flowchart TD
    A -->|Normal| B
    A -.->|Dotted| C
    A ==>|Thick| D
    A -.-|Dotted Text| E
    A ==|Thick Text|==> F
```

#### Color and Styling
```mermaid
flowchart TD
    A[Default] --> B[Blue]
    A --> C[Green]

    classDef blue fill:#e1f5fe
    classDef green fill:#e8f5e8

    class B blue
    class C green
```

### Rendering Commands Reference

#### Mermaid CLI Commands
```bash
# Install Mermaid CLI
npm install -g @mermaid-js/mermaid-cli

# Render to PNG
mmdc -i diagram.mmd -o diagram.png

# Render to SVG with theme
mmdc -i diagram.mmd -o diagram.svg -t forest

# Batch render
mmdc -i diagrams/ -o output/
```

#### Graphviz Commands
```bash
# Install Graphviz
brew install graphviz  # macOS
apt-get install graphviz  # Ubuntu

# Render DOT to PNG
dot -Tpng -o diagram.png diagram.dot

# Render to SVG
dot -Tsvg -o diagram.svg diagram.dot

# Different layout engines
neato -Tpng -o diagram.png diagram.dot    # spring model
circo -Tpng -o diagram.png diagram.dot    # circular layout
fdp -Tpng -o diagram.png diagram.dot      # force-directed
```

### Common Use Cases

| Diagram Type | Best For | Template |
|-------------|----------|----------|
| **Flowchart** | Process flows, decision trees | `flowchart TD` |
| **Sequence** | API interactions, user journeys | `sequenceDiagram` |
| **Architecture** | System overviews, component relationships | `architecture-beta` |
| **ERD** | Database design, data relationships | `erDiagram` |
| **Class** | Object-oriented design, code structure | `classDiagram` |
| **State** | State machines, workflow states | `stateDiagram-v2` |
| **Gantt** | Project timelines, sprint planning | `gantt` |
| **Git** | Branch strategies, release flows | `gitgraph` |

These templates provide the foundation for creating professional technical diagrams that align with FUB's documentation and development standards.