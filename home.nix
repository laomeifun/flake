# my-nix-config/home/zero/home.nix
{ config, pkgs, lib, ... }: # Home Manager 会自动传递这些参数

let
  # 你也可以在这里定义一些变量，如果需要的话
  # username = "zero"; # 如果 flake.nix 没有通过 extraSpecialArgs 传递
in
{
  # 1. 基本的 Home Manager 设置
  # !!! 再次确认这里的用户名和家目录路径与你的实际情况相符 !!!
  home.username = "zero";
  home.homeDirectory = "/home/zero"; # Linux 示例
  # 对于 macOS, 通常是: home.homeDirectory = "/Users/zero";

  # 2. 设置状态版本 (非常重要!)
  # 这有助于 Home Manager 处理向后不兼容的更改。
  # 对于新配置，通常设置为你当前使用的 Nixpkgs 的版本。
  # 例如，如果你使用的是 nixpkgs 23.11 分支, 就用 "23.11".
  # 如果是 nixos-unstable，可以用 "24.05" (预期的下一个版本号) 或保持与 nixpkgs 分支一致的习惯。
  # 查看: https://nix-community.github.io/home-manager/options.html#opt-home.stateVersion
  home.stateVersion = "25.05"; # 假设你正在使用较新的 nixpkgs

  # 3. 安装你希望在用户环境中可用的软件包
  home.packages = [
    pkgs.cowsay  # 一个有趣的包，用于测试
    pkgs.htop    # 交互式进程查看器
    pkgs.ripgrep # 快速的代码搜索工具
    pkgs.git     # 版本控制系统
    pkgs.vim     # 文本编辑器
    pkgs.home-manager # Home Manager 本身

  ];



  # 5. (可选) 配置特定的程序
  programs.git = {
    enable = true;
    userName = "zero"; # !!! 替换为你的名字 !!!
    userEmail = "zero@laomei.site"; # !!! 替换为你的邮箱 !!!
    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "vim"; # 或者你喜欢的编辑器，如 "nano", "code"
    };
  };

  # 6. (可选) 设置环境变量
  home.sessionVariables = {
    EDITOR = "vim";
    
  };
}
