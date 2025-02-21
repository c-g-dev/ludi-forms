package ludi.forms;

import ludi.forms.util.StructuredJQuery;
import js.jquery.JQuery;
using Lambda;


typedef FormSchemaItem = {
    label:String,
    type:String
};

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
    changeCallbacks:Map<String, Void->Void>
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
                    var input = new JQuery('<input class="ludi-form ludi-form-text" type="text">');
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
                    var input = new JQuery('<input class="ludi-form ludi-form-number" type="number">');
                    input.on("input", () -> form.handleChange(item.label));
                    return new JQuery('<div class="ludi-form ludi-form-control-container">').append(item.label).append(input);
                },
                getValue: (_, _, control) -> Std.parseFloat(control.find("input").val()),
                setValue: (_, _, control, value) -> control.find("input").val(value)
            },
            {
                type: "dropdown",
                renderer: (form, item) -> {
                    var options:Dynamic = Reflect.field(item, "options");
                    var select = new JQuery('<select class="ludi-form ludi-form-select" >');
                    if (options != null && Std.is(options, Array)) {
                        for (option in (options:Array<Dynamic>)) {
                            select.append(new JQuery('<option class="ludi-form ludi-form-option" >').val(option).text(option));
                        }
                    }
                    select.on("change", () -> form.handleChange(item.label));
                    return new JQuery('<div class="ludi-form ludi-form-control-container" >').append(item.label).append(select);
                },
                getValue: (_, _, control) -> control.find("select").val(),
                setValue: (_, _, control, value) -> control.find("select").val(value)
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
        
        this.setFields({
            schema: schema,
            subforms: new Map(),
            controls: controls,
            changeCallbacks: changeCallbacks
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
        
        var itemDiv = this.find('div:contains("$itemLabel")');
        itemDiv.append(subform);
        
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

    public static inline function create(schema:Array<FormSchemaItem>, setup:(Form)->Void):Form {
        var form = new Form(schema);
        setup(form);
        return form;
    }
}