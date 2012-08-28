# encoding: utf-8
module ProjectsHelper

  def find_upstream_release releases, environment
    release = releases[environment]
    unless release.nil?
      previous_environment = release.environment.previous
      unless previous_environment.nil?
        return releases[previous_environment.name]
      end
    end
    return nil
  end
  
  def release_info releases, env
    release = releases[env]
    if release.nil?
      '—'
    else
      "#{releases[env].version_label(find_upstream_release(releases, env))} #{releases[env].released_at}".html_safe
    end
  end
  
  def render_releases_for project, environment
    releases = project.releases.select { |r| r.environment == environment }.sort { |a,b| a.model.released_at <=> b.model.released_at }.reverse
    render :partial => 'release_table', :locals => { :project => project, :environment => environment, :releases => releases }
  end
    
end
