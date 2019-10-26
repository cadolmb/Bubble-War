require 'gosu'
require './window.rb'
Dir['./data/*.rb'].each { |file| require file }
Dir['./states/*.rb'].each { |file| require file }
Dir['./entities/*.rb'].each { |file| require file }

$window = Window.new
GameState.switch MenuState.new
$window.show
