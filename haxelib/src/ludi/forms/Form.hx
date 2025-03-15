package ludi.forms;

import ludi.forms.util.StructuredJQuery;
import js.jquery.JQuery;
using Lambda;
using StringTools;

typedef FormSchemaItem = {
    label:String,
    type:String
};

typedef TextSchemaItem = {
    > FormSchemaItem,
    ?placeholder:String
}

typedef NumberSchemaItem = {
    > FormSchemaItem,
    ?min:Float,
    ?max:Float,
    ?step:Float
}

typedef DropdownSchemaItem = {
    > FormSchemaItem,
    options:Array<Dynamic>,
    ?subformSchema:Map<String, Array<FormSchemaItem>>  // Map of option value to subform schema
}

abstract FormSchema(Array<FormSchemaItem>) from Array<FormSchemaItem> to Array<FormSchemaItem> {

    @:from
    public static function fromDynamicArray(dyn:Array<Dynamic>):FormSchema {
        return cast dyn;
    }

    @:to
    public inline function toDynamicArray():Array<Dynamic> {
        return cast this;
    }

}

typedef FormItemRenderer = {
    type:String,
    renderer:(form:Form, item:FormSchemaItem) -> JQuery,
    getValue:(form:Form, item:FormSchemaItem, control:JQuery) -> Dynamic,
    setValue:(form:Form, item:FormSchemaItem, control:JQuery, value:Dynamic) -> Void
}

typedef FormValues = Map<String, {value:Dynamic, ?subform:FormValues}>;

typedef FormJQueryStructure = StructuredJQuery<{
    schema:Array<FormSchemaItem>,
    subforms:Map<String, Form>,
    controls:Map<String, JQuery>,
    changeCallbacks:Map<String, Void->Void>,
    validators:Map<String, Dynamic->Bool>
}>;


