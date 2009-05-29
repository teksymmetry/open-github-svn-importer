#
# Manage commands in batch processing
#
class BatchHelper

  #
  # Default constructor
  def initialize
    @commands = [];
  end

  #
  # Add new command
  def add_command(p_command)
    @commands << p_command
    return self
  end

  #
  # Execute all commands in a batch
  def execute
    commands = @commands.join(" && ")
    response = `#{commands}`
  end

  #
  # Create new self instance
  def self.create_batch
    return self.new;
  end
end