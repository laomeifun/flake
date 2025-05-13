# my-nix-config/system/my-nixos-machine/configuration.nix
{ config, pkgs, lib, inputs, username, ... }: # 'inputs' 和 'username' 从 specialArgs 传入

{
  imports = [
    # 包含硬件扫描结果 (通常由安装程序生成)
    ./hardware-configuration.nix
  ];

  # --- 基本系统设置 ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "my-nixos-machine"; # 设置你的主机名
  time.timeZone = "America/Los_Angeles";    # 设置你的时区

  # --- 用户账户 ---
  # 'username' 变量从 flake.nix 的 specialArgs 传入
  users.users.${username} = {
    isNormalUser = true;
    description = "Main User";
    extraGroups = [ "networkmanager" "wheel" ]; # "wheel" 组用于 sudo 权限
    shell = pkgs.zsh; # (可选) 设置默认 shell，也可以由 Home Manager 管理
  };

  # --- Nix 配置 ---
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true; # 允许非自由软件包

  # --- 系统级软件包 ---
  environment.systemPackages = with pkgs; [
    vim
    wget
    # 你可以在这里放一些核心的系统工具
  ];

  # --- 服务示例 ---
  services.openssh.enable = true;
  # services.nginx.enable = true;

  # --- 系统状态版本 ---
  # 非常重要，通常设置为你首次安装 NixOS 时的版本
  system.stateVersion = "25.05"; # 或者你安装时使用的版本，如 "24.05"

  # !!! 注意: Home Manager 的用户配置已经通过 flake.nix 集成 !!!
  # 你不需要在这里再次添加 home-manager.users.${username} = ...
  # flake.nix 中的 `home-manager.users.${username} = import ./home/${username}/home.nix;`
  # 已经处理了这个问题。
}
