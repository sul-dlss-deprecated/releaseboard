class ReleaseDecorator < Draper::Decorator
  include Draper::LazyHelpers

  decorates :release
  decorates_association :project

  def self.latest *args
    self.decorate(self.model_class.latest *args)
  end

  def version
    model.version
  end
  
  def version_label previous = nil, options = {}
    colors = ['version-major','version-minor','version-patch']

    unless previous.nil?
      index = model.diff(previous, options.fetch(:direction, :forward))
      color = colors[index] unless index.nil?
    end

    color = 'version-current' if project.max_version == model.version

    if options.fetch(:link, 'false')
      link_to(model.version, project_release_path(model.project, model), :class => "label #{color}")
    else
      content_tag :span, model.version, :class => "label #{color}"
    end
  end

  def short_note
    notes = model.release_notes
    notes ||= "from #{self.repository}##{self.branch}" if self.repository or self.branch
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
    when false, nil then model.released_at
    when :first then "#{time_ago_in_words(model.released_at)} ago (#{str})".html_safe
    else "#{str} (#{time_ago_in_words(model.released_at)} ago)".html_safe
    end
  end
  
  private
  def link(content)
    link_to(content, project_release_path(model.project, model))
  end
  
end
