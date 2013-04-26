$(function(){

    // function for add fields
    $("form").on("click",".add_fields",function(){
        console.log("entra a esta accion");
        time = new Date().getTime();
        regexp = new RegExp($(this).data('id'), 'g');
        $(this).before($(this).data('fields').replace(regexp, time));
        event.preventDefault();
    });
		

    //function for remove fields
    $("form").on("click", ".remove_fields", function(event){
        $(this).prevAll(".remove").attr("value","true");
        $(this).closest('fieldset').hide();        
        event.preventDefault();
    });
