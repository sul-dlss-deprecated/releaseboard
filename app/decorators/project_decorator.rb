class ProjectDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  
  decorates :project
  decorates_association :releases
  
  def latest_releases
    ReleaseDecorator.decorate(model.latest_releases).to_ary.also_index_by(:environment_name)
  end
  
  def maintainer
    display = model.email.present? ? link_to(model.maintainer, "mailto:#{model.email}") : model.maintainer
    detail(display, 'Maintainer')
  end
  
  def email
    detail(model.email, 'Email')
  end
  
  def source
    detail(model.source, 'Source')
  end
  
  def notification_count
    detail(model.notifications.length.to_s, 'Notifications')
  end
  
  def breadcrumb(current=false, action=:show)
    if action == :edit
      { :content => 'Edit', :href => edit_project_path(model.name), :current => current }
    else
      { :content => model.name, :href => project_path(model.name), :current => current }
    end
  end
  
  private
    def detail value, label
      if value.present?
        content_tag :div, :class => 'row' do
          content_tag(:div, :class => 'one columns') { label } +
          content_tag(:div, :class => 'eleven columns') { value }
        end
      end
    end
end