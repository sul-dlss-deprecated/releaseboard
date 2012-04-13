module ProjectsHelper

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
  
  def render_releases_for project, environment
    releases = project.releases.select { |r| r.environment == environment }.sort_by(&:released_at).reverse
    render :partial => 'release_table', :locals => { :project => project, :environment => environment, :releases => releases }
  end

  def render_release_note release
    notes = release.release_notes
    if notes.present?
      result = notes.lines.first.chomp.truncate(100)
      if notes.lines.to_a.length > 1 and result !~ /\.\.\.$/
        result += "..."
      end
      result
    end
  end
  
  def render_release_date releases, environment
    release = releases[environment]
    if release.nil?
      ''
    else
      text = format_time(release.released_at,false)
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
      link_to content_tag(:span, {:class => "#{color} radius label"}) { release.version }, project_release_path(release.project.name, release)
    end
  end

end
