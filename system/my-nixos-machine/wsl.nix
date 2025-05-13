# my-nix-config/system/my-nixos-machine/wsl.nix (WSL 配置)
{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    ./common.nix         # 导入通用配置
    <nixos-wsl/modules>  # 导入 NixOS-WSL 模块
  ];

  networking.hostName = "nixos-wsl"; # WSL 特定的主机名

  wsl.enable = true;
  wsl.defaultUser = "zero"; # WSL 默认用户为 zero

  # WSL 特定的系统级 Zsh 设置
  # 如果 Home Manager 为 zero 用户管理 Zsh，这里的配置主要是为系统提供 zsh 包
  # 或者为其他潜在的 WSL 用户提供一个基础 Zsh 环境。
  # 对于 zero 用户，Home Manager 的配置会优先。
  programs.zsh.enable = true; # 确保 zsh 模块被启用，以便 pkgs.zsh 可用

  # WSL 特定的软件包
  programs.nix-ld.enable = true;
  programs.nix-ld.package = pkgs.nix-ld-rs;

  # WSL 可能需要覆盖 common.nix 中的某些 systemPackages 或添加额外的
  # environment.systemPackages = with pkgs; (config.environment.systemPackages ++ [
  #   # WSL 特有的额外包
  # ]);

  # WSL 特定的 stateVersion (如果不同于 common.nix)
  # system.stateVersion = "24.11"; # 例如，如果 WSL 环境基于不同版本初始化
}
