# Shared Database

This recipe symlinks the `database.yml` from one application to another in a
multiple-application environment.

## Usage

Modify the `app` and `parent_app` variables in the default recipe then require
it in the `cookbooks/main/recipes/default.rb`.

    require_recipe "shared_db"
