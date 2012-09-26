require 'redmine'

callbacks = if Redmine::VERSION::MAJOR < 2
  require 'dispatcher'
  Dispatcher
else
  ActionDispatch::Callbacks
end

callbacks.to_prepare do
  require_dependency 'user'
  require_dependency 'role'
  require_dependency 'issue'
  require_dependency 'attachment'
  require_dependency 'redmine/access_control'
  unless User.included_modules.include? RedmineNonMemberWatcher::UserPatch
    User.send :include, RedmineNonMemberWatcher::UserPatch
  end
  unless Role.included_modules.include? RedmineNonMemberWatcher::RolePatch
    Role.send :include, RedmineNonMemberWatcher::RolePatch
  end
  unless Issue.included_modules.include? RedmineNonMemberWatcher::IssuePatch
    Issue.send :include, RedmineNonMemberWatcher::IssuePatch
  end
  unless Attachment.included_modules.include? RedmineNonMemberWatcher::AttachmentPatch
    Attachment.send :include, RedmineNonMemberWatcher::AttachmentPatch
  end
  unless Redmine::AccessControl.included_modules.include? RedmineNonMemberWatcher::AccessControlPatch
    Redmine::AccessControl.send :include, RedmineNonMemberWatcher::AccessControlPatch
  end
  # if redmine default data loaded then try load default data for this plugin
  begin
    unless Redmine::DefaultData::Loader.no_data?
      if RedmineNonMemberWatcher::DefaultData::Loader.no_data?
        RedmineNonMemberWatcher::DefaultData::Loader.load
      end
    end
  rescue
    # possible there is no tables yet
  end
end

Redmine::Plugin.register :redmine_non_member_watcher do
  name 'Redmine Non Member Watcher plugin'
  author 'danil.tashkinov@gmail.com'
  description 'Redmine plugin that adds new system role "Non member watcher"'
  version '0.0.5'
  url 'https://github.com/Undev/redmine_non_member_watcher'
  author_url 'https://github.com/Undev'
  requires_redmine :version_or_higher => '1.4.0'

  project_module :issue_tracking do |map|
    map.permission :receive_email_notifications, {}, :require => :member_non_watcher
    map.permission :view_watched_issues, { :issues => [:show] }, :require => :member_non_watcher
  end
end
