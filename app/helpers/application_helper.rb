# encoding: utf-8
module ApplicationHelper
	def pagination_links(collection, options = {})
		options[:renderer] ||= BootstrapPaginationHelper::LinkRenderer
		options[:class] ||= 'pagination pagination-centered pagination-large'
		options[:inner_window] ||= 2
		options[:outer_window] ||= 1
		options[:previous_label] ||= 'Anterior'
		options[:next_label] ||= 'Próxima'
		will_paginate(collection, options)
	end
end
