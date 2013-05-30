$(function(){

    var $frmCrimagify = $(".nested_crimagify_images");
    
    if($frmCrimagify.find(".fieldset_crimagify_nested").length == 1){
        setAttributesNames($frmCrimagify);
    }else if($frmCrimagify.find(".fieldset_crimagify_nested").length > 1) {
        $this = $frmCrimagify;
        var $fieldset = $frmCrimagify.find(".fieldset_crimagify_nested")
        for (var i = 0; i<$fieldset.length;i++){
            var $new_fieldset = $($fieldset[i]);
            $new_fieldset.attr("id", "nested_"+i);
            $new_fieldset.attr("id","nested_" + i);
            $new_fieldset.find(".parent").attr('name',$this.data('parentobject')+'['+$this.data('parent')+'_attributes]['+i+'][parent]');
            $new_fieldset.find(".parent_id").attr('name',$this.data('parentobject')+'['+$this.data('parent')+'_attributes]['+i+'][parent_id]');
            $new_fieldset.find(".id_images").attr('name',$this.data('parentobject')+'['+$this.data('parent')+'_attributes]['+i+'][id_images]');
            $new_fieldset.find(".nested_crimagify_schema").attr('name',$this.data('parentobject')+'['+$this.data('parent')+'_attributes]['+i+'][crimagify_schema]');
            $new_fieldset.find(".nested_crimagify_schema").attr('value',getTime());
            // $new_fieldset.find(".remove").attr('name',$this.data('parentobject')+'['+$this.data('parent')+'_attributes]['+i+'][_destroy]');
            // $fieldset.find(".remove").removeAttr("id");
            var imagesTemporal = $new_fieldset.find(".image_temporal");
            for(var j = 0; j<imagesTemporal.length;j++){
                var $inputImage = $(imagesTemporal[j]);
                var nameOld = $inputImage.attr("name");
                $inputImage.attr('name',$this.data('parentobject') + '[' + $this.data('parent') + '_attributes][' + i + ']['+nameOld+']');
            }
        }            
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
        $fieldset.find(".nested_crimagify_schema").attr('name',$this.data('parentobject')+'['+$this.data('parent')+'_attributes]['+time+'][crimagify_schema]');
        $fieldset.find(".nested_crimagify_schema").attr('value',getTime());
        // $fieldset.find(".remove").attr('name',$this.data('parentobject')+'['+$this.data('parent')+'_attributes]['+time+'][_destroy]');
        // $fieldset.find(".remove").removeAttr("id");
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
    // var $remove = $fieldset.find(".remove")
    // for(var r = 0; r)
    $fieldset.attr("id","nested_0");
    $fieldset.find(".parent").attr("name",$form.data("parentobject")+"["+$form.data("parent")+"_attributes]["+0+"][parent]");
    $fieldset.find(".parent_id").attr("name",$form.data("parentobject")+"["+$form.data("parent")+"_attributes]["+0+"][parent_id]");
    $fieldset.find(".id_images").attr("name",$form.data("parentobject")+"["+$form.data("parent")+"_attributes]["+0+"][id_images]");
    $fieldset.find(".nested_crimagify_schema").attr('name',$form.data('parentobject')+'['+$form.data('parent')+'_attributes]['+0+'][crimagify_schema]');
    $fieldset.find(".nested_crimagify_schema").attr('value',getTime());
    // $fieldset.find(".remove").attr("name",$form.data("parentobject")+"["+$form.data("parent")+"_attributes]["+0+"][_destroy]");
    // $fieldset.find(".remove").removeAttr("id");
    var imagesTemporal = $fieldset.find(".image_temporal");
    for(var i = 0; i<imagesTemporal.length;i++){
        var $inputImage = $(imagesTemporal[i]);
        var nameOld = $inputImage.attr("name");
        $inputImage.attr('name',$form.data('parentobject')+'['+$form.data('parent')+'_attributes]['+0+']['+nameOld+']');
    }
}