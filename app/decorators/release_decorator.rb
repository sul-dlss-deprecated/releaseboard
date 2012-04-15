class ReleaseDecorator < ApplicationDecorator
  include Draper::LazyHelpers

  decorates :release
  decorates_association :project

  def version_label previous
    colors = ['red','blue','green','white']
    color = colors.last
    unless previous.nil?
      index = model.diff(previous.version)
      color = colors[index] unless index.nil?
    end
    
    link content_tag(:span, {:class => "#{color} radius label"}) { model.version }
  end

  def short_note
    notes = model.release_notes
    if notes.present?
      result = notes.lines.first.chomp.truncate(100)
      if notes.lines.to_a.length > 1 and result !~ /\.\.\.$/
        result += "..."
      end
      result
    end
  end
  
  def released_at(opts={})
    opts.reverse_merge!({ :date_only => false, :link => true, :words => false })
    fmt = opts[:date_only] ? '%Y.%m.%d' : '%Y.%m.%d %I:%M%p'
    str = model.released_at.localtime.strftime(fmt).downcase
    str = link(str) if opts[:link]
    case opts[:words]
    when false, nil then str
    when :first then "#{time_ago_in_words(model.released_at)} ago (#{str})".html_safe
    else "#{str} (#{time_ago_in_words(model.released_at)} ago)".html_safe
    end
  end
  
  def breadcrumb(current=false)
    { :content => "#{model.version}-#{model.environment.name}", :href => project_release_path(model) }
  end
  
  private
  def link(content)
    link_to(content, project_release_path(model.project.name, model))
  end
  
end