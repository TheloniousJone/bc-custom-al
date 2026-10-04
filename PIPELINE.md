# How Our Pipeline Works (Explained Simply)

This page explains, in plain words, how our code gets from a computer into **Business Central (BC)**. No experience needed.

---

## 1. The big idea: a robot factory 🏭

Picture a **toy factory with a robot** working in it.

- **You** design a toy: you write AL code.
- You drop the design in the **mailbox**: you push the code to **GitHub**.
- The **robot** picks it up, **builds the toy** and **checks it isn't broken**. This robot is **AL-Go for GitHub**.
- If the toy is fine, the robot **delivers it to the shop**. The shop is **Business Central**.

That robot is the **pipeline**. People also call it **CI/CD**:

- **CI** (*Continuous Integration*) means "build and check the code every time it changes".
- **CD** (*Continuous Deployment*) means "deliver it to Business Central automatically".

Before the robot, someone had to build each app by hand in VS Code and press F5 to publish it. That was slow, and easy to get wrong.

---

## 2. The pieces we set up 🧩

### 🗂️ The code box: the GitHub repository

All our apps (PMP-SG-Base, PMP-SG-Implementation, the integrations, the reports, …) live in one place on GitHub:

> **`TheloniousJone/bc-custom-al`**

Every top-level folder is one app. Each app is like one toy in the box.

### 📋 The robot's instruction sheets: the settings files

The robot has two small files that tell it what to do:

| File | What it tells the robot |
|---|---|
| `.AL-Go/settings.json` | **Which apps to build** (the `appFolders` list), which BC version to build against, and which extra apps it needs to borrow |
| `.github/AL-Go-Settings.json` | **Where to deliver**: the `Sandbox` and `Production` environments, and how version numbers work |

**Remember:** if you create a **new app folder**, add it to the `appFolders` list. Otherwise the robot won't see it and won't build it.

The `PMP-SG-Halal Module` app is **left out on purpose**. It uses the same object number (table 50003) as Hyphens Base, and BC doesn't allow two objects with the same number.

### 🤖 The robot's brain: the workflows

The folder `.github/workflows/` holds the robot's recipes, such as *CI/CD*, *Pull Request Build*, *Create Release* and *Publish To Environment*.

⚠️ **Don't edit these by hand.** Microsoft supplies them. To update them, run the **Update AL-Go System Files** workflow.

### 🎒 Borrowed parts: the `dependencies/` folder

Some of our apps need **other companies' apps** to compile, like borrowing a Lego piece from a friend:

- *E-Invoice Base* (Illum Solutions)
- *English language (Australia)* (Microsoft)

The robot borrows them **only to build**. It **doesn't deliver them** to BC, so they must **already be installed** in Business Central.

---

## 3. The key to the shop: how the robot gets into BC 🔑

Business Central won't let a stranger walk in, so we gave the robot its **own ID card**.

**Step 1: make the ID card (in Microsoft Entra / Azure)**
- We created an **App Registration**. Think of it as a robot employee account.
- It has **permission to talk to Business Central** (`API.ReadWrite.All` and `Automation.ReadWrite.All`).
- It has a **Client ID**, which works like a username, and a **Client Secret**, which works like a password.
- We added a **redirect address** (`https://businesscentral.dynamics.com/OAuthLanding.htm`). Without it, the "Grant Consent" button in BC gives the error `AADSTS500113`.

**Step 2: tell BC to trust the card (in each BC environment)**
- In BC, on the **Microsoft Entra Applications** page, we added the robot's Client ID.
- We gave it the permission sets **D365 AUTOMATION** and **EXTEN. MGT. - ADMIN**, which let it install extensions.
- We clicked **Grant Consent**.

**Step 3: hide the key in GitHub's safe**
- In GitHub, under **Settings → Environments**, we made two "rooms":
  - **`Sandbox`** delivers to the BC test environment `Prod30082024`.
  - **`Production`** delivers to the real BC environment `Production`.
- Each room has a locked secret called **`AUTHCONTEXT`**. It holds the tenant ID, Client ID and Client Secret, and the robot reads it when it needs to sign in.
- Both rooms only accept deliveries from the **`main`** branch.

🔒 **Golden rule:** never paste a password, client secret or GitHub token (PAT) into a chat, email or code file. If you do, **delete or revoke it straight away** and create a new one.

---

## 4. The journey of a code change 🚂

```
 You write code
      │
      ▼
 ① Push to a feature branch (feature/something)
      │   The robot BUILDS and CHECKS it. Nothing goes to BC yet.
      ▼
 ② Open a Pull Request into main
      │   "Pull Request Build" runs: one more check.
      ▼
 ③ Merge into main
      │   "CI/CD" runs: BUILD + automatic DELIVERY to the Sandbox
      │   (BC environment Prod30082024)
      ▼
 ④ Happy with the Sandbox? Run "Create Release"
      │   A labelled box of the finished apps is saved on GitHub.
      ▼
 ⑤ Run "Publish To Environment" → Production
          The apps are delivered to the real BC (Production).
```

