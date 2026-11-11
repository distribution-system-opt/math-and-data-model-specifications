# Document metadata

A case carries a top-level `meta` object providing provenance, licensing, and
versioning. From 0.2.0 it is required, because it holds `schema_version`; a 0.1.x
document may omit it.

**Suggestion:** populate the `meta` object where possible. Provenance, licensing, and
versioning information helps downstream consumers of the dataset.

This is a *data-model* page: `meta` carries no OPF variables or
constraints. Symbols are defined in [Notation](notation.md).

## The `meta` object

| Field | Type | Description |
|-------|------|-------------|
| `schema_version` | string | The BMOPF release this document was written against, as `MAJOR.MINOR.PATCH` (e.g. `0.2.0`). Required from 0.2.0 and the document's only version identifier; the 0.2 schema accepts any 0.2.x release |
| `version` | string | Version of this **dataset** (not the schema) |
| `title` | string | Human-readable dataset name (distinct from the machine-readable root `name`) |
| `description` | string | Free-text notes or caveats |
| `created` | string (ISO 8601) | Creation timestamp, UTC |
| `modified` | string (ISO 8601) | Last-revision timestamp, UTC |
| `license` | string | SPDX identifier (e.g. `CC-BY-4.0`) or an `https://` URI to the licence |
| `frequency` | number (Hz) | Nominal system frequency, **check-only** (validated against `line_geometry`/linecode derivation frequency; never rescales) |
| `crs` | string | Coordinate reference system of every `geo` field (the Points and LineStrings on buses, lines and every other located element) as an authority code such as `OGC:CRS84` or `EPSG:32617`; absent means `OGC:CRS84` (WGS84 longitude, latitude). Coordinates are always x then y (longitude then latitude, or easting then northing), whatever the authority's own axis order. Proposed in 0.2.0 |
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

- `schema_version` is the document's only version identifier. It names no URL, so it
  does not depend on where schemas are hosted. Within a line (0.2.0, 0.2.1, ...) a
  later release only adds optional content, so the 0.2 schema accepts any 0.2.x value;
  a reader takes the line from `schema_version` and validates against the newest
  schema of that line it holds. `meta.$schema` is not part of 0.2.0. Documents
  written before 0.2.0 carry no `schema_version`, and a reader identifies a 0.1.x
  document by its `meta.$schema`. A producer that writes against an untagged schema
  records the schema commit and digest in `provenance`. The
  [versioning policy](https://github.com/distribution-system-opt/dsopt-schema/blob/propose-bmopf-0.2.0/README.md#versioning-and-compatibility)
  in [`dsopt-schema`](https://github.com/distribution-system-opt/dsopt-schema) states
  the full rules. (Reference-implementation experience: per-producer URLs in
  `$schema` made valid documents fail intake at other tools; see BMOPFTools #487.)
- Dates must be UTC and should include a time component (`THH:MM:SSZ`); a date-only
  value is permitted when the time is unknown.
- `license` should be a URI when the licence needs specific attribution language beyond
  an SPDX identifier.
- The schema rejects unknown fields. Producer-specific data goes in the top-level
  `extras` object; apart from `provenance`, it is the only free-form object.
- `frequency` is a consistency check only. It never defaults or rescales any quantity.

## Example

```json
{
  "name": "enwl_network1_feeder1",
  "meta": {
    "schema_version": "0.2.0",
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
