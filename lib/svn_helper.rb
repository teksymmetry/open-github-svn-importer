require "rexml/document"

#
# Provide svn related functionalities
#
class SvnHelper

  #
  # Retrieve all svn logs and process a hash map object
  def self.logs(p_url)
    xml_response = `svn log #{p_url} --xml`
    if xml_response
      xml_doc = REXML::Document.new(xml_response)
      logs = []
      xml_doc.root.elements.each("logentry") do |element|
        logs << {:revision => element.attributes["revision"],
                 :author => element.elements["author"].text,
                 :message => "SVN_REV: (#{element.attributes["revision"]}) - #{element.elements["msg"].text}"}
      end
      return logs.reverse
    else
      raise "No response found from svn repository"
    end
  end

  #
  # Checkout specific revision from the repository
  def self.export(p_url, p_revision, p_svn_path)
    "svn export --revision #{p_revision} #{p_url} #{p_svn_path} --force"
  end
end