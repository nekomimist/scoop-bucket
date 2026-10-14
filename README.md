# nekomimist Scoop bucket

[![CI](https://github.com/nekomimist/scoop-bucket/actions/workflows/ci.yml/badge.svg)](https://github.com/nekomimist/scoop-bucket/actions/workflows/ci.yml)
[![Update manifests](https://github.com/nekomimist/scoop-bucket/actions/workflows/update.yml/badge.svg)](https://github.com/nekomimist/scoop-bucket/actions/workflows/update.yml)

Windows packages for [Scoop](https://scoop.sh/), downloaded directly from their
upstream GitHub Releases.

## Install

With Scoop installed, run in PowerShell:

```powershell
scoop bucket add nekomimist https://github.com/nekomimist/scoop-bucket
scoop install nekomimist/nmf
nmf
```

Scoop selects the x64 or ARM64 package for your machine. You can also launch
**Nekomimist Filer** from the Start menu's **Scoop Apps** folder.

## Update

Wait for file operations to finish and close all nmf windows and processes
before updating. Run these commands from a separate PowerShell window:

```powershell
scoop update
scoop update nmf
```

Then launch `nmf` again. The standard configuration and runtime state remain in
`%APPDATA%\nekomimist\nmf\`. Explicit `-profile`, `-config-dir`, or `-state-dir`
overrides still apply; pass the same options when switching from a manual ZIP
installation. Update any old shortcuts to use the Scoop installation.

## nskkzime

Install from a non-packaged PowerShell launched directly from Explorer or the
Start menu, as the user who will manage the IME. A normal, unelevated window is
sufficient. Installation stops before registration if it detects data
virtualization, which can occur in a packaged application's terminal.

```powershell
scoop bucket add extras
scoop install nekomimist/nskkzime
```

Scoop installs PowerShell 7 and the x64 and x86 Visual C++ runtimes as dependencies.
Approve UAC as the same user. The IME is registered machine-wide and its binaries
are copied to protected version directories under `%ProgramFiles%\nskkzime`.
Scoop also retains the downloaded package. Use one managing user; global Scoop
installation is unsupported. ARM64 Windows is unsupported.

Open **nskkzime Settings** in the **Scoop Apps** Start menu folder and configure
separately downloaded SKK dictionaries and a zenz model. Inference needs the CPU
features listed in the upstream README. The package does not contain dictionaries,
models, settings, or learned data.

Close applications before `scoop update nskkzime`. Updating keeps the old IME
registration until the new installer switches it, with recovery on registration
failure. Applications using the old DLL need to be restarted, or sign out and
back in. Scoop's package state and the IME's registration recovery are separate;
see the packaged README for `Status` and `Recover` commands.

`scoop uninstall nskkzime` unregisters the IME and removes this user's broker
startup entry. Protected program files and user data are retained.
Follow the upstream [complete removal instructions](https://github.com/nekomimist/nskkzime/blob/main/docs/PACKAGE_README.md#完全削除)
if you want to delete them too. `scoop cleanup` only cleans Scoop's copies; it does
not remove the protected IME version directories.

## Packages

| Package | Application | Architectures |
| --- | --- | --- |
| `nmf` | [Nekomimist Filer](https://github.com/nekomimist/nmf) | x64, ARM64 |
| `nskkzime` | [nskkzime](https://github.com/nekomimist/nskkzime) | native x64 (includes x86 IME DLL) |

Each package installs the complete upstream ZIP and its license notices.
`nmf` includes `LICENSE`, `THIRD_PARTY_LICENSES.txt`, and `licenses/`;
`nskkzime` includes `LICENSE` and `licenses/`.

## Maintenance

`bucket/nmf.json` and `bucket/nskkzime.json` point to their current stable upstream
releases. The **Update manifests** workflow checks every four hours using Scoop's `checkver`
and `autoupdate` support, and commits updated versions, URLs, and SHA-256 hashes
to `main`. Hashes come from the release's `.zip.sha256` files. Prereleases are
excluded. No separate personal access token is needed; the workflow uses this
repository's `GITHUB_TOKEN` with `contents: write`.

After publishing an upstream release, maintainers can run **Update manifests**
from the Actions tab to refresh the bucket immediately. Scheduled runs may be
delayed by GitHub; GitHub also disables schedules in public repositories after
60 days without repository activity. Re-enable the schedule in Actions if it
has been disabled.

To check or update locally with Scoop installed:

```powershell
.\bin\checkver.ps1 nmf
.\bin\checkver.ps1 nmf -Update
```

CI runs Scoop's standard bucket validation on Windows PowerShell and PowerShell
7. To run it locally, install the `BuildHelpers` and `Pester` (5.2 or newer)
PowerShell modules, then run `.\bin\test.ps1`.

Automation uses [ScoopInstaller/GithubActions](https://github.com/ScoopInstaller/GithubActions)
and the conventions of [BucketTemplate](https://github.com/ScoopInstaller/BucketTemplate).

## License

The bucket definitions and maintenance files are MIT licensed; see [LICENSE](LICENSE).
Each packaged application retains its own license and bundled third-party notices.
