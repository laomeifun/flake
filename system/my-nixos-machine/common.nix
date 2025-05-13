{ config, pkgs, lib, ... }:
{
  # 基本 Nix 设置
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # 时区
  time.timeZone = "Asia/Shanghai";

  # 通用系统用户 zero 的基本定义
  users.users.zero = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # wheel 用于 sudo
    shell = pkgs.zsh; # 设置默认 shell 为 zsh
  };

  # 确保 zsh 作为系统包存在，以便可以被设置为默认 shell
  # Home Manager 仍将管理 zero 用户的具体 zsh 配置
  # programs.zsh.enable = true; # 这会启用系统级的 zsh 配置模块，如果只想安装包，则不需要

  # 通用系统软件包
  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    vim
    zsh # 确保 zsh 包本身被安装
    # 其他通用工具
  ];

  # 通用服务
  services.openssh.enable = true;

  # 统一的 stateVersion
  system.stateVersion = "25.05"; # 或您希望的共同基准版本
}
