module ApplicationHelper

  def breadcrumbs *args
    content = (block_given? ? args + yield : args).flatten
    content.last[:current] = true unless content.empty? or content.any? { |c| c[:current] }
    content.unshift({ :content => 'Projects', :href => projects_path})
    if content.length == 1
      content[0][:current] = true
      content << { :content => 'Register New Project', :href => new_project_path }
    end
    
    render :layout => 'breadcrumbs' do
      content.collect { |crumb|
        attrs = crumb[:current] ? { :class => 'current' } : {}
        content_tag :li, attrs do
          crumb[:href].present? ? link_to(crumb[:content], crumb[:href]) : crumb[:content]
        end
      }.join('').html_safe
    end
  end
  
  def content_tag_present *args, &block
    content = block_given? ? yield : args[1]
    if content.present?
      content_tag *args, &block
    end
  end
  
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
