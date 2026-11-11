# Document metadata

Every case may carry a top-level `meta` object providing provenance, licensing, and
versioning. It is optional for backward compatibility.

**Suggestion:** populate the `meta` object where possible. Provenance, licensing, and
versioning information helps downstream consumers of the dataset.

This is a *data-model* page: `meta` carries no OPF variables or
constraints. Symbols are defined in [Notation](notation.md).

## The `meta` object

| Field | Type | Description |
|-------|------|-------------|
| `$schema` | string (URI) | The canonical `$id` of the JSON Schema document this file conforms to, released from [`dsopt-schema`](https://github.com/distribution-system-opt/dsopt-schema); from 0.2.0 the schema fixes the value, so it is an identifier, not a download location |
| `version` | string | Version of this **dataset** (not the schema) |
| `title` | string | Human-readable dataset name (distinct from the machine-readable root `name`) |
| `description` | string | Free-text notes or caveats |
| `created` | string (ISO 8601) | Creation timestamp, UTC |
| `modified` | string (ISO 8601) | Last-revision timestamp, UTC |
| `license` | string | SPDX identifier (e.g. `CC-BY-4.0`) or an `https://` URI to the licence |
| `frequency` | number (Hz) | Nominal system frequency, **check-only** (validated against `line_geometry`/linecode derivation frequency; never rescales) |
| `crs` | string | Coordinate reference system of every `geo` field (the Points and LineStrings on buses, lines and every other located element) as an authority code such as `EPSG:4326`; absent means WGS84, longitude then latitude. Proposed in 0.2.0 |
| `authors` | object[] | Ordered authors (see below) |
| `data_sources` | object[] | Upstream data references (see below) |
| `case_study_generator` | object | Tool that wrote the file (see below) |
| `provenance` | object | Free-form conversion/audit notes written by tooling |

**`authors[]`**: `name`, `email`, `orcid` (bare hyphenated form `XXXX-XXXX-XXXX-XXXX`,
without the `https://orcid.org/` prefix).

**`data_sources[]`**: `name`, `url` (dereferenceable `https://`), `format` (e.g. `OpenDSS`,
`PMD-JSON`, `MATPOWER`), `doi`, `version`.

**`case_study_generator`**: `tool`, `version`.

## Conformance notes

- `$schema` follows the JSON Schema `$schema` keyword convention and carries the
  schema's canonical `$id`, which has the form
  `https://raw.githubusercontent.com/distribution-system-opt/dsopt-schema/main/schema/bmopf/<version>/bmopf.schema.json`
  (one immutable directory per version in the
  [`dsopt-schema`](https://github.com/distribution-system-opt/dsopt-schema) repository).
  A reader selects the schema version from this field and recognises a document by
  it; it does not need to allow-list the places a producer fetched the schema from.
  A producer that wants the exact bytes it validated against to be retrievable
  records the schema commit and digest in `provenance`. (Reference-implementation
  experience: per-producer archive URLs in `$schema` made valid documents fail
  intake at other tools; see BMOPFTools #487.)
- Dates must be UTC and should include a time component (`THH:MM:SSZ`); a date-only
  value is permitted when the time is unknown.
- `license` should be a URI when the licence needs specific attribution language beyond
  an SPDX identifier.
- Unknown fields may be present; conformant readers must ignore them.
- `frequency` is a consistency check only. It never defaults or rescales any quantity.

## Example

```json
{
  "name": "enwl_network1_feeder1",
  "meta": {
    "$schema": "https://example.org/bmopf/schema/v1/bmopf.json",
    "version": "1.0",
    "title": "ENWL LV Network 1, Feeder 1",
    "description": "Four-wire 230/400 V LV feeder from the ENWL LVNS dataset.",
    "created": "2026-06-15T10:00:00Z",
    "license": "https://creativecommons.org/licenses/by/4.0/",
    "frequency": 50.0,
    "authors": [
      { "name": "A. Researcher", "email": "a@example.org", "orcid": "0000-0001-9534-2265" }
    ],
    "data_sources": [
      { "name": "ENWL LVNS dataset", "url": "https://www.enwl.co.uk/lvns", "format": "OpenDSS" }
    ],
    "case_study_generator": { "tool": "example-writer", "version": "0.1.0" }
  },
  "bus": { "...": {} },
  "line": { "...": {} }
}
```
