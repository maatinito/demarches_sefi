# frozen_string_literal: true

class AddIndexToAttributes < ActiveRecord::Migration[6.0]
  def change
    add_index :attributes, :variable
  end
end
