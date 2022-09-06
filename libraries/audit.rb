# encoding: utf-8
# copyright: 2019, The Authors

require 'hashie/mash'
require_relative '../controls/output'

class Audit < Inspec.resource(1)
  name 'audit'

  def initialize(program)
	  @program = program
	  @json = inspec.json(program)
  end
  
  def enabledEventTypes
	  Hashie::Mash.new(@json['enabledEventTypes'])
  end

end
