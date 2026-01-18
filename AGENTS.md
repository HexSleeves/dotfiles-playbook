# Repository Guidelines

## Project Structure & Module Organization

This repository is an Ansible playbook used to bootstrap a developer environment across macOS, Linux desktops, and minimal cloud VMs.

- `site.yml`: back-compat entrypoint (imports `playbooks/site.yml`).
- `playbooks/`: composable entrypoints (`bootstrap.yml`, `tooling.yml`, `dotfiles.yml`, `site.yml`).
- `roles/`: reusable building blocks (`bootstrap`, `os_macos`, `os_linux`, `tooling_mise`, `tooling_bun`, `chezmoi`).
- `inventories/home/`: default inventory + var layering (`group_vars/`, `host_vars/`).
- `ansible.cfg`: local Ansible defaults (inventory, caching, privilege escalation).
- `bootstrap*.sh`: helpers that install Ansible, clone this repo, and run the playbook.

## Build, Test, and Development Commands

- `./bootstrap.sh`: installs prerequisites and runs the playbook (supports `--minimal` and `--repo <url>`).
- `ansible-galaxy collection install community.general`: installs required collection(s).
- `ansible-playbook site.yml --ask-become-pass`: full setup (bootstrap + tooling + dotfiles if configured).
- `ansible-playbook playbooks/bootstrap.yml --ask-become-pass`: bootstrap only.
- `ansible-playbook playbooks/tooling.yml`: tooling only (`mise`, `bun`).
- `ansible-playbook playbooks/dotfiles.yml`: dotfiles only (via `chezmoi`).
- `ansible-playbook site.yml --check --diff`: dry-run to verify idempotence and preview changes.

## Coding Style & Naming Conventions

- YAML: 2-space indentation; prefer Ansible modules over `shell`/`command`.
- Keep tasks idempotent (use `creates`, `changed_when`, and module options appropriately).
- Put new automation in a dedicated role under `roles/` and expose it via `playbooks/` with tags.
- Variables: prefer `inventories/home/group_vars/` for environment defaults and `inventories/home/host_vars/` for per-machine overrides.
- Dotfiles: Ansible installs and drives `chezmoi`; do not add per-dotfile symlink/copy logic here.

## Testing Guidelines

There is no dedicated test suite in this repo. Validate changes by:

- Running `ansible-playbook site.yml --check --diff` first.
- Running the relevant playbook(s) twice to confirm a no-op second run.

## Commit & Pull Request Guidelines

- Commit messages follow a lightweight Conventional Commits pattern (e.g., `feat:`, `fix:`, `docs:`, `refactor:`) and should be imperative and specific.
- PRs should include: what changed, target OS/profile (`macos`, `linux`, `os_linux_machine_profile=vm`), and how it was verified (commands + results).
- Avoid committing secrets (tokens, private SSH keys). Keep personal config in `inventories/home/host_vars/` minimal and reviewable.
