# Import SVN repository to GIT
# Load required libraries
require 'fileutils'
require File.join(File.dirname(__FILE__), 'svn_helper')
require File.join(File.dirname(__FILE__), 'git_helper')
require File.join(File.dirname(__FILE__), 'batch_helper')

#
# Import SVN repository on GIT
#
class SvnOnGit

  attr_accessor :m_svn_path, :m_git_local_path, :m_git_project, :m_starting_revision

  #
  # Default constructor.
  def initialize(p_git_project, p_git_local_path, p_svn_path, p_starting_revision)
    @m_git_project = p_git_project
    @m_git_local_path = p_git_local_path
    @m_svn_path = p_svn_path
    @m_starting_revision = p_starting_revision
  end

  #
  # Import SVN repository on GIT
  def import
    # Empty local directory
    clone_git_repository

    # Pull svn revision logs
    logs = SvnHelper::logs(@m_svn_path)
    logs.each do |log|
      if exportable?(log)
        puts "Exporting revision - #{log[:revision]}"
        export_svn_revision_to_git(log)
      end
    end
  end

  #
  # Verify the revision is allowed to export
  def exportable?(p_log)
    p_log[:revision].to_i >= @m_starting_revision  
  end

  #
  # Export svn source of the specified revision and push
  # them to git repository
  def export_svn_revision_to_git(p_log)
    batch = BatchHelper::create_batch
    export_source_of_revision(p_log[:revision], batch)
    add_all_files_in_git(batch)
    commit_all_files_in_git(batch, p_log[:message], p_log[:author])
    push_source_to(:master, batch)
  
    batch.execute
  end

  #
  # Push changes to the remote GIT repository
  def push_source_to(p_tag, p_batch)
    p_batch.add_command(GitHelper::push(p_tag.to_s, @m_git_local_path))
  end

  #
  # Commit all files in GIT
  def commit_all_files_in_git(p_batch, p_message, p_author)
    p_batch.add_command(GitHelper::commit(
        p_message, GitHelper::format_author(p_author), @m_git_local_path))
  end

  #
  # All all files of the specific SVN revision to the GIT
  def add_all_files_in_git(p_batch)
    p_batch.add_command(GitHelper::add("*", @m_git_local_path))
  end

  #
  # Export source of the specific revision and add the task in a batch
  def export_source_of_revision(p_revision, p_batch)
    p_batch.add_command(
        SvnHelper::export(@m_svn_path, p_revision, @m_git_local_path))
  end

  #
  # Clone git repository
  def clone_git_repository
    FileUtils.rm_rf(@m_git_local_path)

    # Initiate git project directory
    BatchHelper::create_batch.
        add_command(GitHelper::clone(@m_git_project, @m_git_local_path)).
        execute()
  end

end
