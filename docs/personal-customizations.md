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
