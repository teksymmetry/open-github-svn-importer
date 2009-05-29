#
# Provide git related functionalities
#
class GitHelper

  #
  # Clone Git remote repository
  def self.clone(p_repository, p_local_path)
    "git clone #{p_repository} #{p_local_path}"
  end

  #
  # Push source to the specified branch
  def self.push(p_branch, p_local_path)
    "cd #{p_local_path} && git push origin #{p_branch}"
  end

  #
  # Add files under git repository
  def self.add(p_files, p_local_path)
    "cd #{p_local_path} && git add #{p_files}"
  end

  #
  # Commit changed files
  def self.commit(p_message, p_author, p_local_path)
    "cd #{p_local_path} && git commit -m '#{(p_message || "no message set").gsub(/['\n\r]/, " ")}' --author '#{p_author}'"
  end

  #
  # Format svn formatted user to git supported author
  def self.format_author(p_author)
    if p_author.match(/@/)
      return "#{p_author.split("@").first} <#{p_author}>"
    else
      return "#{p_author} <#{p_author}@localhost>"
    end
  end

end