# Polish proofing on Windows

Run `packaging/windows/install-polish-dictionary.ps1` with PowerShell. It downloads
SJP.PL's Hunspell release of 2026-11-01, verifies the pinned SHA-256 and installs
`pl_PL.aff`, `pl_PL.dic` and the original attribution notice into
`%LOCALAPPDATA%/WordCraft/dictionaries`, a directory searched by the proofing
engine. Restart WordCraft after installation. The data stays outside the program
directory, so replacing the application does not remove it.

Source and author: [SJP.PL](https://sjp.pl/sl/ort/). Selected licence: Apache-2.0
(the upstream notice also offers GPL-2.0, LGPL-2.1, MPL-1.1 and CC-BY-4.0).
The original dictionary bytes and their encoding are preserved. No dictionary
data is bundled in this repository.

