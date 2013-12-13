# encoding: UTF-8
class PDFGenerator
	class << self
		def gera_pdf( licitacaos, dados_da_pesquisa )
			pdf = Prawn::Document.new
		
			#Cabeçalho
			dados = [ ["Data Abertura", "Município", "Código","Objeto"] ]
		
			dados += licitacaos.map do |licitacao|
			[
				licitacao.data_abertura.strftime("%d/%m/%Y"),
				licitacao.municipio,
				licitacao.codigo,
				licitacao.objeto	
			]
			end

			pdf.text "Consulta Licitações Portal TCM/CE",
				:size => 18

			if dados_da_pesquisa[:keywords].present? then
				pdf.text "Keywords: #{dados_da_pesquisa[:keywords]}",
					:size => 10
			end

			if dados_da_pesquisa[:data_abertura_inicial].present? and dados_da_pesquisa[:data_abertura_final].present? then
				pdf.text "De #{dados_da_pesquisa[:data_abertura_inicial]} a #{dados_da_pesquisa[:data_abertura_final]}",
					:size => 10
			end

			if dados_da_pesquisa[:municipio].present? then
				pdf.text "Município: #{dados_da_pesquisa[:municipio]}",
					:size => 10	
			end

			pdf.font "Helvetica"
			pdf.font_size 8
			pdf.table dados,
				:width => 550, 
				:column_widths => [ 50, 70 , 70 ,  360 ],
				:header => true,
				:row_colors => ["e5e5e5", "fafafa"]
			pdf.render
		end
	end
end
