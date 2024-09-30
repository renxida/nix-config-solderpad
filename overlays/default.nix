inputs:
final: prev: {
  chatsh = inputs.chatsh.packages.${prev.system}.default;
  aider = inputs.aider.packages.${prev.system}.default;
}
