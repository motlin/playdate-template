project_name := env_var_or_default("PROJECT_NAME", "DEFAULT_TITLE")
source_dir := "source"
output_dir := "builds"
pdx_file := output_dir / project_name + ".pdx"

# 📋 List all recipes (default)
default:
    @just --list --unsorted

# 🔨 Build the Playdate project
build:
    pdc "{{ source_dir }}" "{{ pdx_file }}"

# 🎮 Run the Playdate Simulator
run: build
    open -a "Playdate Simulator" "{{ pdx_file }}"

# 🧹 Clean build artifacts
clean:
    rm -rf "{{ output_dir }}"

# pre-commit run just-fmt --all-files
format:
    pre-commit run just-fmt --all-files
