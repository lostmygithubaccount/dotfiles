#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "typer",
#     "rich",
# ]
# ///
"""
Sync dotfiles between repository and home directory.
"""

# Imports
import os
import shutil
import filecmp
from pathlib import Path
from typing import Optional
import typer
from rich.console import Console
from rich.prompt import Confirm
from rich.progress import Progress, SpinnerColumn, TextColumn
from rich.tree import Tree
from rich.panel import Panel

# Config
app = typer.Typer(add_completion=False, help="Sync dotfiles between repository and home directory")
console = Console()

# Constants
DOTFILES_DIR = Path(__file__).parent.parent
HOME_DIR = Path.home()
IGNORE_DIRS = {'bin', 'tasks'}  # Only ignore these specific directories

# Functions
def should_ignore_root_item(path: Path, base_path: Path) -> bool:
    """Check if a root-level item should be ignored."""
    rel_path = path.relative_to(base_path)
    
    # Only check root level items
    if len(rel_path.parts) == 1:
        name = rel_path.parts[0]
        # Ignore .git specifically and our management directories
        if name == '.git' or name in IGNORE_DIRS:
            return True
        # Include all dotfiles/directories at root level
        if name.startswith('.'):
            return False
        # Include non-dot files at root (like CLAUDE.md, AGENTS.md, setup)
        return False
    
    # For nested items, never ignore (they're under included root items)
    return False

def get_relative_files(base_path: Path) -> list[Path]:
    """Get all files relative to base path, including dotfiles."""
    files = []
    
    for root, dirs, filenames in os.walk(base_path):
        root_path = Path(root)
        
        # Filter directories at root level only
        if root_path == base_path:
            dirs[:] = [d for d in dirs if not should_ignore_root_item(base_path / d, base_path)]
        
        # Add all files in allowed directories
        for filename in filenames:
            file_path = root_path / filename
            if not should_ignore_root_item(file_path, base_path):
                rel_path = file_path.relative_to(base_path)
                files.append(rel_path)
    
    return sorted(files)

def files_are_different(src: Path, dst: Path) -> bool:
    """Check if two files are different."""
    if not dst.exists():
        return True
    if not src.exists():
        return False
    return not filecmp.cmp(src, dst, shallow=False)

def sync_file(src: Path, dst: Path) -> tuple[bool, str]:
    """Sync a single file from src to dst. Returns (success, message)."""
    try:
        # Create parent directories if they don't exist
        dst.parent.mkdir(parents=True, exist_ok=True)
        
        # Just copy the file - no interactive prompts during sync
        shutil.copy2(src, dst)
        return True, f"Synced {dst}"
    except Exception as e:
        return False, f"Failed to sync {dst}: {e}"

def display_sync_plan(files: list[Path]) -> None:
    """Display what files will be synced."""
    tree = Tree("📁 Files to sync", style="bold blue")
    
    for file_path in files[:15]:  # Show first 15 files
        src = DOTFILES_DIR / file_path
        dst = HOME_DIR / file_path
        
        if dst.exists():
            if files_are_different(src, dst):
                tree.add(f"🔄 {file_path} [yellow](will update)[/yellow]")
            else:
                tree.add(f"✅ {file_path} [green](already current)[/green]")
        else:
            tree.add(f"➕ {file_path} [cyan](new)[/cyan]")
    
    if len(files) > 15:
        tree.add(f"... and {len(files) - 15} more files")
    
    console.print(Panel(tree, title="Sync preview", border_style="blue"))

@app.command()
def main(
    init: bool = typer.Option(False, "--init", help="Bootstrap mode (non-interactive)"),
    yes: bool = typer.Option(False, "--yes", "-y", help="Skip all prompts"),
    dry_run: bool = typer.Option(False, "--dry-run", help="Show what would be synced without doing it")
) -> None:
    """Sync dotfiles from repository to home directory."""
    
    console.print(Panel.fit("🔄 Dotfiles sync", style="bold magenta"))
    
    # Get all files to sync
    files_to_sync = get_relative_files(DOTFILES_DIR)
    
    if not files_to_sync:
        console.print("[yellow]No files found to sync[/yellow]")
        raise typer.Exit(0)
    
    console.print(f"Found [bold]{len(files_to_sync)}[/bold] files to process")
    
    # Display sync plan
    display_sync_plan(files_to_sync)
    
    if dry_run:
        console.print("[blue]Dry run complete — no files were modified[/blue]")
        raise typer.Exit(0)
    
    # Check for files that would be overwritten
    files_to_overwrite = []
    if not init and not yes:
        for file_path in files_to_sync:
            src = DOTFILES_DIR / file_path
            dst = HOME_DIR / file_path
            if dst.exists() and files_are_different(src, dst):
                files_to_overwrite.append(file_path)
    
    # Warn about overwrites and confirm
    if files_to_overwrite and not init and not yes:
        console.print(f"\n[yellow]Warning:[/yellow] {len(files_to_overwrite)} files will be overwritten:")
        for file_path in files_to_overwrite[:5]:  # Show first 5
            console.print(f"  • {file_path}")
        if len(files_to_overwrite) > 5:
            console.print(f"  ... and {len(files_to_overwrite) - 5} more")
        
        if not Confirm.ask("\nContinue with sync?", default=False):
            console.print("[yellow]Sync cancelled[/yellow]")
            raise typer.Exit(1)
    elif not init and not yes:
        if not Confirm.ask("Proceed with sync?", default=True):
            console.print("[yellow]Sync cancelled[/yellow]")
            raise typer.Exit(1)
    
    # Perform sync
    success_count = 0
    error_count = 0
    
    for file_path in files_to_sync:
        src = DOTFILES_DIR / file_path
        dst = HOME_DIR / file_path
        
        success, message = sync_file(src, dst)
        
        if success:
            success_count += 1
            console.print(f"✅ {message}", style="green")
        else:
            error_count += 1
            console.print(f"❌ {message}", style="red")
    
    # Summary
    if error_count == 0:
        console.print(Panel(
            f"[green]✅ Sync completed successfully[/green]\n"
            f"Synced {success_count} files",
            title="Success",
            border_style="green"
        ))
    else:
        console.print(Panel(
            f"[yellow]⚠️  Sync completed with errors[/yellow]\n"
            f"Synced: {success_count} files\n"
            f"Errors: {error_count} files",
            title="Warning",
            border_style="yellow"
        ))
        raise typer.Exit(1)

# Entry point
if __name__ == "__main__":
    app()