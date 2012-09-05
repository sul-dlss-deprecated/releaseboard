module ApplicationHelper

  
  def content_tag_present *args, &block
    content = block_given? ? yield : args[1]
    if content.present?
      content_tag *args, &block
    end
  end
  
  def render_field form, field, content=nil
    error = form.object.errors.messages[field]
    value = error.present? ? (form.object.send(field).present? ? " '#{form.object.send(field)}' " : ' ') : ''
    
    div_class = error.present? ? 'control-group error' : 'control-group'
    content_tag :div, :class => div_class do
      yield("#{value}#{error}")
    end
  end
  
  def render_text_area form, field, label, opts={}
    render_field form, field do |error|
      form.label(field, "#{label} #{error}", :class => 'control-label') +
      content_tag(:div, form.text_area(field, opts.merge(:class => 'large oversize input-text')), :class=> 'controls')
    end
  end
  
  def render_text_field form, field, label, opts={}
    render_field form, field do |error|
      form.label(field, "#{label} #{error}", :class => 'control-label') +
      content_tag(:div, form.text_field(field, opts.merge(:class => 'large oversize input-text')), :class => 'controls')
    end
  end
  
end
