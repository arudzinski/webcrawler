# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def main_menu_link_to(*args, &block)
    options = args.clone.extract_options!
    content_tag(:li, link_to(*args, &block), :class => "main_menu_item #{'highlighted' if tab == (options[:tab] || args.first.downcase)}")
  end
   def table_headers(*arr)
    <<EOF
      <thead>
        <tr>
            <th class="lc"></th>
          #{arr.map{|label| label.include?('<th') ? label : content_tag(:th, label)}}
            <th class="rc"></th>
        </tr>
      </thead>
      <tfoot>
        <tr>
          <td class="lc"></td>
          <td colspan="#{arr.size}"></td>
          <td class="rc"></td>
        </tr>
      </tfoot>
EOF
  end

end
