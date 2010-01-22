module DerbHelper
  def call_tag(tagname, *attrs, &block)
    begin
      content = capture(&block)
      if (tag_proc = DerbCustomTag.all[tagname][:proc])

        #Get attributes for inline render
        options = attrs.extract_options!
        attributes = DerbCustomTag.all[tagname][:attrs].inject({}) do |attribs, attr|
          attribs.merge({attr => options[attr]})
        end.symbolize_keys

        new_content = render(:inline => tag_proc.call(content, attributes), :layout => false, :locals => attributes)
        concat(new_content, block.binding)
      else
        raise DerbTemplateString::TagNotDefined, "Following tag has not been defined -> #{tag}"
      end
    rescue => exc
      #TODO Message breaks.... Damn - I mean it is repeated twice somehow ;)
      puts "Template exception \n ---------------- \n#{exc.message}\n ---------------- \n\n"
      puts %{ Problem occured during tag call! \n
              Tag: #{tagname}\n Attrs: #{attributes}\n
              All tags regex: #{DerbCustomTag.regex} \n
              Custom tag: #{DerbCustomTag.all[tagname]} \n\n
              ============================ \n}
      raise exc
    end
  end


  def derby_defaults(*args)
     args.include?(:fluid) ? stylesheet_link_tag("/rcss/tderby_fluid.css") : stylesheet_link_tag("/rcss/tderby.css")
  end

end