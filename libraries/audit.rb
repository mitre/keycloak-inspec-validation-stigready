# encoding: utf-8
# copyright: 2019, The Authors


class Audit < Inspec.resource(1)
  name 'audit'

  def initialize(program)
    @program = program
  end
  
  def outcome
	  inspec.command('#{@program}').stdout
  end

end
