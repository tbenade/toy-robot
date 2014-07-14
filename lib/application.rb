
require_relative '../lib/simulator'
require_relative '../lib/robot'
require_relative '../lib/table'

if ARGV.length > 0
  puts "Sorry I have no idea what to do with #{ARGV}. No args required!"
  exit
end

simulator = Simulator.new(Table.new(5,5),Robot.new)

puts "Send PLACE x,y,heading or MOVE or LEFT or RIGHT or REPORT. ctrl+c to Exit"

command = gets
while command
  simulator.execute_command(command.strip)
  command = gets
end