# PMP / Hyphens Business Central Extensions

Microsoft Dynamics 365 Business Central **AL extensions** for the PMP / Hyphens pharma distribution business in Singapore. They're published by **Illum (9) Pte Ltd**.

Each top-level folder is a separate AL app with its own `app.json`, `.vscode/launch.json` and permission set. The repository as a whole is built and deployed as one **AL-Go for GitHub** (PTE) project.

---

## Apps

| Folder | App name | Object IDs | BC application / runtime | Purpose |
|---|---|---|---|---|
| `PMP-SG-Base` | PMP-SG-Base | 55000–55999 | 20.0 / 9.0 | Data layer: tables, table extensions, enums |
| `PMP-SG-Implementation` | PMP-SG-Implementation | 55000–55999 | 20.0 / 11.0 | Business logic and UI: pages, page extensions, codeunits, queries |
| `PMP-SG-Reports` | PMP-SG-Reports | 57000–57999 | 20.0 / 11.0 | Reports and Word layouts |
| `PMP-SG-Integration-POM` | POM | 59000–59149 | 27.0 / 16.0 | API pages and control add-ins for the external POM ordering system |
| `PMP-SG-Integration-ChainPharmas` | PMP-SG-ChainPharm | 90000–90100 | 20.0 / 13.0 | ChainPharmas integration |
| `PMP-SG-Integration-Citibank` | PMP-SG-Integration-Citibank | 52150–52199 | 20.0 / 9.0 | Citibank banking integration |
| `PMP-SG-Integration-DBS` | PMP-SG-Integration-DBS | 52000–52099 | 20.0 / 9.0 | DBS banking integration |
| `PMP-SG-Integration-DKSH` | PMP-SG-DKSH | 52100–52149 | 20.0 / 9.0 | DKSH integration |
| `PMP-SG-Integration-EPaper` | PMP-SG-Integration-EPaper | 56000–56099 | 20.0 / 9.0 | E-Paper integration |
| `PMP-SG-Integration-VersaFleet` | PMP-SG-Integration-VersaFleet | 69000–69099 | 20.0 / 9.0 | VersaFleet delivery integration |
| `PMP-SG-Integration-Wellaway` | PMP-SG-Integration-Wellaway | 60100–60149 | 20.0 / 9.0 | Wellaway integration |
| `PMP-SG-Integration-Zuellig` | PMP-SG-Integration-Zuellig | 56100–56199 | 20.0 / 9.0 | Zuellig integration |
| `PMP-SG-Maxxholo` | PMP-SG-Maxxholo | 66000–66099 | 20.0 / 9.0 | Maxxholo customisations |
| `PMP-HPPL-Patch` | PMP-HPPL-Patch | 99000–99999 | 20.0 / 9.0 | HPPL patches |
| `Hyphens-PMP-Interco` | Hyphens-PMP-Interco | 56200–56349 | 20.0 / 9.0 | Intercompany between Hyphens and PMP |
| `Hyphens Base` | Hyphens Base | 50000–50149 | 20.0 / 9.0 | Base data layer for the Hyphens company |
| `Hyphens Implementation` | Hyphens Implementation | 50000–50149 | 20.0 / 9.0 | Hyphens business logic and UI |
| `Novem_Base` | PMP-SG-NovemBase | 70000–71999 | 24.4 / 13.1 | Novem sub-stack: base |
| `Novem_Functions` | PMP-SG-NovemFunctions | 70000–71999 | 24.4 / 13.1 | Novem sub-stack: functions |
| `Novem_PMP` | Novem_PMP | 80130–80160 | 25.0 / 14.0 | Novem sub-stack: PMP-specific |
| `I9-UserSecurity` | I9-UserSecurity | 59100–59149 | 25.0 / 14.0 | Standalone user-security app (target Cloud) |
| `PMP-SG-Halal Module` | HalalModule | 50000–50200 | 20.0 / 9.0 | Halal module. **Not built by CI** (see below) |

### Dependency architecture

```
PMP-SG-Base                      tables, table extensions, enums (data layer)
  └─ PMP-SG-Implementation       pages, codeunits, queries (logic / UI)
       ├─ PMP-SG-Integration-*   POM, DBS, Citibank, DKSH, EPaper, Zuellig, Wellaway, VersaFleet, ChainPharmas
       ├─ PMP-SG-Reports         (also PMP-SG-Base, Hyphens Base)
       ├─ PMP-SG-Maxxholo, PMP-HPPL-Patch, Hyphens-PMP-Interco, Hyphens Implementation
       └─ Novem_Base → Novem_Functions → Novem_PMP   (VersaFleet also depends on Novem_PMP)

Hyphens Base                     standalone; used by Reports, Hyphens Implementation,
                                 Novem_Functions, PMP-HPPL-Patch
```

Things to keep in mind:

