require "sinatra"
require "sinatra-websocket"

class Colors
    def initialize
      @sine = 0.00
    end
    def next
      red = Math.sin(@sine) * 127 + 128
      green = Math.sin(@sine + 2) * 127 + 128
      blue = Math.sin(@sine + 4) * 127 + 128
      @sine += 0.30
      "rgb(#{red.round},#{green.round},#{blue.round})"
    end
end

class Server < Sinatra::Base
    set :sockets, Array.new
    set :colors, Colors.new

    get "/" do
        request.websocket do |ws|
            ws.onopen do
                settings.sockets << ws
                ws.send(settings.colors.next)
            end

            ws.onmessage do |msg|
                settings.sockets.each {|socket| socket.send(msg) }
            end

            ws.onclose do
                settings.sockets.delete(ws)
            end
        end
    end
end