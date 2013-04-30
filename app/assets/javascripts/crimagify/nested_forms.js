$(function(){

    // function for add fields
    $("form").on("click",".add_fields",function(){

        time = new Date().getTime();
        regexp = new RegExp($(this).data('id'), 'g');
        $(this).before($(this).data('fields').replace(regexp, time));
        event.preventDefault();
        var count = 1;

        //data strings
        var parent_attributes = $(this).data('parent');
        var parent_object = $(this).data('parentobject');
        // var name_image_temporal = $('.image_temporal:last').attr('name');
        // console.log(name_image_temporal);
        // $('.image_temporal:last')$('div.fieldset:last')
        $('.parent:last').attr('name', '' + parent_object + '[' + parent_attributes + '_attributes][' + time + '][parent]');
        $('.parent_id:last').attr('name', '' + parent_object + '[' + parent_attributes + '_attributes][' + time + '][parent_id]');
        $('.id_images:last').attr('name', '' + parent_object + '[' + parent_attributes + '_attributes][' + time + '][id_images]');

        //console.log($('div.fieldset:last'))
        var element_last = $('div.fieldset:last');

        console.dir($('.image_temporal',element_last));
        var new_array = $('.image_temporal',element_last);

        // for (var i = 0; i < $('.image_temporal',element_last).length; i++) {
        //     console.log($(i).attr('class'))
        // };
        var name_old_1 = $('.image_temporal.image_imgA', element_last).attr('name')
        var name_new_1 = '' + parent_object + '[' + parent_attributes + '_attributes][' + time + '][' + name_old_1 + ']'
        $('.image_temporal.image_imgA', element_last).attr('name', name_new_1);
        
        var name_old_2 = $('.image_temporal.image_imgB', element_last).attr('name')
        var name_new_2 = '' + parent_object + '[' + parent_attributes + '_attributes][' + time + '][' + name_old_2 + ']'
        $('.image_temporal.image_imgB', element_last).attr('name', name_new_2);

    });
		

    //function for remove fields
    $("form").on("click", ".remove_fields", function(event){
        $(this).prevAll(".remove").attr("value","true");
        $(this).closest('fieldset').hide();        
        event.preventDefault();
    });
    
});