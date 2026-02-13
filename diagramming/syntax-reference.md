# Diagramming Syntax Reference

## Mermaid Syntax Guide

### Flowchart Shapes and Connections

**Node Shapes:**
```mermaid
flowchart TD
    A[Rectangle]
    B(Round edges)
    C([Stadium/Pill])
    D[[Subroutine]]
    E[(Database)]
    F((Circle))
    G{Diamond}
    H{{Hexagon}}
    I[/Parallelogram/]
    J[\Parallelogram alt\]
    K[/Trapezoid\]
    L[\Trapezoid alt/]
```

**Arrow Types:**
```mermaid
flowchart TD
    A --> B    %% Arrow
    C --- D     %% Line
    E -.-> F    %% Dotted arrow
    G ==> H     %% Thick arrow
    I -.- J     %% Dotted line
    K === L     %% Thick line
```

**Arrow Labels:**
```mermaid
flowchart TD
    A -->|Label| B
    C -.->|"Multi word"| D
    E ==>|Yes| F
```

### Sequence Diagrams

**Participants and Messages:**
```mermaid
sequenceDiagram
    participant A as Alice
    participant B as Bob
    participant C as Charlie

    A->>B: Synchronous call
    B-->>A: Synchronous return
    A-)B: Asynchronous call
    B--)A: Asynchronous return

    activate B
    B->>C: Another call
    deactivate B

    Note over A,B: This is a note
    Note right of C: Right note
    Note left of A: Left note
```

**Loops and Alternatives:**
```mermaid
sequenceDiagram
    participant U as User
    participant S as System

    loop Every minute
        U->>S: Heartbeat
        S-->>U: OK
    end

    alt Success case
        U->>S: Login
        S-->>U: Token
    else Failure case
        U->>S: Login
        S-->>U: Error
    end

    opt Optional
        U->>S: Logout
    end
```

### Entity Relationship Diagrams

```mermaid
erDiagram
    CUSTOMER {
        int id PK
        string name
        string email UK
        date created_at
    }

    ORDER {
        int id PK
        int customer_id FK
        decimal total
        date order_date
    }

    PRODUCT {
        int id PK
        string name
        decimal price
        int inventory
    }

    ORDER_ITEM {
        int order_id FK
        int product_id FK
        int quantity
        decimal unit_price
    }

    CUSTOMER ||--o{ ORDER : places
    ORDER ||--|{ ORDER_ITEM : contains
    PRODUCT ||--o{ ORDER_ITEM : "ordered in"
```

**Relationship Types:**
- `||--||` : One to one
- `||--o{` : One to zero or many
- `||--|{` : One to one or many
- `}o--||` : Zero or many to one
- `}|--|{` : One or many to one or many

### Class Diagrams

```mermaid
classDiagram
    class User {
        +int id
        +string name
        +string email
        -string password
        +login(email, password)
        +logout()
    }

    class Order {
        +int id
        +int userId
        +decimal total
        +addItem(item)
        +calculateTotal()
    }

    class Product {
        +int id
        +string name
        +decimal price
        +updatePrice(price)
    }

    User "1" --> "*" Order : places
    Order "*" --> "*" Product : contains

    class PaymentProcessor {
        <<interface>>
        +processPayment(amount)
    }

    class CreditCardProcessor {
        +processPayment(amount)
    }

    PaymentProcessor <|.. CreditCardProcessor
```

### Git Graphs

```mermaid
gitgraph
    commit id: "Initial"
    branch develop
    checkout develop
    commit id: "Feature A"
    commit id: "Feature B"
    checkout main
    merge develop
    commit id: "Release 1.0"
    branch hotfix
    checkout hotfix
    commit id: "Critical fix"
    checkout main
    merge hotfix
    commit id: "Release 1.0.1"
```

## Graphviz (DOT) Syntax Guide

### Basic Graph Structure

**Directed Graph (digraph):**
```dot
digraph G {
    A -> B;
    B -> C;
    C -> A;
}
```

**Undirected Graph (graph):**
```dot
graph G {
    A -- B;
    B -- C;
    C -- A;
}
```

### Node and Edge Attributes

```dot
digraph G {
    // Node attributes
    A [shape=box, color=red, style=filled, fillcolor=lightblue];
    B [shape=circle, label="Custom Label"];
    C [shape=diamond, style="rounded,filled", fillcolor=yellow];

    // Edge attributes
    A -> B [color=red, style=dashed, label="edge label"];
    B -> C [weight=10, style=bold];

    // Graph attributes
    rankdir=LR;        // Left to right layout
    bgcolor=lightgray;
    node [shape=box];   // Default node shape
    edge [color=blue];  // Default edge color
}
```

### Common Node Shapes

```dot
digraph shapes {
    box [shape=box];
    circle [shape=circle];
    ellipse [shape=ellipse];
    diamond [shape=diamond];
    triangle [shape=triangle];
    pentagon [shape=pentagon];
    hexagon [shape=hexagon];
    octagon [shape=octagon];
    house [shape=house];
    invhouse [shape=invhouse];
    trapezium [shape=trapezium];
    invtrapezium [shape=invtrapezium];
    parallelogram [shape=parallelogram];
    record [shape=record, label="field1|field2|field3"];
    Mrecord [shape=Mrecord, label="field1|{field2a|field2b}|field3"];
}
```

### Subgraphs and Clusters

```dot
digraph G {
    subgraph cluster_0 {
        style=filled;
        color=lightgrey;
        label="Process #1";
        a0 -> a1 -> a2 -> a3;
    }

    subgraph cluster_1 {
        style=filled;
        color=lightblue;
        label="Process #2";
        b0 -> b1 -> b2 -> b3;
    }

    start -> a0;
    start -> b0;
    a1 -> b3;
    b2 -> a3;
    a3 -> end;
    b3 -> end;
}
```

### Layout Directions

```dot
digraph G {
    rankdir=TB;  // Top to Bottom (default)
    // rankdir=LR;  // Left to Right
    // rankdir=BT;  // Bottom to Top
    // rankdir=RL;  // Right to Left

    A -> B -> C -> D;
}
```

### Record Structures

```dot
digraph structs {
    node [shape=record];

    struct1 [label="<f0> left|<f1> middle|<f2> right"];
    struct2 [label="<f0> one|<f1> two"];
    struct3 [label="hello\nworld |{ b |{c|<here> d|e}| f}| g | h"];

    struct1:f1 -> struct2:f0;
    struct1:f2 -> struct3:here;
}
```

## Advanced Features

### Mermaid Themes and Styling

```mermaid
%%{init: {'theme':'dark', 'themeVariables': { 'primaryColor': '#ff0000'}}}%%
flowchart TD
    A[Red themed diagram] --> B[Dark theme]
```

### Graphviz Advanced Layouts

**For large hierarchical graphs:**
```dot
digraph G {
    layout=dot;     // Hierarchical (default)
    // layout=neato; // Spring model
    // layout=fdp;   // Force-directed
    // layout=sfdp;  // Large graphs
    // layout=twopi; // Radial
    // layout=circo; // Circular
}
```

### HTML-like Labels in Graphviz

```dot
digraph G {
    A [label=<
        <TABLE BORDER="0" CELLBORDER="1" CELLSPACING="0">
        <TR><TD><B>Title</B></TD></TR>
        <TR><TD>Content</TD></TR>
        </TABLE>
    >];
}
```