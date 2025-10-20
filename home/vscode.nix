{ config, pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    extensions = with pkgs.vscode-extensions; [
      ms-python.python
      ms-python.debugpy

      ms-toolsai.jupyter
      ms-toolsai.jupyter-keymap
      ms-toolsai.jupyter-renderers
      ms-toolsai.vscode-jupyter-cell-tags
      ms-toolsai.vscode-jupyter-slideshow

      ms-python.black-formatter
      ms-python.isort
      ms-python.flake8

      ms-python.vscode-pylance

      ms-vscode.makefile-tools
      llvm-vs-code-extensions.vscode-clangd

      vscodevim.vim
    ];

    userSettings = {
      "python.defaultInterpreterPath" = "/etc/profiles/per-user/rasmus/bin/python3";
      "python.terminal.activateEnvironment" = true;
      "python.pythonPath" = "/etc/profiles/per-user/rasmus/bin/python3";

      "python.venvPath" = ".venv";
      "python.terminal.activateEnvInCurrentTerminal" = true;

      "jupyter.askForKernelRestart" = false;
      "jupyter.interactiveWindow.creationMode" = "perFile";
      "jupyter.notebookFileRoot" = "\${workspaceFolder}";

      "python.experiments.enabled" = false;
      "python.experiments.optInto" = [];

      "python.formatting.provider" = "black";
      "[python]" = {
        "editor.formatOnSave" = false;
        "editor.codeActionsOnSave" = {
          "source.organizeImports" = "never";
        };
        "editor.defaultFormatter" = "ms-python.black-formatter";
      };

      "terminal.integrated.env.linux" = {
        "UV_CACHE_DIR" = "\${userHome}/.cache/uv";
      };

      "C_Cpp.autocomplete" = "disabled";
      "C_Cpp.intelliSenseEngine" = "disabled";
      "clangd.enable" = true;
      "makefile.configureOnOpen" = true;
    };
  };
}
