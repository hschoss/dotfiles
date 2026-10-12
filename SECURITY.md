# SECURITY

A security review of this dotfiles repository and ideas for hardening it.
Findings are grouped by severity. Each entry names the file and line, says
what the risk is, and gives a concrete fix.

The threat model assumed here is realistic for personal dotfiles:

- An attacker who can write to `$HOME` (e.g. a compromised untrusted app
  running as your user, a careless script, or shared/multi-user hosts).
- Accidental leakage of secrets through commits.
- Supply-chain-style tampering with tools picked up from `$PATH`.
- Malicious files you open (crafted LaTeX, modelines, OSC escapes).

It does **not** try to defend against an attacker who already has root
or an uncontained process running as your user with a shell open.

---

## Resolution status

Each row below has a type:

- **FIX** — a code / config change landed in a commit. Verified.
- **AUDIT** — an audit was performed to decide whether a change was
  needed. The outcome (and the evidence used to reach it) is recorded.
- **DECISION** — the user explicitly chose how to resolve a judgment-
  call item. The decision is recorded with its date.
- **KERNEL-LIMIT** — the finding describes behavior the Linux kernel
  does not permit changing. The actual security property (parent-dir
  ownership, access mode) is verified separately.

Not every security finding is a bug to patch — some are policy choices
or audit outcomes. The language below says which, with evidence, so
future-you can tell the difference without re-reading the transcript.

| ID  | Type / Status        | Commit        | Evidence / Notes |
|-----|----------------------|---------------|------------------|
| H1  | FIX                  | `39c56e5`     | awk uses `-v drop=` instead of inlining `$1` |
| H2  | FIX                  | `39c56e5`     | `.gitignore` is allowlist-first; denylist kept as defense-in-depth; gitleaks pre-commit/pre-push hooks wired via `core.hooksPath` |
| H3  | FIX                  | `39c56e5`     | `set nomodeline` + `set modelines=0` in `.vimrc` |
| M1  | FIX                  | `39c56e5`     | `source_private` now also checks parent-dir ownership and group/other-write bits |
| M2  | FIX + AUDIT          | `273deea`     | FIX: `~/.local/bin` prepended; `~/bin` appended. AUDIT: `~/.local/bin` chmod 0755 verified; `~/bin` does not exist on this host (nothing to audit); no world-writable regular files found in `~/.local/bin` (symlinks noted separately below under KERNEL-LIMIT). The "never `curl \| bash`" line stays as advisory guidance, not a code change. |
| M3  | FIX                  | `39c56e5`     | tmux `set-clipboard external` |
| M4  | FIX                  | `39c56e5`     | `plugins.bash` uses `$DOTFILES_HOME`; requires ownership before `eval`-ing dircolors |
| M5  | FIX                  | `39c56e5`     | `umask 077` in `bash/settings.bash` |
| M6  | FIX                  | `39c56e5`     | `HISTCONTROL=ignoredups:ignorespace:erasedups`, `HISTIGNORE` list, `HISTTIMEFORMAT` |
| L1  | FIX                  | `39c56e5`     | `install-dev.sh` / `install-server.sh` are thin wrappers around `install-common.sh` |
| L2  | FIX                  | `39c56e5`     | adopt path uses temp symlink + `mv -f` (atomic) |
| L3  | FIX                  | `39c56e5`     | `latexmk -no-shell-escape` |
| L4  | FIX                  | `39c56e5`     | `git/.config/git/config` with SSH signing on; machine key path in `~/.gitconfig.local` (set in the local-dotfiles repo). Live verification: shape OK via disposable key; real signing needs `ssh-add ~/.ssh/id_ed25519_hschoss` once per session (passphrase-protected). |
| L5  | FIX                  | `39c56e5`     | `machine_name()` quotes `$HOME`, requires ownership of `~/.name`, strips non-`[A-Za-z0-9._-]` bytes |
| L6  | FIX                  | `273deea`     | `writebackup` + `backupcopy=yes` + `backupdir=~/.cache/vim/backup//,.` |
| L7  | FIX                  | `39c56e5`     | duplicate unguarded `. ~/.bashrc.local` tail removed |
| L8  | AUDIT → no action needed; DECISION recorded | n/a | **Audit evidence:** (1) `gh repo view hschoss/dotfiles-local --json visibility,isPrivate` → `{"isPrivate":false, "visibility":"PUBLIC"}`; (2) `git grep -nE 'hannes\|schlaeptop\|hschoss\|/home/[a-zA-Z]+'` across the local repo's tracked content → only `hschoss` (GitHub handle, unavoidable) and `arch-schlaeptop` as a directory name remain; (3) `gitleaks git --no-banner --redact` across both repos' full history → `no leaks found` (18 + 13 commits). **Decision:** User asked via `AskUserQuestion` on 2026-10-13 whether to flip the repo private; chose "No — keep it public". Audit says this is defensible given (1)-(3). No code change applies; a scrub of `arch-schlaeptop/` → `desktop/` is listed as "longer-term" below, not actioned by this review. |

