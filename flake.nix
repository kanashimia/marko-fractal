{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = inputs: let
    lib = inputs.nixpkgs.lib;

    ctx = system: rec {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    };

    mapCtx = attrs: lib.genAttrs lib.systems.flakeExposed (system:
      lib.mapAttrs (_: v: v (ctx system)) attrs
    );
  in {
    devShells = mapCtx {
      default = { pkgs, ... }: pkgs.mkShell {
        packages = with pkgs; [
          bun
          deno
        ] ++ builtins.attrValues {
          inherit (nodejs_latest.pkgs)
            nodejs
            typescript
            typescript-language-server
            vscode-langservers-extracted
            prettier
            pnpm
            eslint
          ;
        };

        shellHook = ''
          export PATH="/home/kanashimia/.cache/.bun/bin:$PATH"
        '';
      };
    };
  };
}
