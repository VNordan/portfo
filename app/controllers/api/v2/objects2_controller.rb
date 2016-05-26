module Api
  module V2
    class Objects2Controller < ApiController
      # GET /api/v2/objects
      #
      def index
        # res =[]
        # Obj.includes(:construction_object).all.each do |o|
        #   if o.construction_object.nil?
        #     res << "#{o.code_ds}; #{o.adress} #{o.name}"
        #   end
        # end
        # puts res
        @response_object = Obj.api_response
        render render_options
      end
    end
  end
end
