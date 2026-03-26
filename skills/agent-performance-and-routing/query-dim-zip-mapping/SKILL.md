# Query: dim_zip_mapping

## Table
`enterprise.conformed_dimension.dim_zip_mapping`

## Purpose
Geography dimension table. Maps ZIP codes to MSAs and region IDs. Used as an enrichment join in nearly every MSA-level query. This is the canonical source for ZIP-to-MSA and ZIP-to-region relationships.

## Columns Used

| Column | Type | Description |
|--------|------|-------------|
| `zipcode` | STRING | 5-digit ZIP code (join key from allocations.zip) |
| `msa` | STRING | MSA name (canonical — preferred over the MSA in allocations table) |
| `msa_regionid` | BIGINT/INT | MSA region identifier (always cast to STRING for grouping/display/joins) |
| `regionid` | BIGINT/INT | Region identifier (used only for econometric forecast joins) |

## Common Patterns

### LEFT JOIN from allocations (most common)
```sql
LEFT JOIN enterprise.conformed_dimension.dim_zip_mapping zm ON a.zip = zm.zipcode
```

### COALESCE fallbacks for unmapped ZIPs
When a ZIP has no mapping, the app falls back to data from the allocations table itself:
```sql
COALESCE(CAST(zm.msa_regionid AS STRING), '000000') AS msa_regionid,
COALESCE(zm.msa, a.msa) AS msa
```
The `'000000'` sentinel value is used for ZIPs that don't map to any MSA. On the simulation page, unmapped ZIPs are labeled `'No MSA Mapping / Unmapped ZIPs'`.

### Direct lookup for ZIP-to-MSA mapping
Used in the simulation override flow to map ZIP-level overrides back to MSA-level totals:
```sql
SELECT zipcode, CAST(msa_regionid AS STRING) AS msa_regionid
FROM enterprise.conformed_dimension.dim_zip_mapping
WHERE zipcode IN (...)
```

### JOIN for econometric forecast
The pa_connections_forecast table uses `regionid` (not `zipcode`):
```sql
JOIN enterprise.conformed_dimension.dim_zip_mapping zm ON f.regionid = zm.regionid
```

### MSA name to region ID mapping (via partner_metrics_monthly)
Used in the snapshot endpoint to map team primary MSA names back to region IDs for forecast change lookup:
```sql
JOIN enterprise.conformed_dimension.dim_zip_mapping zm ON pms.primary_msa = zm.msa
```

## Cross-Table Relationships
- **hybrid_market_allocations_approved**: joined on `zip = zipcode`
- **hybrid_market_simulations**: joined on `zip = zipcode`
- **flex_zip_connections_fcst**: joined on `zipcode = zipcode`
- **pa_connections_forecast**: joined on `regionid = regionid`
- **partner_metrics_monthly**: joined on `primary_msa = msa` (reverse lookup for snapshot endpoint)

## Frontend Data Flow

### Unallocated Page (`/unallocated`)
- The MSA map renders bubbles using `msa_regionid` as the unique identifier and `msa` as the display name.
- Bubble coordinates are looked up from a client-side `msaCoordinates` map (`client/src/lib/msa-coordinates.ts`) keyed by MSA name.
- The `msa_regionid` is used as the key when clicking a bubble to load teams via `/api/allocations/msa-teams/:msaRegionId`.

### Dashboard — Simulation Modal
- The simulation comparison view groups results by `msa_regionid` and displays `msa` name alongside AOP forecast and simulation allocation.
- The `apply-overrides` endpoint maps ZIP-level CSV overrides → `msa_regionid` → MSA-level totals using this table.

### Dashboard — Snapshot Modal
- Forecast change data is associated with teams via: team → `primary_msa` (from partner_metrics_monthly) → `msa` (joined to dim_zip_mapping) → `msa_regionid` → forecast change.

## Key Notes
- `msa_regionid` must always be cast to STRING: `CAST(zm.msa_regionid AS STRING)`.
- Not all ZIPs have mappings — COALESCE with fallback values is mandatory.
- The `regionid` column is only used for pa_connections_forecast joins, not for MSA identification.

## Used In (API Endpoints)
- `/api/allocations/top-msas` — MSA-level aggregation
- `/api/allocations/unallocated-detail` — MSA-level unallocated capacity
- `/api/allocations/msa-teams/:msaRegionId` — filter teams by MSA region
- `/api/allocations/forecast` — ZIP forecast to MSA mapping
- `/api/allocations/snapshot` — forecast change by MSA region, team-to-MSA mapping
- `/api/allocations/simulation` — simulation results by MSA
- `/api/allocations/simulation/apply-overrides` — ZIP-to-MSA override mapping
