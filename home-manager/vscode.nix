{ pkgs }:

pkgs.vscode-with-extensions.override {
  vscodeExtensions = with pkgs.vscode-extensions; [
    ms-python.python
    ms-vscode.cpptools
    rust-lang.rust-analyzer
    github.copilot
  ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "remote-server";
      publisher = "ms-vscode";
      version = "1.5.6";
      sha256 = "0llrl0s9fll17sc1fxx5ndk5l9x25k4ln1gahpc7ljwhykyzg9hs"; # Replace with actual sha256
    }
  ];
}