### Operational

| Task                | Status | Notes |
|---------------------|--------|-------|
| Install gitleaks    | DONE   | `/usr/bin/gitleaks` installed by user |
| Run history scan    | DONE   | `gitleaks git` on both repos: `no leaks found` (18 commits base, 13 commits local) |
| Set `user.signingkey` | DONE | `~/.gitconfig.local` → `~/.ssh/id_ed25519_hschoss.pub`; `~/.config/git/allowed_signers` populated |
| Re-stow             | DRY-RUN SHOWN | `install-common.sh --dry-run` prints clean link for the new `git/config`; pre-existing non-symlink files in `~/.config/{gh,git}` are user-managed conflicts, resolved manually with `stow --adopt` or `rm` |

### KERNEL-LIMIT: `~/.local/bin` symlink mode (surfaced during M2 audit)

**Finding** `find ~/.local/bin -perm /o+w` reports 80 symlinks (TeX
Live and friends, plus `claude` and `codex`) with mode `0777`.

**Why it cannot be "fixed"**

> **man 7 symlink** (POSIX / Linux): *On Linux, the permissions of a
> symbolic link are not used in any operation; the permissions are
> always 0777 (read, write, and execute for all user categories), and
> can't be changed.*

Verified in-session: `chmod -h 0755 <symlink>` on ext4 is a silent
no-op. `stat` continues to report `0777`. There is no kernel API to
change this.

**Why it does not create an exposure**

Access to a symlink entry is governed by the containing directory, not
by the symlink's own stored mode. The directory `~/.local/bin` is
`0755 hannes:hannes` (verified 2026-10-13 with `stat`). No other local
UID has write access to that directory, so no other UID can create,
delete, rename, or replace any symlink in it, regardless of the
reported `0777`.

**Verified security property (what actually matters):**

- `stat -c '%a %U:%G' ~/.local/bin` → `755 hannes:hannes`
- All resolved targets (`claude`, `codex`, `latexmk`, `pdflatex`) are
  `0755 hannes:hannes` (verified in-session).

This is the correct resolution for a kernel-constrained finding:
document the constraint, verify the actual access property, record
the evidence. There is no further code change to make.

---

## High

### H1. Command injection in `path_remove` (`shell/functions.sh:1-3`)

```sh
path_remove() {
    PATH=$(printf '%s' "$PATH" | awk -v RS=: -v ORS=: "\$0 != \"$1\"" | sed 's/:$//')
}
```

