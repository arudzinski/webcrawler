module Lbuilder
  module LayoutEngine
    @subtab = nil

    def self.included(base)
      base.extend(ClassMethods)
    end


    def tab
      self.class.get_tab
    end

    def sub_tab
      @subtab || action_name
    end

    def set_subtab(tab)
      @subtab=tab
    end

    module ClassMethods
      @tab = nil

      def set_tab(tab)
        @tab = tab
      end

      def get_tab
        @tab || @tab = controller_name
      end
    end
  end
end