unless Crimagify::Image.all.length > 0
	puts "loading Crimagify data..."
	Crimagify::Image.create!(:image_temporal => "",
				  :parent_id => 0,
				  :parent_type => "")
end