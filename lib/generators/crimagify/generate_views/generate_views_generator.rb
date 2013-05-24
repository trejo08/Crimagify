module Crimagify
  module Generators
    class GenerateViewsGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../../../../../app/views", __FILE__)
      desc "Generate Views of Crimagify"
      

      def copy_views
        directory "crimagify", "app/views/crimagify"
      end      
    end
  end
end
