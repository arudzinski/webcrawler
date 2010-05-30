class <%= class_name %>Controller < ApplicationController

  before_filter :get_<%= object_plural_name %>, :only => [:index]
  before_filter :get_<%= object_singular_name %>, :except => [:index, :create, :new]

  <% if actions.include?("index") %>
    def index
      respond_to do |format|
        format.html
      end
    end

  <% end -%>
  <% if actions.include?("show") %>
    def show
      respond_to do |format|
        format.html
      end
    end

  <% end -%>
  <% if actions.include?("new") %>
    def new
      @<%= object_singular_name %> = <%= model_name %>.new()
    end

  <% end -%>
  <% if actions.include?("create") || actions.include?("new") %>
    def create
      @<%= object_singular_name %> = <%= model_name %>.new(params[:<%= object_singular_name %>])

      if @<%= object_singular_name %>.save
      flash[:notice] = "<%= object_singular_name.humanize %> has been created succesfully"
      end

      respond_to do |format|
        format.html {redirect_to <%= namespace_prefix %><%= object_plural_name %>_path}
      end
    end

  <% end -%>
  <% if actions.include?("edit") %>
    def edit
      respond_to do |format|
        format.html
      end
    end

  <% end -%>

  <% if actions.include?("update") || actions.include?("edit") %>
    def update
      if @<%= object_singular_name %>.update_attributes(params[:<%= object_singular_name %>])
      flash[:notice] = "<%= object_singular_name.humanize %> has been updated succesfully"
      end

      respond_to do |format|
        format.html {redirect_to <%= namespace_prefix %><%= object_plural_name %>_path}
      end
    end

  <% end -%>
  <% if actions.include?("destroy") %>
    def destroy
      @<%= object_singular_name %>.destroy
      respond_to do |format|
        format.html {redirect_to <%= namespace_prefix %><%= object_plural_name %>_path}
      end
    end
  <% end -%>

  private

  def get_<%= object_singular_name %>
    @<%= object_singular_name %> = <%= model_name %>.find(params[:id])
  end

  def get_<%= object_plural_name %>
    @<%= object_plural_name %> = <%= model_name %>.paginate :page => params[:page], :per_page => 10
  end
end