# Personal build customizations

Keep `personal/local-customizations` separate from the upstream tracking branch.
When updating, merge a reviewed upstream revision into this branch or replay its
individual customization commits on the reviewed release. Do not reset this
branch to upstream or build an unmodified release for this installation.

Polish dictionary installation: [polish-proofing.md](polish-proofing.md).

## Interface without social links

This build removes Discord links from the interface, native menus, command
registries, CLI and MCP wherever present. WordCraft also omits the account
initials button in the title bar; author preferences remain in File > Options.
Project documentation and source-code links remain available.

## Centrally managed updates

This installation is updated by its owner through the central build and deployment
workflow. The application does not start a release-check worker, display update
popups, open update links, or replace its executable. Legacy host methods remain
as no-ops. Keep this policy when merging upstream changes; enabling an in-app
updater could replace the reviewed build and discard local customizations.

## Verified Windows distribution

Windows packaging requires `CRAFT_CENTRAL_BUILD_MANIFEST`, with a successful
`personal.centralupdates.*` build at the exact current source revision and matching
SHA-256 hashes of both executables. Never distribute an upstream MSI or reuse
executables from an unrelated build: they can restore the upstream updater.
The central workflow also extracts the resulting MSI and ZIP and compares their
executables with this manifest. Keep this gate across upstream merges.
