## Summary

Purpose, affected behavior, and the concrete changes proposed.

## Review tier

The [existing contribution guide](https://github.com/distribution-system-opt/math-and-data-model-specifications/blob/main/docs/src/contributing.md) defines these tiers.

- [ ] Editorial / minor: wording, links, or examples without changing definitions.
- [ ] Explanatory / non-normative: tooling, tests, or organization without changing definitions.
- [ ] Normative / major: fields, units, supported values, validation rules, or mathematics.

## Version and compatibility

Affected schema/specification versions, source revisions, and impact on existing
datasets. Include migration or deprecation notes for renamed or removed fields.
Mark this section not applicable for editorial changes.

## Related work and dependencies

Prior issue or discussion, related PRs, paired schema/specification changes,
base branch, and intended merge order. Ordinary PRs start from `main`; a stacked
PR identifies its prerequisite explicitly. Record open questions and the actual
discussion status without implying agreement that has not been reached.

For normative changes:

- [ ] Prior discussion and its outcome are linked.
- [ ] Prose, tables, worked examples, schema, symbols and equations agree, or unresolved differences are identified for review.
- [ ] Compatibility and the relevant modelling principles have been considered.

## Validation

Commands and results, including limitations. `julia --project=docs docs/make.jl`; link the CI documentation preview. State any checks deferred to CI and why.

Distinguish structural validation, semantic checks, numerical evidence, and
Task Force network-case acceptance. Neither CI nor an implementation release
constitutes ratification.

## Contributions and sources

Credit authored or adapted material with links to its source commits/PRs and
licences. Credit discussion, review, and coordination separately. Human
`Co-authored-by: Name <email>` trailers belong on commits incorporating the work;
use the contributor's verified Git identity and preserve trailers when squashing.
Credit does not imply endorsement of the whole proposal.

## Review questions

Specific questions and unresolved choices for Task Force feedback.

## Licence

- [ ] Contributions use [CC BY 4.0](https://github.com/distribution-system-opt/math-and-data-model-specifications/blob/main/LICENSE); reused material retains its source attribution and applicable licence.
