# my-nix-config/flake.nix
{
  description = "A simple Nix Flake for Home Manager";

  inputs = {
    # Nixpkgs (Nix Packages collection)
    # 你可以选择一个稳定分支 (如 nixos-23.11) 或不稳定分支 (nixos-unstable)
    # 为了获取最新的软件包，这里使用 nixos-unstable
    # 截至 2025-05-12，一个较新的 nixpkgs commit 可能是：
    # nixpkgs.url = "github:NixOS/nixpkgs/e787f89ff35ac2b2a00cd993411169b3fc9d0161";
    # 或者，直接使用分支名，让 Nix 自动选择最新 commit:
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      # 确保 Home Manager 使用与你上面选择的 nixpkgs 相同的 nixpkgs 实例
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      # 为你的用户和系统定义变量
      # !!! 请务必将 "myuser" 替换为你的实际用户名 !!!
      username = "zero";
      # !!! 请根据你的系统架构进行调整 !!!
      # 常见的有: "x86_64-linux", "aarch64-linux", "x86_64-darwin", "aarch64-darwin"
      system = "x86_64-linux";

      # 创建一个 pkgs 实例，方便在 home.nix 中使用
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      # 定义 Home Manager 配置
      # 输出的名称 (这里的 "myuser") 将在 home-manager switch 命令中使用
      homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs; # 将 pkgs 传递给 Home Manager 模块

        # 指定 Home Manager 的主配置文件路径
        # 指向我们上面目录结构中的 home.nix
        modules = [
          ./home.nix
        ];

        # (可选) 你可以传递一些额外的参数给你的 home.nix 模块
        # extraSpecialArgs = { inherit inputs username; };
      };
    };
}