module Api
  module V2
    class ObjectsController < ApiController
      # GET /api/v2/objects
      #
      def index
        data = ''
        file = File.new("api_cache/objects.json", "r")
        while (line = file.gets)
          data += line
        end
        file.close
        @response_object = data
        render render_options
      end
    end
  end
end
