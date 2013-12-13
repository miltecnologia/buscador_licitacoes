class Licitacao < ActiveRecord::Base
  attr_accessible :codigo, :data_abertura, :exibir, :link, :municipio, :objeto

  validates_uniqueness_of :link

    def to_xls separador = "|"
        "#{data_abertura.strftime("%d/%m/%Y")}#{separador}#{municipio}#{separador}#{codigo}#{separador}#{objeto}#{separador}#{created_at.strftime("%d/%m/%Y")}#{separador}#{updated_at.strftime("%d/%m/%Y")}#{separador}#{link}"
    end
end
