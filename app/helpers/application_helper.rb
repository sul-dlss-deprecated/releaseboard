module ApplicationHelper

  def render_field form, field, content=nil
    error = form.object.errors.messages[field]
    value = error.present? ? (form.object.send(field).present? ? " '#{form.object.send(field)}' " : ' ') : ''
    
    div_class = error.present? ? 'form-field error' : 'form-field'
    content_tag :div, :class => div_class do
      yield("#{value}#{error}")
    end
  end
  
  def render_text_area form, field, label, opts={}
    render_field form, field do |error|
      form.label(field, "#{label} #{error}") +
      form.text_area(field, opts.merge(:class => 'large oversize input-text'))
    end
  end
  
  def render_text_field form, field, label, opts={}
    render_field form, field do |error|
      form.label(field, "#{label} #{error}") +
      form.text_field(field, opts.merge(:class => 'large oversize input-text'))
    end
  end
  
end
