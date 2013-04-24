= Crimagify

== Installation
1. Add to your Gemfile: <tt>gem 'crimagify', :git => 'git@github.com/trejo08/crimagify.git'</tt>
2. Run <tt>Bundle</tt>
3. Execute: <tt>rails generate crimagify:install</tt>
4. Run migrations: <tt>rake db:migrate</tt>
5. Run seeds: <tt>rake db:seed</tt>
6. Add to your routes.rb: <tt>mount Crimagify::Engine => "/crimagify", :as => "crimagify"</tt>
7. Add to your model: 
<tt>
	extend Crimagify::DinamicImageMethods

	has_many :crimagify_images, :as => :parent, :dependent => :destroy, :class_name => Crimagify::Image

	build_methods_images
</tt>
8. Add to your controller:
<tt>
	#For Action Create
	Crimagify::ImageFunctions::create_new_images(@object,params)

	#For Action Update
	Crimagify::ImageFunctions::update_images(@object, params)
</tt>
9. Add to application.js:

<tt>//= require crimagify/application</tt>

10. Add to application.css:

<tt>*= require crimagify/application</tt>

11. Add to View:

<tt>
	<%= form_for(@object) do |f| %>
		...
		<%= images_id(@object) %>
		<%= images_cropper(@object, { image_name: "imgA", ratio: :big}, { :class => "img_start"}) %>
		<%= images_cropper(@object, { image_name: "imgB", ratio: :small}, { :class => "img_start"}) %>
		...
	<% end %>
</tt>

