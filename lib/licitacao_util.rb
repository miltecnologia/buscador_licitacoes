# encoding: UTF-8
require_relative 'paginas/pagina_util'
require 'open-uri'

class LicitacaoUtil
    class << self
        HOST_TCM = "http://www.tcm.ce.gov.br"
      
        def obter_ano_atual_de_janeiro_a_dezembro
            meses = (1..12)
            ano = Date.today.year
            anos = (ano..ano)
            obter_periodo(meses, anos)
        end

        def obter_ano_atual_de_mes_corrente_a_dezembro
            mes = Date.today.month
            meses = (mes..12)
            ano = Date.today.year
            anos = (ano..ano)    
            obter_periodo(meses, anos)
        end
      
        private

	    def obter_periodo(meses, anos)
            @@licitacoes = []
            anos.each do |ano|
                meses.each do |mes|
                    obter_mes_ano(mes, ano)
                end       
            end
            @@licitacoes
	    end

	    def obter_mes_ano(mes, ano)
		    pagina = 1
		    tbody_cache = nil
		    tbody = carregar_pagina(mes, ano, pagina)
		    while tbody_cache.to_s != tbody.to_s
			    puts "obtidas licitacoes da pagina #{pagina} do periodo #{mes}-#{ano}." if Rails.env.development?
                tbody.css('tr').each do |linha|
                colunas = linha.css('td')
                @@licitacoes << {
		                        exibir: true,
		                        data_abertura: Date.parse(colunas[3].text),
		                        municipio: colunas[1].text,
		                        codigo: colunas[0].css('a')[0].text,
		                        objeto: colunas[2].text,
		                        link: "#{HOST_TCM}#{colunas[0].css('a')[0]['href']}"
		                      }
			    end
			    tbody_cache = tbody
			    pagina += 1
			    tbody = carregar_pagina(mes, ano, pagina)
		    end
     		puts "obtidas #{@@licitacoes.length} licitacoes do periodo #{mes}-#{ano}." if Rails.env.development?
	    end

	    def carregar_pagina(mes, ano, pagina)
	        if Rails.env.development?
                carregar_pagina_para_desenvolvimento_e_teste(mes, ano, pagina)
            else	        
	            carregar_pagina_para_producao(mes, ano, pagina)
	        end
        end
      
        def carregar_pagina_para_desenvolvimento_e_teste(mes, ano, pagina)
            Nokogiri::HTML(pagina_text(mes, ano, pagina)).css('tbody')[0]
        end

        def carregar_pagina_para_producao(mes, ano, pagina)
		    url = "#{HOST_TCM}/licitacoes/index.php/licitacao/abertas/mes/#{mes}/ano/#{ano}/page/#{pagina}"
            Nokogiri::HTML(open(url)).css('tbody')[0]
        end
    end
end