Things to remember:

- **Only `main` delivers to BC.** If you push to a feature branch, the robot only builds and checks.
- **Production is never automatic.** A person has to start step ⑤ on purpose.
- **Why we don't keep a `dev` branch:** the robot doesn't listen to a branch called `dev`. Short-lived `feature/...` branches plus pull requests are the way to go.

---

## 5. Version numbers: the robot counts for you 🔢

Every app the robot builds gets the version:

```
2.0.<run number>.0
```

For example, robot run number **#15** produces version **`2.0.15.0`** of every app.

- **Don't change the version in `app.json` by hand.** The robot ignores it.
- To jump to `3.0`, change `repoVersion` in `.github/AL-Go-Settings.json`.

⚠️ **BC can't go backwards** (it can't "downgrade"). If something breaks, you can't reinstall an older version. Either **fix the code and deliver a newer version**, or restore the whole BC environment to an earlier point in time.

---

## 6. The first problem we fixed 🛠️

**What happened:** the first build failed with the message *"App generation failed"*.

**Why:** the robot always builds against the **newest Business Central (version 29)**. In version 29, Microsoft **removed** a function called `XML Buffer.GetAttributeValue`, which our **ChainPharmas** app was still using. It's like a Lego piece that's no longer made: the model can't be built any more.

It still worked on our own computers because we had the **older version 28.5** pieces.

**The fix:** in `PMP-SG-Integration-ChainPharmas/Codeunit/Cod90000.ChainPharma.al` we replaced all 10 uses with the new piece Microsoft recommends, **`GetAttributeValueAsText`**. It does the same job.

**Coming up later** (these still work now, but will break in a future BC version):
- **Hyphens Implementation:** 5 reports use the old field `Invoice Copies`.
- **I9-UserSecurity:** 2 objects use the old `Permission` table. The new one is `Expanded Permission`.

💡 **Tip:** when VS Code shows a warning like **`AL0432 ... is marked for removal`**, that piece is going away. Fix it early so the robot doesn't fail later.

---

## 7. What the grey "skipped" steps mean ⏭️

In a GitHub run, some steps are grey and say **skipped**. That's normal:

- **Build PowerPlatform Solution** is for Power Apps or Power Automate projects. We don't have any, so the robot skips it.
- **Deploy** is skipped when the run is on a **feature branch**, because only `main` delivers.

---

## 8. How to check the code arrived in BC ✅

1. **In GitHub → Actions:** open the run. The **Deploy - Sandbox** job should have a **green tick**.
2. **In Business Central → Extension Management:** find the app and check:
   - **Version** = `2.0.<run number>.0`
   - **Published As** = `PTE`, not `Dev`
3. **Extension Management → Manage → Deployment Status** lists every delivery, and the error if one failed.
4. **Try the feature** you changed in BC and check it does what you expect.

---

## 9. Golden rules 🌟

1. ✍️ Work on a `feature/...` branch, open a pull request, then merge into `main`.
2. 🚫 Never press **F5** into `Prod30082024` or `Production`. A "Dev" copy blocks the robot's delivery. Use your own dev sandbox.
3. 🔒 Never share secrets or tokens. If one leaks, revoke it.
4. 📁 A new app folder must be added to `appFolders` in `.AL-Go/settings.json`.
5. 🔢 Don't touch version numbers by hand. The robot handles them.
6. 🔧 Don't hand-edit files in `.github/workflows/`.
7. ⚠️ Fix "marked for removal" warnings early.

---

## 10. Words cheat sheet 📖

| Word | Simple meaning |
|---|---|
| **AL** | The programming language for Business Central apps |
| **Extension / App** | A package of AL code that adds features to BC |
| **GitHub** | A website that stores our code and runs the robot |
| **Repository (repo)** | The box on GitHub that holds all our code |
| **Branch** | A separate copy of the code where you can work safely |
| **`main`** | The official branch, and the only one the robot delivers from |
| **Pull Request (PR)** | A request to put your branch's changes into `main` |
| **Merge** | Actually putting those changes into `main` |
| **Pipeline / CI/CD** | The robot that builds, checks and delivers the code |
| **AL-Go for GitHub** | Microsoft's ready-made robot for BC apps |
| **Workflow** | One of the robot's recipes (CI/CD, Create Release, …) |
| **Build / Compile** | Turning AL code into an installable `.app` file |
| **Deploy / Publish** | Installing the `.app` file into Business Central |
| **Sandbox** | A test copy of BC where it's safe to try things |
| **Production** | The real BC that the business uses every day |
| **PTE** | *Per-Tenant Extension*: an app made just for our company |
| **Environment (GitHub)** | A "room" with the settings and secrets to reach one BC environment |
| **Secret / AUTHCONTEXT** | A locked password that only the robot can read |
| **App Registration** | The robot's ID card in Microsoft Entra (Azure) |
| **PAT** | A personal GitHub password for tools. Keep it secret! |
| **Release** | A saved, labelled box of finished apps |
| **Obsolete / marked for removal** | Old code Microsoft is about to delete |