- **Change core apps carefully.** A field or table added to `PMP-SG-Base` has to be published before `PMP-SG-Implementation` can use it. A change to Implementation's public surface can break every integration app.
- **Dependency versions are minimums.** The versions in dependents' `app.json` are often well behind the current core versions, and that's expected.
- **BC versions vary by app.** Apps declare `application` 20.0 through 27.0 and runtime 9.0 through 16.0, so check the target app's `app.json` before you use newer AL syntax. CI always compiles against the **current SaaS version**, which means any API Microsoft has removed breaks the build.
- **Object ID ranges overlap.** Base and Implementation share 55000–55999. Hyphens Base and the Halal Module both start at 50000, and both have a table 50003. POM and I9-UserSecurity overlap at 59100–59149. Before you pick a new object ID, **grep the whole repo for it**.

---

## CI/CD (AL-Go for GitHub)

| Item | Location |
|---|---|
| Project settings | `.AL-Go/settings.json` |
| Repo settings | `.github/AL-Go-Settings.json` |
| Workflows | `.github/workflows/` (AL-Go system files) |

- **Workflows:** don't edit these by hand. Update them by running the **Update AL-Go System Files** workflow.
- **Apps built:** CI builds only the apps listed in `appFolders` in `.AL-Go/settings.json`, ordered by dependency. **A new app folder has to be added there**, or it won't be built or deployed. `PMP-SG-Halal Module` is left out on purpose because its table 50003 clashes with Hyphens Base.
- **Compilation:** apps compile against the latest **w1 sandbox** artifact using `useCompilerFolder`, with no Docker. CodeCop, UICop and PerTenantExtensionCop run, and only errors fail the build.
- **Compile-only dependencies:** these third-party apps are committed in `dependencies/` and listed in `installApps`. CI doesn't deploy them, so they **must already be installed** in the target environments.
  - Illum Solutions E-Invoice Base
  - English language (Australia)
- **Versioning:** the pipeline stamps every app as `2.0.<CI/CD run number>.0` (`versioningStrategy` 16, `repoVersion` 2.0). The version in `app.json` is ignored, so don't bump it by hand. To move to a new major.minor, change `repoVersion`.

### Release flow

1. **Pull request:** *Pull Request Build* runs.
2. **Merge to `main`:** *CI/CD* builds the apps and deploys them automatically to the GitHub environment **`Sandbox`** (BC environment `Prod30082024`).
3. **Production:** run *Create Release*, then *Publish To Environment* with **`Production`** (BC environment `Production`). This step requires approval in the GitHub environment.

Deployments use PTE scope with sync mode `Add`. Credentials come from the `AUTHCONTEXT` secret on each GitHub environment.

> BC SaaS can't downgrade an extension. To roll back, fix forward, or restore the environment to a point in time.

---

## Local development

### Prerequisites

- VS Code with the **AL Language** extension
- Access to a **dev sandbox** where you can publish

### Workflow

1. Open the **app folder** (for example `PMP-SG-Implementation/`) in VS Code, not the repository root.
2. Run **AL: Download Symbols**. Symbols are saved to that folder's `.alpackages/`.
3. Point `.vscode/launch.json` at your dev sandbox, then publish with **F5** / **Ctrl+F5** (`schemaUpdateMode: Synchronize`).

> ⚠️ **Don't publish from VS Code to `Prod30082024` or `Production`.** A dev-scope publish blocks the pipeline's PTE deployment of the same app. Also, don't switch to `ForceSync` unless you're sure, because it can drop data.

Local edits to `tenant` / `environmentName` in `launch.json` are normal. Don't commit them.

### Command-line compile

Once you've downloaded symbols, you can check that an app builds without VS Code. `alc.exe` needs the .NET 10 runtime, and you can use the copy that VS Code downloads:

```bash
DOTNET_ROOT="$APPDATA/Code/User/globalStorage/ms-dotnettools.vscode-dotnet-runtime/.dotnet/10.0.12~x64~aspnetcore" \
"$HOME/.vscode/extensions/ms-dynamics-smb.al-18.0.2732683/bin/alc.exe" \
  /project:"<AppFolder>" /packagecachepath:"<AppFolder>/.alpackages" /out:"<AppFolder>/out.app"
```

Adjust the paths to match the AL extension and .NET versions you have installed.

There are no automated test apps in this repository.

---

## Conventions

- **Folder layout:** files are grouped into folders by object type, such as `Table`, `TableExt`/`TblExt`, `Page`, `PageExt`, `Codeunit`, `Report`, `Queries`, `XMLPorts` and `APIs`.
- **File naming:** follow the style of the app you're working in.
  - Newer apps use the AZ AL Dev Tools style, for example `Pag59005.BonusAPI.al`.
  - Older apps use names like `Codeunit 55000 TBA.al`.
- **Permissions:** when you add objects, add matching entries to the app's `extensionsPermissionSet.xml` (ObjectType 0 = TableData, 8 = Page, …). A few newer apps use `.permissionset.al` instead.
- **Report layouts:** Word report layouts (`.docx`) are stored under folders such as `PMP-SG-Reports/ReportExtLayouts/`.
- **Git-ignored files:** built `.app` files, `.alpackages/` and `rad.json` aren't committed. The one exception is `dependencies/*.app`. Release builds are in CI artifacts and GitHub Releases.
