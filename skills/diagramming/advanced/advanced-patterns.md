## Advanced Diagramming Patterns and Implementation

### Complex Architecture Patterns

#### Microservices Architecture with Service Mesh
```mermaid
architecture-beta
    group ui(cloud)[Frontend]
    group gateway(cloud)[API Gateway]
    group services(cloud)[Microservices]
    group data(database)[Data Layer]

    service react(internet)[React App] in ui
    service nginx(server)[Nginx] in gateway
    service kong(server)[Kong Gateway] in gateway

    service auth(server)[Auth Service] in services
    service user(server)[User Service] in services
    service property(server)[Property Service] in services
    service notification(server)[Notification Service] in services

    service mysql(database)[MySQL] in data
    service redis(database)[Redis] in data
    service elastic(database)[Elasticsearch] in data

    react:B --> nginx:T : HTTPS
    nginx:B --> kong:T : Load Balance
    kong:B --> auth:T : Authentication
    kong:B --> user:T : User Management
    kong:B --> property:T : Property Data
    kong:B --> notification:T : Notifications

    auth:B --> redis:T : Session Store
    user:B --> mysql:T : User Data
    property:B --> mysql:T : Property Data
    notification:B --> elastic:T : Event Logs
```

#### Event-Driven Architecture Pattern
```mermaid
graph TB
    subgraph "Event Producers"
        A[User Service] --> E[Event Bus]
        B[Property Service] --> E
        C[Notification Service] --> E
    end

    subgraph "Event Bus Layer"
        E[Apache Kafka/RabbitMQ]
    end

    subgraph "Event Consumers"
        E --> F[Analytics Service]
        E --> G[Audit Service]
        E --> H[Cache Invalidator]
        E --> I[Email Service]
    end

    subgraph "Event Store"
        F --> J[(Event Store)]
        G --> J
    end

    classDef producer fill:#e3f2fd
    classDef consumer fill:#f3e5f5
    classDef eventbus fill:#fff3e0
    classDef storage fill:#e8f5e8

    class A,B,C producer
    class F,G,H,I consumer
    class E eventbus
    class J storage
```

### Advanced Sequence Patterns

#### Complex Multi-System Integration Flow
```mermaid
sequenceDiagram
    participant U as User
    participant F as FUB Frontend
    participant G as API Gateway
    participant A as Auth Service
    participant P as Property Service
    participant Z as Zillow API
    participant N as Notification Service
    participant D as Database
    participant C as Cache

    Note over U,C: Property Search with Real-time Updates

    U->>F: Search Properties
    F->>G: GET /properties/search
    G->>A: Validate Token
    A-->>G: Token Valid

    par Property Search
        G->>P: Search Request
        P->>C: Check Cache
        alt Cache Hit
            C-->>P: Cached Results
        else Cache Miss
            P->>Z: External API Call
            Z-->>P: Fresh Data
            P->>C: Update Cache
            P->>D: Store Data
        end
        P-->>G: Search Results
    and Notification
        G->>N: Log Search Event
        N->>D: Store Event
        N->>U: Real-time Update
    end

    G-->>F: Formatted Response
    F-->>U: Display Results

    Note over U,C: Async processing for analytics
    N->>P: Update Search Analytics
    P->>D: Update Metrics
```

### Advanced Graphviz Patterns

#### Complex System Topology
```dot
digraph ComplexSystem {
    rankdir=TB;
    compound=true;
    concentrate=true;

    // Define node styles
    node [fontname="Arial", fontsize=10];
    edge [fontname="Arial", fontsize=8];

    subgraph cluster_cdn {
        label="CDN Layer";
        style=filled;
        fillcolor=lightblue;

        cloudflare [label="Cloudflare", shape=ellipse];
        aws_cloudfront [label="AWS CloudFront", shape=ellipse];
    }

    subgraph cluster_loadbalancer {
        label="Load Balancer";
        style=filled;
        fillcolor=lightgreen;

        nginx [label="Nginx\nLoad Balancer", shape=box];
        haproxy [label="HAProxy\nFailover", shape=box];
    }

    subgraph cluster_application {
        label="Application Layer";
        style=filled;
        fillcolor=lightyellow;

        subgraph cluster_frontend {
            label="Frontend Servers";
            app1 [label="App Server 1"];
            app2 [label="App Server 2"];
            app3 [label="App Server 3"];
        }

        subgraph cluster_api {
            label="API Servers";
            api1 [label="API Server 1"];
            api2 [label="API Server 2"];
        }
    }

    subgraph cluster_services {
        label="Microservices";
        style=filled;
        fillcolor=lavender;

        auth_service [label="Auth\nService"];
        user_service [label="User\nService"];
        property_service [label="Property\nService"];
    }

    subgraph cluster_data {
        label="Data Layer";
        style=filled;
        fillcolor=lightcoral;

        mysql_primary [label="MySQL\nPrimary"];
        mysql_replica [label="MySQL\nReplica"];
        redis_cluster [label="Redis\nCluster"];
        elasticsearch [label="Elasticsearch\nCluster"];
    }

    // External services
    zillow_api [label="Zillow API", style=dashed, color=blue];
    monitoring [label="Datadog\nMonitoring", style=dashed, color=green];

    // Connection flows
    {cloudflare, aws_cloudfront} -> nginx;
    nginx -> haproxy;
    haproxy -> {app1, app2, app3};
    {app1, app2, app3} -> {api1, api2};
    {api1, api2} -> {auth_service, user_service, property_service};

    property_service -> zillow_api [style=dashed];

    {auth_service, user_service, property_service} -> mysql_primary;
    mysql_primary -> mysql_replica [style=dashed, label="replication"];
    {auth_service, user_service} -> redis_cluster;
    property_service -> elasticsearch;

    // Monitoring connections
    {nginx, haproxy, app1, app2, app3, api1, api2} -> monitoring [style=dotted, color=green];
}
```

