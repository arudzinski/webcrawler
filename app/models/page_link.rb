# Klasa reprezentując połączenie pomiędzy stronami (link/hiperłąłcze/krawędz grafu)

class PageLink < ActiveRecord::Base
  belongs_to :source_page, :class_name => "Page", :foreign_key => "source_page_id" #zwraca strone zrodlowa
  belongs_to :target_page, :class_name => "Page", :foreign_key => "target_page_id" #zwraca strone zrodlowa
  attr_accessible :source_page_id, :target_page_id
end
