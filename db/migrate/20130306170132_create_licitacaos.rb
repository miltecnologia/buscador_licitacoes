class CreateLicitacaos < ActiveRecord::Migration
  def change
    create_table :licitacaos do |t|
      t.string :codigo
      t.string :municipio
      t.text :objeto
      t.date :data_abertura
      t.string :link
      t.boolean :exibir

      t.timestamps
    end
  end
end
