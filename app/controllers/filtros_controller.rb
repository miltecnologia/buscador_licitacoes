class FiltrosController < ApplicationController
	def salvar
		filtro = Filtro.new(params[:filtro])
		filtro.save

		session[:acao] = 'filtro_salvo'
		session[:filtro] = params[:filtro]

		redirect_to  :root
	end
end
