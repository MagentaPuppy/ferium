default: install-dev
set windows-powershell := true

# Build for macOS Intel and macOS Apple Silicon
build-mac:
	rm -f out/ferium-macos-x64.zip out/ferium-macos-arm.zip
	mkdir -p out
	cargo build --target=x86_64-apple-darwin --release
	cargo build --target=aarch64-apple-darwin --release
	zip -r out/ferium-macos-x64.zip -j target/x86_64-apple-darwin/release/ferium
	zip -r out/ferium-macos-arm.zip -j target/aarch64-apple-darwin/release/ferium

# Build for Windows MSVC
build-win:
	if (Test-Path -Path ".\out\ferium-windows-msvc.zip") { Remove-Item -Path ".\out\ferium-windows-msvc.zip" }
	if (-Not (Test-Path -Path ".\out")) { New-Item -Name "out" -ItemType Directory }
	cargo build --target=x86_64-pc-windows-msvc --release
	Compress-Archive -Path "target\x86_64-pc-windows-msvc\release\ferium.exe" -DestinationPath "out\ferium-windows-msvc.zip"

# Build for GNU Linux and GNU Windows (e.g. cygwin)
build-linux:
	rm -f out/ferium-linux-gnu.zip out/ferium-windows-gnu.zip
	mkdir -p out
	cargo build --target=x86_64-pc-windows-gnu --release
	cargo build --target=x86_64-unknown-linux-gnu --release
	zip -r out/ferium-linux-gnu.zip -j target/x86_64-unknown-linux-gnu/release/ferium
	zip -r out/ferium-windows-gnu.zip -j target/x86_64-pc-windows-gnu/release/ferium.exe

# Run clippy lints
lint:
	cargo clippy -- \
		-D clippy::all \
		-D clippy::perf \
		-D clippy::style \
		-D clippy::cargo \
		-D clippy::suspicious \
		-D clippy::complexity \
		-W clippy::nursery \
		-W clippy::pedantic \
		-A clippy::too-many-lines \
		-A clippy::non-ascii-literal \
		-A clippy::single-match-else \
		-A clippy::let-underscore-drop \
		-A clippy::multiple-crate-versions

# Install Ferium to cargo's binary folder
install:
	cargo install --force --path .

# Install Ferium to cargo's binary folder but debug
install-dev:
	cargo install --debug --force --path .

clean:
	cargo clean
	rm -rf out
	rm -rf tests/mods
	rm -rf tests/configs/running
