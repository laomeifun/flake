# my-nix-config/flake.nix
{
  description = "My NixOS and Home Manager configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # 或者一个稳定分支如 "nixos-23.11"

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # (可选) 如果你需要其他 Flake 作为输入
    # another-flake.url = "github:some/flake";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      # --- 通用设置 ---
      username = "zero"; # 你在 `home-manager switch --flake .#zero` 中使用的名字
      system = "x86_64-linux"; # 例如 "x86_64-linux", "aarch64-linux"

      # --- NixOS 特定设置 ---
      nixosHostname = "my-nixos-machine";

      # 创建一个 pkgs 实例，方便在各处使用
      # 注意: 在 NixOS 模块和 Home Manager 模块内部，通常会通过函数参数接收 pkgs
      # 但在这里定义一个顶层的 pkgs 实例有时也方便
      pkgs = nixpkgs.legacyPackages.${system};

    in
    {
      # --- NixOS 系统配置 ---
      nixosConfigurations."${nixosHostname}" = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs username; # 将 inputs 和 username 传递给 NixOS 模块
          # 你也可以在这里传递 home-manager 本身，如果模块需要
          # home-manager = home-manager;
        };
        modules = [
          # 导入你的主 NixOS 配置文件
          ./system/${nixosHostname}/configuration.nix

          # 添加 Home Manager 的 NixOS 模块
          home-manager.nixosModules.home-manager
          {
            # 在这里配置 Home Manager 如何管理用户
            home-manager.useGlobalPkgs = true;   # 推荐，让 Home Manager 使用系统级的 Nixpkgs
            home-manager.useUserPackages = true; # 允许用户在 Home Manager 中定义自己的包

            # 传递额外的参数给你的 home.nix 文件 (如果需要)
            home-manager.extraSpecialArgs = { inherit inputs username; };

            # 导入特定用户的 Home Manager 配置
            # 这会将 ./home/${username}/home.nix 的配置应用给 NixOS 系统中的 "zero" 用户
            home-manager.users.${username} = import ./home/${username}/home.nix;

            # (或者，如果你的 home.nix 需要 pkgs 作为参数)
            # home-manager.users.${username} = { pkgs, ... }: import ./home/${username}/home.nix { inherit pkgs inputs username; };
          }
        ];
      };

      # --- (可选) 独立的 Home Manager 配置 ---
      # 你仍然可以保留这个，如果你想在非 NixOS 系统上使用同样的 home.nix，
      # 或者在 NixOS 上也想用 `home-manager switch` 命令独立管理 (不常见)
      homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs; # 使用上面定义的 pkgs
        modules = [ ./home/${username}/home.nix ]; # 确保这个路径是正确的
        extraSpecialArgs = { inherit inputs username; };
      };
    };
}