### Interactive and Animated Diagrams

#### Progressive Disclosure Architecture
```mermaid
flowchart TD
    A[User Request] --> B{Authentication}
    B -->|Valid| C[Route Request]
    B -->|Invalid| D[Return 401]

    C --> E{Service Type}
    E -->|User Data| F[User Service]
    E -->|Property Data| G[Property Service]
    E -->|Integration| H[External APIs]

    F --> I[Database Query]
    G --> I
    H --> J[External API Call]

    I --> K[Format Response]
    J --> K
    K --> L[Return Data]

    click F "Show detailed user service flow"
    click G "Show detailed property service flow"
    click H "Show external API integration details"

    classDef decision fill:#fff2cc
    classDef service fill:#d5e8d4
    classDef external fill:#ffe6cc

    class B,E decision
    class F,G service
    class H external
```

#### State Machine with Transitions
```mermaid
stateDiagram-v2
    [*] --> Idle

    state "Processing Request" as Processing {
        [*] --> Validating
        Validating --> Querying : valid
        Validating --> ValidationError : invalid
        Querying --> Formatting : success
        Querying --> QueryError : failure
        Formatting --> [*] : complete
        ValidationError --> [*] : error
        QueryError --> [*] : error
    }

    state "Error Handling" as ErrorHandling {
        [*] --> LogError
        LogError --> NotifyUser
        NotifyUser --> [*]
    }

    Idle --> Processing : request
    Processing --> Idle : success
    Processing --> ErrorHandling : error
    ErrorHandling --> Idle : handled

    Processing --> [*] : timeout
    ErrorHandling --> [*] : critical_error
```

### Custom Styling and Themes

#### Custom Mermaid Theme Configuration
```javascript
// Custom theme configuration
const customTheme = {
    theme: 'base',
    themeVariables: {
        primaryColor: '#ff6b35',
        primaryTextColor: '#ffffff',
        primaryBorderColor: '#ff8c42',
        lineColor: '#f39c12',
        secondaryColor: '#006ba6',
        tertiaryColor: '#0582ca',
        background: '#ffffff',
        mainBkg: '#f8f9fa',
        secondBkg: '#e9ecef',
        tertiaryBkg: '#dee2e6'
    }
};

// Apply theme to diagram
mermaid.initialize({
    startOnLoad: true,
    theme: customTheme,
    flowchart: {
        useMaxWidth: true,
        htmlLabels: true
    }
});
```

#### Advanced DOT Styling
```dot
digraph StyledGraph {
    // Graph attributes
    rankdir=TB;
    bgcolor=white;
    fontname="Helvetica";
    fontsize=12;

    // Default node style
    node [
        fontname="Helvetica",
        fontsize=10,
        shape=box,
        style="rounded,filled",
        fillcolor=lightblue,
        color=darkblue,
        penwidth=2
    ];

    // Default edge style
    edge [
        fontname="Helvetica",
        fontsize=8,
        color=darkblue,
        penwidth=1.5,
        arrowsize=0.8
    ];

    // Styled nodes with custom attributes
    start [
        label="Start Process",
        shape=ellipse,
        fillcolor=lightgreen,
        color=darkgreen
    ];

    process [
        label="Main\nProcessing",
        fillcolor=lightyellow,
        color=orange
    ];

    decision [
        label="Decision\nPoint",
        shape=diamond,
        fillcolor=lightcoral,
        color=darkred
    ];

    end [
        label="End",
        shape=ellipse,
        fillcolor=lightgray,
        color=black
    ];

    // Styled edges
    start -> process [label="initialize", style=bold];
    process -> decision [label="evaluate"];
    decision -> end [label="success", color=green, style=bold];
    decision -> process [label="retry", color=red, style=dashed];
}
```

### Automation and Scripting

