require File.expand_path('../../test_helper', __FILE__)
require 'issues_controller'

class NonMemberRolesTest < ActionController::IntegrationTest
  fixtures :projects, :users, :members, :member_roles, :roles,
           :groups_users,
           :trackers, :projects_trackers,
           :enabled_modules,
           :versions,
           :issue_statuses, :issue_categories, :issue_relations, :workflows,
           :enumerations,
           :issues, :attachments

  def setup
    prepare_for_testing_non_meber_roles
  end

  def test_view_watched_issues_list
    Role.non_member_watcher.update_attributes({
        :permissions => [:view_watched_issues_list]
    })

    login_watcher
    get "projects/#{@project.id}/issues"

    assert_response :success
    assert_select 'table.issues' do
      assert_select 'tr.issue', 3
      assert_select "tr#issue-13", 1
      assert_select "tr#issue-5", 1
      assert_select "tr#issue-1", 1
    end
  end

  def test_deny_watched_issues_list
    Role.non_member_watcher.update_attributes({
        :permissions => []
    })

    login_watcher
    get "projects/#{@project.id}/issues"

    assert_response 403
  end

  def test_view_watched_issues
    Role.non_member_watcher.update_attributes({
        :permissions => [:view_watched_issues]
    })

    login_watcher
    get "issues/#{@issue.id}"

    assert_response :success
  end

  def test_deny_watched_issues
    Role.non_member_watcher.update_attributes({
        :permissions => []
    })

    login_watcher
    get "issues/#{@issue.id}"

    assert_response 403
  end

  def test_view_watched_issue_attachments
    Role.non_member_watcher.update_attributes({
        :permissions => [:view_watched_issues]
    })

    login_watcher
    get "attachments/download/#{@attachment.id}/#{@attachment.filename}"

    assert_response :success
  end

  def test_deny_watched_issue_attachments
    Role.non_member_watcher.update_attributes({
        :permissions => []
    })

    login_watcher
    get "attachments/download/#{@attachment.id}/#{@attachment.filename}"

    assert_response 403
  end

  def test_view_created_issues_list
    Role.non_member_author.update_attributes({
        :permissions => [:view_created_issues_list]
    })

    login_author
    get "projects/#{@project.id}/issues"

    assert_response :success
    assert_select 'table.issues' do
      assert_select 'tr.issue', 3
      assert_select "tr#issue-13", 1
      assert_select "tr#issue-5", 1
      assert_select "tr#issue-1", 1
    end
  end

  def test_deny_created_issues_list
    Role.non_member_author.update_attributes({
        :permissions => []
    })

    login_author
    get "projects/#{@project.id}/issues"

    assert_response 403
  end

  def test_view_created_issues
    Role.non_member_author.update_attributes({
        :permissions => [:view_created_issues]
    })

    login_author
    get "issues/#{@issue.id}"

    assert_response :success
  end

  def test_deny_created_issues
    Role.non_member_author.update_attributes({
        :permissions => []
    })

    login_author
    get "issues/#{@issue.id}"

    assert_response 403
  end

  def test_view_created_issue_attachments
    Role.non_member_author.update_attributes({
        :permissions => [:view_created_issues]
    })

    login_author
    get "attachments/download/#{@attachment.id}/#{@attachment.filename}"

    assert_response :success
  end

  def test_deny_created_issue_attachments
    Role.non_member_author.update_attributes({
        :permissions => []
    })

    login_author
    get "attachments/download/#{@attachment.id}/#{@attachment.filename}"

    assert_response 403
  end
end
