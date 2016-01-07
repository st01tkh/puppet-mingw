module Puppet::Parser::Functions
  newfunction(:env, :type => :rvalue) do |args|
    variable = args[0]
    return ENV[variable]
  end
end
