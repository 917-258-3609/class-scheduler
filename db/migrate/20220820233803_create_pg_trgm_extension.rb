class CreatePgTrgmExtension < ActiveRecord::Migration[7.0]
  enable_extension 'pg_trgm' unless extension_enabled?('pg_trgm')
end
