module ReleasesHelper

  def find_upstream_release releases, environment
    release = releases[environment]
    previous_environment = release.environment.previous
    if previous_environment.present?
      releases[previous_environment.name]
    else
      nil
    end
  end

  def format_time t, date_only=true
    fmt = date_only ? '%Y.%m.%d' : '%Y.%m.%d %I:%M%p'
    t.localtime.strftime(fmt).downcase
  end
  
  def render_release_date releases, environment
    release = releases[environment]
    if release.nil?
      ''
    else
      text = format_time(release.released_at)
      if release.link.present?
        link_to text, release.link, :target => release.project.name
      else
        content_tag(:span) { text }
      end
    end
  end
  
  def render_release_version releases, environment
    release = releases[environment]
    if release.nil?
      '—'
    else
      previous = find_upstream_release(releases, environment)
      color = 'white'
      unless previous.nil?
        cv = release.version.split(/\./)
        nv = previous.version.split(/\./)
        diff = nil
        cv.each_with_index { |v,i| if v < nv[i]; diff = i; break; end }
      
        case diff
        when 0 then color = 'red'
        when 1 then color = 'blue'
        else        color = 'white'
        end
      end
      link_to content_tag(:span, {:class => "#{color} radius label"}) { release.version }, release_path(release)
    end
  end
  
end
