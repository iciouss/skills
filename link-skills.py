#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.9"
# dependencies = ["questionary"]
# ///
"""Interactively link/unlink skills into .agents/skills via symlinks or copies."""

import re
import shutil
import sys
from pathlib import Path

import questionary
from questionary import Choice, Style

SKILLS_DIR = Path(__file__).resolve().parent / "skills"
TARGET_DIR = Path("./.agents/skills")
EXCLUDE: set[str] = set()


def available_skills() -> list[str]:
    return sorted(
        p.name for p in SKILLS_DIR.iterdir()
        if p.name not in EXCLUDE and not p.name.startswith(".")
    )


def skill_description(name: str) -> str:
    path = SKILLS_DIR / name
    target = None
    if path.is_file():
        target = path
    elif path.is_dir():
        for candidate in ("SKILL.md", "README.md", f"{name}.md"):
            if (path / candidate).is_file():
                target = path / candidate
                break

    if target is None:
        return "No description provided"

    text = target.read_text(errors="replace")
    if text.startswith("---"):
        end = text.find("\n---", 3)
        frontmatter = text[:end] if end != -1 else text
        match = re.search(r'^description:\s*["\']?(.*?)["\']?\s*$', frontmatter, re.MULTILINE | re.IGNORECASE)
        if match:
            return match.group(1)
    return "No description provided"


def is_installed(name: str) -> bool:
    dest = TARGET_DIR / name
    return dest.exists() or dest.is_symlink()


# whitetext keeps the title plain; noreverse strips prompt_toolkit's default reverse-video
STYLE = Style([
    ("selected", "fg:ansigreen noreverse"),
    ("highlighted", "fg:#ffffff noreverse"),
    ("pointer", "fg:ansiblue bold noreverse"),
    ("whitetext", "fg:#ffffff noreverse"),
])


def main() -> None:
    skills = available_skills()
    if not skills:
        print(f"No available skills found in {SKILLS_DIR}")
        sys.exit(1)

    choices = [
        Choice(
            title=[("class:whitetext", f"{name}  —  {skill_description(name)}")],
            value=name,
            checked=is_installed(name),
        )
        for name in skills
    ]

    question = questionary.checkbox(
        f"Manage skills in .agents/skills/",
        choices=choices,
        style=STYLE,
        instruction="(space: toggle item, a: toggle all, enter: confirm)",
    )
    # Drop the "invert selection" binding — not useful here and not worth the keymap noise
    question.application.key_bindings.remove("i")
    selected = question.ask()
    if selected is None:
        print("Cancelled. No changes made.")
        return
    if not selected:
        confirm = questionary.confirm(
            "No skills selected — remove/undo every skill installed by this wizard?",
            default=False,
            style=STYLE,
        ).ask()
        if not confirm:
            print("Cancelled. No changes made.")
            return
        run_removal(skills)
        return

    mode = questionary.select(
        "How should the selected skills be installed?",
        choices=[
            Choice(
                title=[("class:whitetext", "link  (symlink into the repo, tracks source)")],
                value="link",
            ),
            Choice(
                title=[("class:whitetext", "copy  (independent copy, decoupled from source)")],
                value="copy",
            ),
        ],
        style=STYLE,
    ).ask()
    if mode is None:
        print("Cancelled. No changes made.")
        return

    TARGET_DIR.mkdir(parents=True, exist_ok=True)

    changed = False
    for name in skills:
        dest = TARGET_DIR / name
        src = SKILLS_DIR / name
        if name in selected:
            if dest.is_symlink() and dest.resolve() == src.resolve() and mode == "link":
                continue
            if dest.is_symlink():
                dest.unlink()
            elif dest.exists():
                print(f"  ⚠ Skipped:  {name} ({dest} already exists)")
                continue
            if mode == "copy":
                if src.is_dir():
                    shutil.copytree(src, dest)
                else:
                    shutil.copy2(src, dest)
                print(f"  ✔ Copied:   {name}")
            else:
                dest.symlink_to(src)
                print(f"  ✔ Linked:   {name}")
            changed = True
        else:
            changed = remove_skill(name, dest) or changed

    if not changed:
        print("No changes.")


def run_removal(skills: list[str]) -> None:
    """Remove ONLY skills the wizard manages (from SKILLS_DIR) — never anything
    else living in TARGET_DIR, e.g. skills tracked in the target repo."""
    changed = False
    for name in skills:
        changed = remove_skill(name, TARGET_DIR / name) or changed
    if not changed:
        print("Nothing installed by the wizard — no changes.")


def remove_skill(name: str, dest: Path) -> bool:
    if dest.is_symlink():
        dest.unlink()
        print(f"  ✘ Unlinked: {name}")
        return True
    if dest.is_dir():
        shutil.rmtree(dest)
        print(f"  ✘ Removed:  {name}")
        return True
    if dest.is_file():
        dest.unlink()
        print(f"  ✘ Removed:  {name}")
        return True
    return False


if __name__ == "__main__":
    main()