The argument `$1` is interpolated directly into the awk program string.
A caller that passes an attacker-influenced value (e.g. an entry picked up
from the environment or a tool's output) can break out of the string
literal and run arbitrary awk/`system()` code. In practice this is only
called with hard-coded paths from `bootstrap.sh`, so the live risk is low,
but the pattern is dangerous and will bite if the function is ever reused.

**Fix:** pass the value through awk as a variable, never as program text:

```sh
path_remove() {
    PATH=$(printf '%s' "$PATH" | awk -v RS=: -v ORS=: -v drop="$1" \
        '$0 != drop' | sed 's/:$//')
}
```

Same change for `path_append`/`path_prepend` (they call `path_remove`).
Consider also stripping an empty final component so you don't end up with
a trailing `:` that silently adds `.` to `PATH` on some tools.

---

### H2. `.gitignore` uses a denylist for secrets

`.gitignore` lists many well-known secret paths (good), but a denylist can
only block what you remember. New tools store credentials in new places.
A single `git add .` on a fresh machine with an unlisted secret file
publishes it.

Missing patterns worth adding today:

- `*.jks`, `*.keystore`, `*.asc`, `*.gpg`
- `*.ovpn`, `wg*.conf`, `*.wg`, `*.conf.enc`
- `*token*`, `*secret*`, `*credential*`, `*apikey*` (coarse but useful)
- `.config/mc/mcpass`, `.config/op/`, `.config/gcloud/`, `.config/doctl/`
- `.config/pass/`, `.password-store/`
- `.ssh/authorized_keys`, `.ssh/known_hosts` (not strictly secret but
  reveal infrastructure)
- `*.enc`, `*secrets.yaml`, `secrets.yml`, `.env.local`

**Better:** flip to an allowlist model. In the dotfiles repo, keep the
tree empty-by-default (`*` in `.gitignore`, then `!path/you/want`). GNU
Stow works fine with this. A single misplaced file then cannot sneak in.

Also run `git secrets` / `gitleaks` as a `pre-commit` hook so any
accidental AWS key, PEM header, or high-entropy string is caught before
it leaves the machine.

---

### H3. Vim modelines are not disabled (`.vimrc`)

Modelines are not explicitly turned off. On many distros they are on by
default. Modelines have a long history of RCE-grade CVEs (notably
CVE-2019-12735 via `:source!`). Opening a hostile file (e.g. a repo you
cloned to review) can execute code.

**Fix:** add near the top of `.vimrc`:

```vim
set nomodeline
set modelines=0
```

If you want modelines for a trusted directory, enable them conditionally
with an autocmd — do not leave them globally on.

---

## Medium

### M1. `source_private` has a TOCTOU window and does not vet parent dirs
(`.bashrc:20-34`)

The function `stat`s the file, then calls `source`. Between those two
syscalls an attacker who can write to the file's directory can swap the
file for one with the same permissions but hostile content. The check
also validates only the file, not its parent — a world-writable `$HOME`
(or `~/.config/shell/local/`) lets an attacker replace a 0600 file wholesale.

**Fix:**

1. Add a parent-directory check: refuse to source if the containing
   directory is group/other-writable or not owned by the user.
2. Prefer `[ "$(find "$1" -maxdepth 0 -perm -o+w -o -perm -g+w)" ]`
   semantics over bash substring parsing of `stat %a`, which breaks on
   4-digit modes (setuid/setgid). Or use `stat -c '%a %U %G'` and parse
   explicitly.
3. Accept the TOCTOU risk as inherent to shell startup, but tighten the
   defaults by, e.g., running `chmod 0700 ~/.config/shell/local`.

### M2. Loose `PATH` prepending (`shell/bootstrap.sh`)

```sh
path_prepend "$HOME/.local/bin"
path_prepend "$HOME/bin"
```

Prepending user-writable directories means any binary dropped there wins
over system binaries (`ls`, `sudo`, `ssh`, ...). This is the standard way
to allow user overrides, and the directories are yours — but combined
with any process that can write to `$HOME`, it is a trivial persistence
and privilege-escalation vector against your own session.

**Mitigations:**

- `chmod 0755 ~/.local/bin ~/bin` and audit regularly: `find ~/.local/bin
  ~/bin -type f -newer /some/anchor`.
- Consider `path_append` for one of them so user binaries do not shadow
  system commands unless you move them explicitly.
- Never run `curl ... | bash` installers that drop binaries into
  `~/.local/bin` without reviewing what they wrote.

### M3. tmux `set-clipboard on` enables OSC 52 clipboard writes
(`.tmux.conf:2`)

With this on, any program whose output reaches a tmux pane can set the
system clipboard via an OSC 52 escape sequence (e.g. `cat` on a crafted
file, or SSH into a hostile host). If you then paste into a terminal or
browser, you may paste a command you did not expect.

**Fix:** choose explicitly. If you want tmux to be able to *read*
selections but not accept writes from applications, use
`set -g set-clipboard external` (tmux ≥ 2.6). If you keep `on`, be aware
of this and avoid blindly pasting from the clipboard into a shell.
`xterm.disallowedPasteControls` or terminal-level bracketed-paste
protection is the real defense; tmux config alone is not.

### M4. `$DOTFILES` vs `$DOTFILES_HOME` mismatch (`bash/plugins.bash:5-6`)

`.bashrc` exports `DOTFILES_HOME`, but `plugins.bash` references
`$DOTFILES`. Today this is a benign bug — the test falls through to
`dircolors -b`. However:

- `eval "$(dircolors -b "$DOTFILES/shell/dircolors.elflord")"` runs
  whatever the file contains. If a shared account exports `DOTFILES`
  pointing elsewhere, or if the variable is later set from an untrusted
  source, you are evaluating a dircolors file you did not intend to.
- Any `eval "$(...)"` on a path that resolves from an unvalidated
  variable is a tripping hazard. Validate first (`[ -r "$f" ] && [ -O
  "$f" ]`) and fail closed otherwise.

**Fix:** rename to `DOTFILES_HOME` consistently, or set
`DOTFILES="$DOTFILES_HOME"` once in `.bashrc`. Validate the path before
`eval`ing dircolors output.

### M5. No `umask` set in shell init

The shell inherits whatever umask the login manager hands it. On many
desktops that is `022`, which means files you create are world-readable.
Secrets accidentally written as `touch secrets.txt` end up at 0644.

**Fix:** `umask 077` for private machines, or at least `umask 027`, in
`bash/settings.bash`.

### M6. Shell history can capture secrets (`bash/settings.bash:1-5`)

`HISTSIZE` is 1 Mi and `HISTCONTROL`/`HISTIGNORE` are unset. Any secret
pasted on the command line (`curl -H "Authorization: Bearer ..."`,
`MYSQL_PWD=... mysql ...`, `aws configure --...`) is persisted to disk
and later searchable.

**Fix:**

```sh
HISTCONTROL=ignoredups:ignorespace:erasedups
HISTIGNORE='pass:*:*TOKEN*:*SECRET*:*PASSWORD*:*AWS_*:*API_KEY*'
HISTTIMEFORMAT='%F %T '
```

The leading-space `ignorespace` discipline (preface sensitive commands
with a space) only works if you remember. Combine with
`unset HISTFILE` for shells where you plan to type secrets, or use a
secrets manager (`pass`, `op`) so the plaintext never hits the prompt.

---

## Low / Hardening ideas

### L1. The three `install-*.sh` scripts are byte-identical

`install-common.sh`, `install-dev.sh`, `install-server.sh` have the same
content. Not a security bug, but the names imply different trust
boundaries (dev vs. server) that are not actually enforced. Either:

- Collapse them into one script with a `--profile` flag, or
- Make them differ in which packages they stow, and run `check.sh` in CI
  to prevent them drifting back to identical.

The risk is subtle: on a server you probably do not want the full dev
toolchain in `$PATH`. Right now the script does not help you avoid that.

### L2. `install-*.sh`: `rm` on existing files on adoption
(`scripts/install-common.sh:47`)

The adopt path removes the existing file before symlinking:

```sh
rm "$target_path"
ln -s ".dotfiles/$1" "$target_path"
```

A crash between the two leaves you with no file. Use `ln -sfn` to replace
atomically, or at minimum move aside instead of delete:

```sh
mv "$target_path" "$target_path.pre-stow.$(date +%s)"
ln -s ".dotfiles/$1" "$target_path"
```

Also, the comparison `cmp -s` only guarantees content equality at that
moment — a hostile process could race the comparison. Low practical risk,
but worth noting.

### L3. LaTeX render path (`.vimrc:172-192`)

`latexmk -pdf -interaction=nonstopmode` runs on whatever `.tex` buffer is
active. LaTeX can execute code via `\write18` (shell-escape) and can read
arbitrary files via `\input` / `\openin`. Modern texlive defaults
restrict `\write18`, but packages and local configs can re-enable it.

**Fix:** pass `-no-shell-escape` explicitly, so you fail closed:

```vim
let l:command = 'latexmk -pdf -no-shell-escape '
      \ . '-interaction=nonstopmode -file-line-error '
      \ . '-outdir=' . shellescape(l:build) . ' ' . shellescape(l:tex)
```

Same thinking for `Rscript -e`: `s:RenderCurrentRmd` builds an R
expression from the filename via `json_encode`, which is safe for the
*path*, but `rmarkdown::render` will then execute whatever R/knitr chunks
the document contains. Only render Rmd files you trust.

### L4. Git signing is not configured here

The repo does not include a `.gitconfig` / `.config/git/config` with
`commit.gpgsign`, `tag.gpgsign`, or `gpg.format = ssh`. Commits made from
machines set up by these dotfiles are therefore unsigned by default,
making impersonation easier on shared forges.

**Fix:** add a `git/.config/git/config` with signing enabled (SSH signing
keyed off your existing key is low-friction). Keep the secret key out of
the repo (it already would be via `.gitignore`'s `id_ed25519*` rule, but
see H2 — switch to allowlist).

### L5. Prompt runs `cat $HOME/.name` and `hostname` every prompt
(`bash/prompt.bash:12-22`)

Not a vulnerability, but `$HOME/.name` is read on every prompt without
quoting. `"$HOME"/.name` is quoted correctly. Also, if `~/.name` is ever
world-writable, your prompt displays attacker-controlled text — which can
include terminal escapes (title-bar hijacking, cursor repositioning).

**Fix:** quote (`"$HOME/.name"`), sanitize the content
(`tr -dc 'A-Za-z0-9._-'`), and `chmod 0644 ~/.name` with ownership check.

### L6. `.vimrc` sets `set nowritebackup` (`.vimrc:238`)

Not a security concern on its own, but combined with `set autoread`
(`:42`) you lose two of vim's natural safety nets against concurrent
modification (a crash during write can truncate a file; an external
process can replace a file mid-edit without warning).

Consider `set writebackup` + `set backupcopy=yes` (write to a temp and
rename), especially on files that live in `$HOME` where other tools may
touch them.

### L7. Local-override files sourced from many places

`.bashrc` sources, in order:

- `~/.shell_local_before`, `~/.bashrc_local_before`
- `~/.shell_local_after`, `~/.bashrc_local_after`
- `~/.shell_private`
- `~/.config/shell/local/*.sh`
- `~/.local/share/dotfiles-local/*.sh`
- `~/.bashrc.local` (twice — see below)

Each is an attack surface if an attacker can plant a file. The
`source_private` guard helps but see **M1**. The last entry is also
loaded twice (`source_private` call on line 68 and a plain
`. ~/.bashrc.local` on line 77 that *does not* use the guard). The
unguarded second source means any `~/.bashrc.local` your user owns gets
run even if its permissions are wrong.

**Fix:** remove the unguarded `[ -f ~/.bashrc.local ] && . ~/.bashrc.local`
at the bottom of `.bashrc`. The guarded `source_private` call above
already handles it.

### L8. `README.md` points at a public `dotfiles-local` repo on GitHub

The README says machine-specific settings live in a public
`hschoss/dotfiles` repo. If that repo contains anything environment-
specific (hostnames, paths, SSH host snippets, cluster names), it is a
reconnaissance aid. Make sure that repo is either private, or carefully
scrubbed of per-machine identifiers.

---

## Hardening checklist

All items from this review are resolved; see the resolution-status
table at the top for commit hashes and audit evidence.

- [x] **H1** — fix awk interpolation in `path_remove`.
- [x] **H2** — flip `.gitignore` to allowlist; add `gitleaks` pre-commit hook.
- [x] **H3** — `set nomodeline` + `set modelines=0` in `.vimrc`.
- [x] **M1** — add parent-dir checks to `source_private`.
- [x] **M2** — PATH ordering + `~/.local/bin` audit.
- [x] **M3** — tmux `set-clipboard external`.
- [x] **M4** — reconcile `$DOTFILES` vs `$DOTFILES_HOME`.
- [x] **M5** — set `umask 077` in `bash/settings.bash`.
- [x] **M6** — tighten `HISTCONTROL`/`HISTIGNORE`.
- [x] **L1** — collapse `install-*.sh` into thin wrappers.
- [x] **L2** — atomic adopt in `install-common.sh`.
- [x] **L3** — add `-no-shell-escape` to the latexmk invocation.
- [x] **L4** — commit a signing-enabled git config.
- [x] **L5** — sanitize `machine_name()` reading of `~/.name`.
- [x] **L6** — vim `writebackup` + `backupcopy=yes`.
- [x] **L7** — remove the duplicate unguarded `~/.bashrc.local` source.
- [x] **L8** — audit the public `dotfiles-local` repo (public kept per user decision 2026-10-13; `gitleaks` + `git grep` clean).

