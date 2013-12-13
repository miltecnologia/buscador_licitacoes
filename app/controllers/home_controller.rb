# encoding: UTF-8
require "will_paginate"
require "pdf_generator"

class HomeController < ApplicationController
	@@ORDENACAO = 'DATE(updated_at) DESC, data_abertura DESC, municipio'
	def index
		@filtros = Filtro.order(:descricao)
        	if session[:acao]
    	    	@licitacaos = Licitacao.where( session[:licitacaos_where] ).order(@@ORDENACAO)
           		send "gera_#{session[:acao]}"
        	else
           		gera_lista
	end
	end
private
	def gera_xls
	    @filtro = Filtro.new(session[:filtro])
	    session[:acao] = nil
	    session[:licitacaos_where] = nil
	    session[:data_abertura_inicial] = nil
	    session[:data_abertura_final] = nil
	    session[:filtro] = nil
	    session[:municipio] = nil
        separador = "|"
	    xls = "Data de Abertura#{separador}Município#{separador}Código#{separador}Objeto#{separador}Criado#{separador}Atualizado#{separador}Link"
	    @licitacaos.each do |l|
            xls += "\n"
	        xls += l.to_xls(separador).delete("\n").delete("\r")
        end
        send_data xls, filename: "licitacoes.xls"	
	end
	def gera_pdf
		@filtro = Filtro.new(session[:filtro])
		dados_da_pesquisa = {
			:keywords => @filtro.keywords,
			:data_abertura_inicial => session[:data_abertura_inicial],
			:data_abertura_final => session[:data_abertura_final],
			:municipio => session[:municipio]
		}
		session[:acao] = nil
		session[:licitacaos_where] = nil
		session[:data_abertura_inicial] = nil
		session[:data_abertura_final] = nil
		session[:filtro] = nil
		session[:municipio] = nil

		begin
			send_data( PDFGenerator.gera_pdf(@licitacaos, dados_da_pesquisa), :type => :pdf)
		rescue Exception
            		gera_lista		    
		end
	end
    def gera_pesquisa
		if params[:page]
            @page = params[:page].to_i
        elsif
            @page = 1
        end
	    if( @licitacaos.size / 10 < @page - 1 )
	    	@page = @licitacaos.size / 10
			@page += 1 if @licitacaos.size % 10 > 0
            if @page > 0    
        		redirect_to "#{root_path}?page=#{@page}"
            elsif
               @page = 1
            end
	    end
		@licitacaos = @licitacaos.paginate( page: @page,  per_page: 10)
		@filtro = Filtro.new(session[:filtro])
    	@data_abertura_inicial = session[:data_abertura_inicial] or ''
    	@data_abertura_final = session[:data_abertura_final] or ''
    	@municipio = session[:municipio] or ''
    end	
	def gera_lista
		session[:acao] = nil
		session[:licitacaos_where] = nil
		session[:data_abertura_inicial] = nil
		session[:data_abertura_final] = nil
		session[:filtro] = nil
        		session[:municipio] = nil
		@licitacaos = Licitacao.where( exibir: true ).order(@@ORDENACAO).paginate(page: params[:page],per_page: 10)	
  		@filtro = Filtro.new
	end    
	def gera_filtro_salvo
        		gera_lista
	end  
end
