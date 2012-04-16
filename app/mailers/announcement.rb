class Announcement < ActionMailer::Base
  def notify(release, notification)
    @content = notification.body_for(release)
    mail :to => notification.to, :from => notification.from, :subject => notification.subject_for(release)
  end
end
