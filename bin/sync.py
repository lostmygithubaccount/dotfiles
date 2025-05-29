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
import subprocess
from pathlib import Path
from typing import Optional
import typer
from rich.console import Console
from rich.prompt import Confirm
from rich.progress import Progress, SpinnerColumn, TextColumn
from rich.tree import Tree
from rich.panel import Panel

# Neovim Extensions to Clone
NVIM_REPOS = [
    "https://github.com/github/copilot.vim.git",
    "https://github.com/projekt0n/github-nvim-theme.git",
    "https://github.com/ruifm/gitlinker.nvim.git",
    "https://github.com/benlubas/molten-nvim.git",
    "https://github.com/neovim/nvim-lspconfig.git",
    "https://github.com/nvim-tree/nvim-tree.lua.git",
    "https://github.com/jmbuhr/otter.nvim.git",
    "https://github.com/nvim-lua/plenary.nvim.git",
    "https://github.com/quarto-dev/quarto-nvim.git",
    "https://github.com/folke/tokyonight.nvim.git",
    "https://github.com/tpope/vim-fugitive.git",
    "https://github.com/NoahTheDuke/vim-just.git",
    "https://github.com/jpalardy/vim-slime.git",
    "https://github.com/redhat-developer/yaml-language-server.git",
]

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

def get_repo_name(repo_url: str) -> str:
    """Extract repository name from git URL."""
    return repo_url.split('/')[-1].replace('.git', '')

def check_nvim_extensions() -> tuple[list[str], list[str]]:
    """Check which neovim extensions are already installed vs need to be cloned."""
    nvim_pack_dir = HOME_DIR / ".config/nvim/pack/nvim/start"
    existing = []
    to_clone = []
    
    for repo_url in NVIM_REPOS:
        repo_name = get_repo_name(repo_url)
        repo_path = nvim_pack_dir / repo_name
        
        if repo_path.exists() and (repo_path / ".git").exists():
            existing.append(repo_name)
        else:
            to_clone.append(repo_url)
    
    return existing, to_clone

def display_nvim_plan(existing: list[str], to_clone: list[str]) -> None:
    """Display what neovim extensions will be cloned."""
    if not existing and not to_clone:
        return
        
    tree = Tree("🔌 Neovim extensions", style="bold purple")
    
    for repo_name in existing:
        tree.add(f"✅ {repo_name} [green](already installed)[/green]")
    
    for repo_url in to_clone:
        repo_name = get_repo_name(repo_url)
        tree.add(f"📦 {repo_name} [cyan](will clone)[/cyan]")
    
    console.print(Panel(tree, title="Neovim extensions plan", border_style="purple"))

def clone_nvim_extension(repo_url: str, target_dir: Path) -> tuple[bool, str]:
    """Clone a neovim extension repository."""
    repo_name = get_repo_name(repo_url)
    repo_path = target_dir / repo_name
    
    try:
        # Create target directory if it doesn't exist
        target_dir.mkdir(parents=True, exist_ok=True)
        
        # Clone the repository
        result = subprocess.run(
            ["git", "clone", repo_url, str(repo_path)],
            capture_output=True,
            text=True,
            check=True
        )
        return True, f"Cloned {repo_name}"
    except subprocess.CalledProcessError as e:
        return False, f"Failed to clone {repo_name}: {e.stderr.strip()}"
    except Exception as e:
        return False, f"Failed to clone {repo_name}: {e}"

def sync_nvim_extensions(dry_run: bool = False) -> tuple[int, int]:
    """Sync neovim extensions. Returns (success_count, error_count)."""
    nvim_pack_dir = HOME_DIR / ".config/nvim/pack/nvim/start"
    existing, to_clone = check_nvim_extensions()
    
    if not to_clone:
        console.print("[green]All neovim extensions already installed[/green]")
        return 0, 0
    
    if dry_run:
        console.print(f"[blue]Would clone {len(to_clone)} neovim extensions[/blue]")
        return 0, 0
    
    # Copy .gitkeep if it exists in dotfiles
    gitkeep_src = DOTFILES_DIR / ".config/nvim/pack/nvim/start/.gitkeep"
    if gitkeep_src.exists():
        gitkeep_dst = nvim_pack_dir / ".gitkeep"
        nvim_pack_dir.mkdir(parents=True, exist_ok=True)
        shutil.copy2(gitkeep_src, gitkeep_dst)
        console.print(f"✅ Copied .gitkeep to {nvim_pack_dir}", style="green")
    
    success_count = 0
    error_count = 0
    
    for repo_url in to_clone:
        success, message = clone_nvim_extension(repo_url, nvim_pack_dir)
        
        if success:
            success_count += 1
            console.print(f"✅ {message}", style="green")
        else:
            error_count += 1
            console.print(f"❌ {message}", style="red")
    
    return success_count, error_count

