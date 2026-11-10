<!-- Pull requests are expected to follow the contributing guide:
https://github.com/distribution-system-opt/math-and-data-model-specifications/blob/main/docs/src/contributing.md
For a wording fix, the Summary and the Licence box are enough; delete the rest. -->

## Summary

What the change is for, what it affects, and what it changes, in a few sentences.

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

Link the issue or discussion this comes from and any related PRs. If this PR
pairs with a change in `dsopt-schema` (the JSON Schema), link it. If this PR
builds on another PR that has not merged yet (a "stacked" PR), say which one and
which should merge first; otherwise it starts from `main` and nothing more is
needed. Describe the discussion as it stands; do not imply agreement that has
not been reached.

For normative changes:

- [ ] Prior discussion and its outcome are linked.
- [ ] Prose, tables, worked examples, schema, symbols and equations agree, or unresolved differences are identified for review.
- [ ] Compatibility and the relevant modelling principles have been considered.

## Validation

Say what you ran and what happened. For documentation changes that is usually
the local build, `julia --project=docs docs/make.jl`, or, if you could not build
locally, say so and point to the CI documentation preview on this PR. For schema
or example changes, name the validation command and its result.

Distinguish structural validation, semantic checks, numerical evidence, and
Task Force network-case acceptance. Neither CI nor an implementation release
constitutes ratification.

## Contributions and sources

Fill in what applies and delete the rest:

- Work by others that this PR incorporates or adapts: *name*, *link to their commit, PR or comment*, *licence if not CC BY 4.0*
- Reviewed or discussed by: *names, with links to the discussion*
- Coordination: *who organised the change, if relevant*

Commits that bring in another person's work carry a `Co-authored-by: Name <email>`
trailer (the e-mail that person uses on GitHub); keep those trailers if the PR is
squashed. Being credited does not mean a person endorsed the whole proposal.

## Review questions

Specific questions and unresolved choices for Task Force feedback.

## Licence

- [ ] Contributions use [CC BY 4.0](https://github.com/distribution-system-opt/math-and-data-model-specifications/blob/main/LICENSE); reused material retains its source attribution and applicable licence.
