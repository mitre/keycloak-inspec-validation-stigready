# encoding: utf-8
# copyright: 2019, The Authors

require 'hashie/mash'

class Audit < Inspec.resource(1)
  name 'audit'

  def initialize(program)
	  @program = program
	  @output = inspec.command("#{@program}").stdout
	  @json = inspec.json("content: #{@output}")
  end
  
  def enabledEventTypes
	  Hashie::Mash.new(@json['enabledEventTypes'])
  end

end