@:forward
abstract Form(FormJQueryStructure) to JQuery from JQuery {
    private static var renderers:Array<FormItemRenderer> = [];
    private static var hasInitialized:Bool = false;

    public static function initRenderers():Void {
        renderers = [
            {
                type: "text",
                renderer: (form, item) -> {
                    var textItem:TextSchemaItem = cast item;
                    var input = new JQuery('<input class="ludi-form ludi-form-text" type="text">');
                    if (textItem.placeholder != null) {
                        input.attr("placeholder", textItem.placeholder);
                    }
                    input.on("input", () -> form.handleChange(item.label));
                    return new JQuery('<div class="ludi-form ludi-form-control-container">').append(item.label).append(input);
                },
                getValue: (_, _, control) -> control.find("input").val(),
                setValue: (_, _, control, value) -> control.find("input").val(value)
            },
            {
                type: "checkbox",
                renderer: (form, item) -> {
                    var input = new JQuery('<input class="ludi-form ludi-form-checkbox" type="checkbox">');
                    input.on("change", () -> form.handleChange(item.label));
                    return new JQuery('<div class="ludi-form ludi-form-control-container">').append(item.label).append(input);
                },
                getValue: (_, _, control) -> control.find("input").is(":checked"),
                setValue: (_, _, control, value) -> control.find("input").prop("checked", value)
            },
            {
                type: "number",
                renderer: (form, item) -> {
                    var numItem:NumberSchemaItem = cast item;
                    var input = new JQuery('<input class="ludi-form ludi-form-number" type="number">');
                    if (numItem.min != null) input.attr("min", Std.string(numItem.min));
                    if (numItem.max != null) input.attr("max", Std.string(numItem.max));
                    if (numItem.step != null) input.attr("step", Std.string(numItem.step));
                    input.on("input", () -> form.handleChange(item.label));
                    return new JQuery('<div class="ludi-form ludi-form-control-container">').append(item.label).append(input);
                },
                getValue: (_, _, control) -> Std.parseFloat(control.find("input").val()),
                setValue: (_, _, control, value) -> control.find("input").val(value)
            },
            {
                type: "dropdown",
                renderer: (form, item) -> {
                    var dropItem:DropdownSchemaItem = cast item;
                    var select = new JQuery('<select class="ludi-form ludi-form-select">');
                    var blankOption = new JQuery('<option class="ludi-form ludi-form-option" value="">');
                    select.append(blankOption);
                    if (dropItem.options != null && Std.is(dropItem.options, Array)) {
                        for (option in dropItem.options) {
                            select.append(new JQuery('<option class="ludi-form ludi-form-option">').val(option).text(option));
                        }
                    }
                    select.on("change", () -> {
                        form.handleChange(item.label);
                        var fields = form.getFields();
                        var val = select.val();
                        if (val != "" && blankOption.parent().length > 0) {
                            blankOption.remove();
                        }
                        if (fields.subforms.exists(item.label)) {
                            form.removeSubform(item.label);
                        }
                        if (dropItem.subformSchema != null && dropItem.subformSchema.exists(val)) {
                            form.setSubform(item.label, dropItem.subformSchema.get(val));
                        }
                    });
                    return new JQuery('<div class="ludi-form ludi-form-control-container">').append(item.label).append(select);
                },
                getValue: (_, _, control) -> control.find("select").val(),
                setValue: (_, _, control, value) -> {
                    var select = control.find("select");
                    if (value != "" && select.find('option[value=""]').length > 0) {
                        select.find('option[value=""]').remove();
                    }
                    select.val(value);
                }
            },
            {
                type: "button",
                renderer: (form, item) -> {
                    var button = new JQuery('<button class="ludi-form ludi-form-button">').text(item.label);
                    button.on("click", () -> form.handleChange(item.label));
                    return button;
                },
                getValue: (_, _, _) -> true,
                setValue: (_, _, _, _) -> {}
            }
        ];
        hasInitialized = true;
    }

    public function new(schema:Array<FormSchemaItem>) {
        if (!hasInitialized) initRenderers();
        
        this = cast new JQuery('<div class="ludi-form ludi-form-form-container">');
        var controls = new Map<String, JQuery>();
        var changeCallbacks = new Map<String, Void->Void>();
        var validators = new Map<String, Dynamic->Bool>();
        
        this.setFields({
            schema: schema,
            subforms: new Map(),
            controls: controls,
            changeCallbacks: changeCallbacks,
            validators: validators
        });

        for (item in schema) {
            var control = renderItem(item);
            controls.set(item.label, control);
            this.append(control);
        }
    }

    private function renderItem(item:FormSchemaItem):JQuery {
        for (renderer in renderers) {
            if (renderer.type == item.type) {
                return renderer.renderer(abstract, item);
            }
        }
        return new JQuery('<div>').text('Unknown type: ${item.type}');
    }

    private function handleChange(label:String):Void {
        var fields = this.getFields();
        if (fields.changeCallbacks.exists(label)) {
            fields.changeCallbacks.get(label)();
        }
    }

    public function onChange(itemLabel:String, cb:Void->Void):Void {
        var fields = this.getFields();
        fields.changeCallbacks.set(itemLabel, cb);
        this.setFields(fields);
    }

    public function setSubform(itemLabel:String, schema:Array<FormSchemaItem>):Void {
        var fields = this.getFields();
        var subform = new Form(schema);
        fields.subforms.set(itemLabel, subform);
        
        var control = fields.controls.get(itemLabel);
        if (control != null) {
            control.append(subform);
        } else {
            var itemDiv = this.find('div.ludi-form-control-container').filter(function(index, element) {
                var jel = new JQuery(element);
                var contents = jel.contents();
                var textContent = contents.filter(function(i, e) {
                    return e.nodeType == 3; 
                }).text().trim();
                return textContent == itemLabel;
            });
            
            if (itemDiv.length > 0) {
                itemDiv.append(subform);
            } else {
                trace('Warning: Could not find control container for label "${itemLabel}"');
            }
        }
        
        this.setFields(fields);
    }
    public function removeSubform(itemLabel:String):Void {
        var fields = this.getFields();
        if (fields.subforms.exists(itemLabel)) {
            fields.subforms[itemLabel].remove();
            fields.subforms.remove(itemLabel);
            this.setFields(fields);
        }
    }

    public function getValues():FormValues {
        var fields = this.getFields();
        var values = new Map<String, {value:Dynamic, ?subform:FormValues}>();
        
        for (item in fields.schema) {
            var control = fields.controls.get(item.label);
            if (control != null) {
                var renderer = renderers.find(r -> r.type == item.type);
                if (renderer != null) {
                    var value = renderer.getValue(abstract, item, control);
                    values.set(item.label, {value: value});
                }
            }
        }

        for (key in fields.subforms.keys()) {
            var subformValues = fields.subforms[key].getValues();
            if (values.exists(key)) {
                var existing = values.get(key);
                values.set(key, {value: existing.value, subform: subformValues});
            } else {
                values.set(key, {value: null, subform: subformValues});
            }
        }

        return values;
    }

    public function addValidation(itemLabel:String, validator:Dynamic->Bool):Void {
        var fields = this.getFields();
        fields.validators.set(itemLabel, validator);
        this.setFields(fields);
    }

    public function validate():Bool {
        var fields = this.getFields();
        var values = getValues();
        var isValid = true;

        for (control in fields.controls) {
            control.removeClass("validation-failed");
        }

        for (item in fields.schema) {
            if (fields.validators.exists(item.label)) {
                var value = values.get(item.label) != null ? values.get(item.label).value : null;
                var validator = fields.validators.get(item.label);
                var valid = validator(value);
                if (!valid) {
                    isValid = false;
                    var control = fields.controls.get(item.label);
                    if (control != null) {
                        control.addClass("validation-failed");
                    }
                }
            }
        }

        for (key in fields.subforms.keys()) {
            var subformValid = fields.subforms[key].validate();
            if (!subformValid) {
                isValid = false;
            }
        }

        return isValid;
    }

    public static inline function create(schema:Array<FormSchemaItem>, setup:(Form)->Void):Form {
        var form = new Form(schema);
        setup(form);
        return form;
    }
}