@app.command()
def main(
    yes: bool = typer.Option(False, "--yes", "-y", help="Skip all prompts"),
    dry_run: bool = typer.Option(False, "--dry-run", help="Show what would be synced without doing it"),
    skip_copy: bool = typer.Option(False, "--skip-copy", help="Skip copying dotfiles"),
    skip_clone: bool = typer.Option(False, "--skip-clone", help="Skip cloning neovim extensions")
) -> None:
    """Sync dotfiles from repository to home directory."""
    
    console.print(Panel.fit("🔄 Dotfiles sync", style="bold magenta"))
    
    # Check what needs to be done
    nvim_existing, nvim_to_clone = check_nvim_extensions()
    files_to_sync = [] if skip_copy else get_relative_files(DOTFILES_DIR)
    
    # Display plans
    if not skip_copy:
        if not files_to_sync:
            console.print("[yellow]No files found to sync[/yellow]")
        else:
            console.print(f"Found [bold]{len(files_to_sync)}[/bold] files to process")
            display_sync_plan(files_to_sync)
    
    if not skip_clone:
        display_nvim_plan(nvim_existing, nvim_to_clone)
    
    if dry_run:
        if not skip_clone:
            sync_nvim_extensions(dry_run=True)
        console.print("[blue]Dry run complete — no files were modified[/blue]")
        raise typer.Exit(0)
    
    # Exit early if both operations are skipped
    if skip_copy and skip_clone:
        console.print("[yellow]Both copy and clone operations skipped[/yellow]")
        raise typer.Exit(0)
    
    # Check for files that would be overwritten
    files_to_overwrite = []
    if not skip_copy and not yes:
        for file_path in files_to_sync:
            src = DOTFILES_DIR / file_path
            dst = HOME_DIR / file_path
            if dst.exists() and files_are_different(src, dst):
                files_to_overwrite.append(file_path)
    
    # Warn about overwrites and confirm (only for file copy operations)
    if not skip_copy and files_to_overwrite and not yes:
        console.print(f"\n[yellow]Warning:[/yellow] {len(files_to_overwrite)} files will be overwritten:")
        for file_path in files_to_overwrite[:5]:  # Show first 5
            console.print(f"  • {file_path}")
        if len(files_to_overwrite) > 5:
            console.print(f"  ... and {len(files_to_overwrite) - 5} more")
        
        if not Confirm.ask("\nContinue with sync?", default=False):
            console.print("[yellow]Sync cancelled[/yellow]")
            raise typer.Exit(1)
    elif not skip_copy and not yes and files_to_sync:
        if not Confirm.ask("Proceed with sync?", default=True):
            console.print("[yellow]Sync cancelled[/yellow]")
            raise typer.Exit(1)
    
    # Perform sync operations
    total_success_count = 0
    total_error_count = 0
    
    # Sync dotfiles
    if not skip_copy and files_to_sync:
        console.print("\n[bold blue]📁 Syncing dotfiles...[/bold blue]")
        for file_path in files_to_sync:
            src = DOTFILES_DIR / file_path
            dst = HOME_DIR / file_path
            
            success, message = sync_file(src, dst)
            
            if success:
                total_success_count += 1
                console.print(f"✅ {message}", style="green")
            else:
                total_error_count += 1
                console.print(f"❌ {message}", style="red")
    
    # Sync neovim extensions
    if not skip_clone:
        console.print("\n[bold purple]🔌 Syncing neovim extensions...[/bold purple]")
        nvim_success, nvim_errors = sync_nvim_extensions()
        total_success_count += nvim_success
        total_error_count += nvim_errors
    
    # Summary
    if total_error_count == 0:
        console.print(Panel(
            f"[green]✅ Sync completed successfully[/green]\n"
            f"Total operations: {total_success_count}",
            title="Success",
            border_style="green"
        ))
    else:
        console.print(Panel(
            f"[yellow]⚠️  Sync completed with errors[/yellow]\n"
            f"Successful: {total_success_count} operations\n"
            f"Errors: {total_error_count} operations",
            title="Warning",
            border_style="yellow"
        ))
        raise typer.Exit(1)

# Entry point
if __name__ == "__main__":
    app()