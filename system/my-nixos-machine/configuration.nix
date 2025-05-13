# my-nix-config/system/my-nixos-machine/configuration.nix (普通 PC 配置)
{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    ./common.nix                 # 导入通用配置
    ./hardware-configuration.nix # PC 需要硬件配置
  ];

  networking.hostName = "nixos-pc"; # PC 特定的主机名

  # PC 特定的引导加载程序设置
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # PC 特定的系统级 Zsh 设置 (如果需要，且不同于 common 或 Home Manager)
  # programs.zsh = {
  #   # ... PC specific zsh system settings ...
  # };

  # PC 特定的软件包 (如果 common 中没有，或者需要覆盖)
  # environment.systemPackages = with pkgs; [
  #   # steam # 例如
  # ];

  # PC 特定的服务
  # services.xserver.enable = true; # 例如图形界面和显示管理器
  # services.displayManager.sddm.enable = true;
  # services.desktopManager.plasma5.enable = true;

  # PC 特定的 stateVersion (如果不同于 common.nix)
  # system.stateVersion = "25.05"; # 确保与首次安装或期望版本一致
}
