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

## Packages

| Package | Application | Architectures |
| --- | --- | --- |
| `nmf` | [Nekomimist Filer](https://github.com/nekomimist/nmf) | x64, ARM64 |

The complete upstream ZIP is installed, including `LICENSE`,
`THIRD_PARTY_LICENSES.txt`, and the `licenses/` directory.

## Maintenance

`bucket/nmf.json` points to the current stable upstream release. The
**Update manifests** workflow checks every four hours using Scoop's `checkver`
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
