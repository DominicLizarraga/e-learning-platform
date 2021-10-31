class RenameContextToContentInLessons < ActiveRecord::Migration[6.1]
  def change
    # rename_column :table_name, :old_column, :new_column
    rename_column :lessons, :context, :content
  end
end
