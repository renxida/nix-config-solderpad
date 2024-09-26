{ pkgs }:

pkgs.vscode-with-extensions.override {
  vscodeExtensions = with pkgs.vscode-extensions; [
    ms-python.python
    #ms-vscode.cpptools
    rust-lang.rust-analyzer
    github.copilot
  ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "copilot-chat";
      publisher = "GitHub";
      version = "0.21.2024092601";
      sha256 = "0rqznhp06f80swvcp6q2g1br96ld03jd3a4fyz364sjjhnxv69fg";
    }

    #{
    #  name = "remote-server";
    #  publisher = "ms-vscode";
    #  version = "1.5.6";
    #  sha256 = "0llrl0s9fll17sc1fxx5ndk5l9x25k4ln1gahpc7ljwhykyzg9hs"; # Replace with actual sha256
    #}
  ];
}
