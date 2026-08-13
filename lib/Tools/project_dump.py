from pathlib import Path

PROJECT_ROOT = Path(".")
OUTPUT_FILE = "project_dump.txt"

EXCLUDE_DIRS = {
    ".git",
    "node_modules",
    ".vscode",
    "bin",
    "obj",
    "__pycache__",
    ".venv",
    "venv",
    "dist",
    "build"
}

EXCLUDE_EXTENSIONS = {
    ".png", ".jpg", ".jpeg", ".gif", ".bmp",
    ".pdf", ".zip", ".dll", ".exe", ".so",
    ".pyc", ".class"
}

with open(OUTPUT_FILE, "w", encoding="utf-8") as output:
    for file in PROJECT_ROOT.rglob("*"):
        if not file.is_file():
            continue

        if any(part in EXCLUDE_DIRS for part in file.parts):
            continue

        if file.suffix.lower() in EXCLUDE_EXTENSIONS:
            continue

        try:
            content = file.read_text(encoding="utf-8")
        except Exception:
            continue

        output.write("\n")
        output.write("=" * 80 + "\n")
        output.write(f"FILE: {file}\n")
        output.write("=" * 80 + "\n\n")
        output.write(content)
        output.write("\n\n")

print(f"Project dumped to {OUTPUT_FILE}")