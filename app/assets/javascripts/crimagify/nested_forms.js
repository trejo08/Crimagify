$(function(){

    var $frmCrimagify = $(".nested_crimagify_images");
    $frmCrimagify.find(".fieldset_crimagify_nested").attr("id", "nested_" + getTime());
    if($frmCrimagify.find(".fieldset_crimagify_nested").length == 1){
        setAttributesNames($frmCrimagify);
    }

    // function for add fields
    $frmCrimagify.on("click",".add_fields",function(e){
        e.preventDefault();
        $this = $(this);
        var time = getTime();
        var regex = new RegExp($this.data("id"),"g");       
        $this.before($this.data('fields').replace(regex, time));
        //data strings
        var $fieldset = $frmCrimagify.find(".fieldset_crimagify_nested").last();
        $fieldset.attr("id","nested_" + time);
        $fieldset.find(".parent").attr('name',$this.data('parentobject')+'['+$this.data('parent')+'_attributes]['+time+'][parent]');
        $fieldset.find(".parent_id").attr('name',$this.data('parentobject')+'['+$this.data('parent')+'_attributes]['+time+'][parent_id]');
        $fieldset.find(".id_images").attr('name',$this.data('parentobject')+'['+$this.data('parent')+'_attributes]['+time+'][id_images]');
        var imagesTemporal = $fieldset.find(".image_temporal");
        for(var i = 0; i<imagesTemporal.length;i++){
            var $inputImage = $(imagesTemporal[i]);
            var nameOld = $inputImage.attr("name");
            $inputImage.attr('name',$this.data('parentobject') + '[' + $this.data('parent') + '_attributes][' + time + ']['+nameOld+']');
        }
    });
		

    //function for remove fields
    $frmCrimagify.on("click", ".remove_fields", function(event){
        event.preventDefault();
        $this = $(this);
        $this.prevAll(".remove").attr("value","true");
        $this.closest('.fieldset_crimagify_nested').hide();       
    });
    
});
function getTime(){
    return new Date().getTime();
}

function setAttributesNames($form){
    var $fieldset = $form.find(".fieldset_crimagify_nested");
    $fieldset.find(".parent").attr("name",$form.data("parentobject")+"["+$form.data("parent")+"_attributes]["+0+"][parent]");
    $fieldset.find(".parent_id").attr("name",$form.data("parentobject")+"["+$form.data("parent")+"_attributes]["+0+"][parent_id]");
    $fieldset.find(".id_images").attr("name",$form.data("parentobject")+"["+$form.data("parent")+"_attributes]["+0+"][id_images]");
    var imagesTemporal = $fieldset.find(".image_temporal");
    for(var i = 0; i<imagesTemporal.length;i++){
        var $inputImage = $(imagesTemporal[i]);
        var nameOld = $inputImage.attr("name");
        $inputImage.attr('name',$form.data('parentobject')+'['+$form.data('parent')+'_attributes]['+0+']['+nameOld+']');
    }
}







