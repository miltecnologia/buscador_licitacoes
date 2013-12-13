class CreateFiltros < ActiveRecord::Migration
  def change
    create_table :filtros do |t|
      t.text :descricao
      t.text :keywords

      t.timestamps
    end
  end
end