#### Automated Diagram Generation Script
```bash
#!/bin/bash
# automated-diagram-generation.sh

set -e

DIAGRAM_DIR="./diagrams"
OUTPUT_DIR="./output"
FORMATS=("png" "svg" "pdf")

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Function to render Mermaid diagrams
render_mermaid() {
    local input_file="$1"
    local basename=$(basename "$input_file" .mmd)

    echo "Rendering Mermaid: $input_file"

    for format in "${FORMATS[@]}"; do
        mmdc -i "$input_file" -o "$OUTPUT_DIR/${basename}.$format" \
             --theme forest --backgroundColor white
    done
}

# Function to render Graphviz diagrams
render_graphviz() {
    local input_file="$1"
    local basename=$(basename "$input_file" .dot)

    echo "Rendering Graphviz: $input_file"

    dot -Tpng -o "$OUTPUT_DIR/${basename}.png" "$input_file"
    dot -Tsvg -o "$OUTPUT_DIR/${basename}.svg" "$input_file"
    dot -Tpdf -o "$OUTPUT_DIR/${basename}.pdf" "$input_file"
}

# Process all Mermaid files
find "$DIAGRAM_DIR" -name "*.mmd" -type f | while read -r file; do
    render_mermaid "$file"
done

# Process all Graphviz files
find "$DIAGRAM_DIR" -name "*.dot" -type f | while read -r file; do
    render_graphviz "$file"
done

echo "All diagrams rendered successfully to $OUTPUT_DIR"
```

#### Dynamic Diagram Generation
```python
#!/usr/bin/env python3
# dynamic_architecture_diagram.py

import json
import sys
from pathlib import Path

def generate_architecture_diagram(config_file):
    """Generate architecture diagram from JSON configuration"""

    with open(config_file, 'r') as f:
        config = json.load(f)

    mermaid_content = """architecture-beta
"""

    # Generate groups
    for group in config.get('groups', []):
        group_type = group.get('type', 'cloud')
        mermaid_content += f'    group {group["name"]}({group_type})[{group["label"]}]\n'

    mermaid_content += "\n"

    # Generate services
    for service in config.get('services', []):
        service_type = service.get('type', 'server')
        group_name = service.get('group', '')
        mermaid_content += f'    service {service["name"]}({service_type})[{service["label"]}] in {group_name}\n'

    mermaid_content += "\n"

    # Generate connections
    for connection in config.get('connections', []):
        from_service = connection['from']
        to_service = connection['to']
        label = connection.get('label', '')
        direction_from = connection.get('direction_from', 'B')
        direction_to = connection.get('direction_to', 'T')

        if label:
            mermaid_content += f'    {from_service}:{direction_from} --> {to_service}:{direction_to} : {label}\n'
        else:
            mermaid_content += f'    {from_service}:{direction_from} --> {to_service}:{direction_to}\n'

    return mermaid_content

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 dynamic_architecture_diagram.py config.json")
        sys.exit(1)

    config_file = sys.argv[1]
    diagram_content = generate_architecture_diagram(config_file)

    # Write to output file
    output_file = Path(config_file).stem + "_architecture.mmd"
    with open(output_file, 'w') as f:
        f.write(diagram_content)

    print(f"Architecture diagram generated: {output_file}")
```

### Performance Optimization Patterns

#### Large Diagram Optimization
```mermaid
%%{init: {
    'theme': 'base',
    'themeVariables': {
        'primaryColor': '#ff6b35'
    },
    'flowchart': {
        'useMaxWidth': true,
        'htmlLabels': false
    }
}}%%

flowchart TD
    subgraph "Optimized Large Diagram"
        A[Start] --> B[Process 1]
        B --> C[Process 2]
        C --> D{Decision}
        D -->|Yes| E[Branch A]
        D -->|No| F[Branch B]
        E --> G[Merge]
        F --> G
        G --> H[End]
    end

    %% Use CSS classes for styling instead of inline styles
    classDef processBox fill:#e1f5fe,stroke:#01579b,stroke-width:2px
    classDef decisionBox fill:#fff3e0,stroke:#e65100,stroke-width:2px
    classDef endBox fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px

    class B,C,E,F processBox
    class D decisionBox
    class A,G,H endBox
```

### CI/CD Integration Patterns

#### GitLab CI Pipeline for Diagram Validation
```yaml
# .gitlab-ci.yml
stages:
  - validate
  - render
  - deploy

validate-diagrams:
  stage: validate
  image: node:18
  script:
    - npm install -g @mermaid-js/mermaid-cli
    - find . -name "*.mmd" -exec mmdc -i {} -o /dev/null \;
    - find . -name "*.dot" -exec dot -Tsvg -o /dev/null {} \;
  only:
    changes:
      - "**/*.mmd"
      - "**/*.dot"

render-diagrams:
  stage: render
  image: node:18
  before_script:
    - npm install -g @mermaid-js/mermaid-cli
    - apt-get update && apt-get install -y graphviz
  script:
    - mkdir -p rendered
    - find . -name "*.mmd" -exec mmdc -i {} -o rendered/{/.}.png \;
    - find . -name "*.dot" -exec dot -Tpng -o rendered/{/.}.png {} \;
  artifacts:
    paths:
      - rendered/
    expire_in: 1 week
  only:
    changes:
      - "**/*.mmd"
      - "**/*.dot"

deploy-documentation:
  stage: deploy
  script:
    - rsync -av rendered/ $DOC_SERVER:/var/www/diagrams/
  only:
    - main
```

This comprehensive guide provides advanced patterns for creating sophisticated, maintainable, and automated diagrams that integrate seamlessly with FUB's development workflows.