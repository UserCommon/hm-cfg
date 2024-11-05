{config, pkgs, ...}: {
  imports = [
    ./vim.nix
  ];

  home.packages = with pkgs; [
    # editors
    helix
    vscode

    # compilers
    llvm
    clang
    rustup
    python3
    opam
    ocaml
    nodejs
    yarn

    # tools
    clang-tools
    ocamlPackages.lsp
    lldb
  ];
}
