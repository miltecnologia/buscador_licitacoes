require 'licitacao_util'
require 'and_builder'
require 'or_builder'
require 'date'

class LicitacaosController < ApplicationController

    # GET /atualiza/tudo
    def atualizar_tudo
        licitacaos_tcm = LicitacaoUtil.obter_ano_atual_de_janeiro_a_dezembro
        licitacaos_banco = Licitacao.select('id, link, data_abertura')
        
        licitacaos_tcm.each do |l_tcm|         
            l_banco = nil
            for l_banco_aux in licitacaos_banco
                if l_banco_aux.link == l_tcm[:link]
                    l_banco = l_banco_aux
                    break
                end            
            end
            if l_banco 
                if l_banco.data_abertura != l_tcm[:data_abertura]
                    licitacao = Licitacao.find(l_banco.id)
                    licitacao.data_abertura = l_tcm[:data_abertura]
                    licitacao.exibir = true
                    licitacao.save     
                end
            elsif
                Licitacao.create l_tcm
            end
        end
        redirect_to :root
    end

    # GET /atualiza/parcial
    def atualizar_parcial
        licitacaos_tcm = LicitacaoUtil.obter_ano_atual_de_mes_corrente_a_dezembro
        licitacaos_banco = Licitacao.select('id, link, data_abertura')
        
        licitacaos_tcm.each do |l_tcm|         
            l_banco = nil
            for l_banco_aux in licitacaos_banco
                if l_banco_aux.link == l_tcm[:link]
                    l_banco = l_banco_aux
                    break
                end            
            end
            if l_banco 
                if l_banco.data_abertura != l_tcm[:data_abertura]
                    licitacao = Licitacao.find(l_banco.id)
                    licitacao.data_abertura = l_tcm[:data_abertura]
                    licitacao.exibir = true
                    licitacao.save     
                end
            elsif
                Licitacao.create l_tcm
            end
        end
        redirect_to :root
    end

    # GET /pesquisa
    def pesquisar
        condicoes_and = ANDBuilder.new
        condicoes_and.append 'exibir = true'

        prepara_datas condicoes_and
        prepara_keywords condicoes_and
        prepara_municipio condicoes_and

        session[:acao] ||= 'pesquisa'
        session[:licitacaos_where] = condicoes_and.query
        session[:filtro] = params[:filtro]
        redirect_to :root
    end
    # GET /xls
    def xls
        session[:acao] = 'xls'
        pesquisar
    end
    # GET /pdf
    def pdf
        session[:acao] = 'pdf'
        pesquisar
    end
    def nao_exibe_objetos 
        objetos_ids =  params[:objetos_ids].split ','

        Licitacao.update( objetos_ids, [{:exibir => false}] * objetos_ids.length )
        session[:acao] ||= 'pesquisa'
        redirect_to :root
    end
private
    def prepara_datas condicoes_and
        data_abertura_inicial = nil
        if params[:data_abertura_inicial] 
            params[:data_abertura_inicial].delete! ' '
            data_abertura_inicial = DateTime.parse(params[:data_abertura_inicial]).strftime('%Y-%m-%d') if !params[:data_abertura_inicial].empty?
        end

        data_abertura_final = nil
        if params[:data_abertura_final] 
            params[:data_abertura_final].delete! ' '
            data_abertura_final = DateTime.parse(params[:data_abertura_final]).strftime('%Y-%m-%d') if !params[:data_abertura_final].empty?
        end
                
        if data_abertura_inicial and data_abertura_final
            condicoes_and.append "data_abertura BETWEEN '#{ data_abertura_inicial }' AND '#{data_abertura_final}'" 
            session[:data_abertura_inicial] = params[:data_abertura_inicial]
            session[:data_abertura_final] = params[:data_abertura_final]
        else
            session[:data_abertura_inicial] = nil
            session[:data_abertura_final] = nil
        end    
    end
    def prepara_keywords condicoes_and
        condicoes_or = ORBuilder.new
        params[:filtro][:keywords].split(',').each{|k| condicoes_or.append "objeto ILIKE '%#{k.strip}%'" } if params[:filtro][:keywords]
        condicoes_and.append condicoes_or.query if condicoes_or.valid?
        session[:keywords] = params[:filtro][:keywords]
    end
    def prepara_municipio condicoes_and
        if params[:municipio]
            municipio = params[:municipio].strip
            condicoes_and.append "municipio ILIKE '%#{municipio}%'" if !municipio.empty?
            session[:municipio] = params[:municipio]
        end
    end
end
