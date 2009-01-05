migration 1, :add_twitter_account_to_comments  do
  up do
    modify_table :comments do
      add_column :twitter_name, String
    end
  end

  down do
    modify_table :comments do
      drop_columns :twitter_name
    end
  end
end
