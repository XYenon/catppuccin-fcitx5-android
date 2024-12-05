_default:
  @just --list

build:
  #!/usr/bin/env bash
  set -euo pipefail
  whiskers fcitx5-android.tera
  for flavor in $(whiskers --list-flavors | jq -rc '.[]'); do
    for accent in $(whiskers --list-accents | jq -rc '.[]'); do
      flavor_name=$(echo "$flavor" | jq -r '.name')
      flavor_identifier=$(echo "$flavor" | jq -r '.identifier')
      accent_name=$(echo "$accent" | jq -r '.name')
      accent_identifier=$(echo "$accent" | jq -r '.identifier')
      pushd "themes/${flavor_name}/${accent_name}" > /dev/null
      theme_name="catppuccin-${flavor_identifier}-${accent_identifier}"
      zip "${theme_name}.zip" "${theme_name}.json"
      rm "${theme_name}.json"
      popd > /dev/null
    done
  done

generate-preview:
  bundle exec ruby preview.rb $(fd --extension zip '' themes)
  cp 'themes/Latte/Blue/catppuccin-latte-blue.webp' 'assets/catppuccin-latte-blue.webp'
  cp 'themes/Frappé/Blue/catppuccin-frappe-blue.webp' 'assets/catppuccin-frappe-blue.webp'
  cp 'themes/Macchiato/Blue/catppuccin-macchiato-blue.webp' 'assets/catppuccin-macchiato-blue.webp'
  cp 'themes/Mocha/Blue/catppuccin-mocha-blue.webp' 'assets/catppuccin-mocha-blue.webp'
  catwalk --directory 'assets' \
    'catppuccin-latte-blue.webp' \
    'catppuccin-frappe-blue.webp' \
    'catppuccin-macchiato-blue.webp' \
    'catppuccin-mocha-blue.webp'
