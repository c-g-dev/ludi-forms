package ludi.forms;

import ludi.forms.Form.TextSchemaItem;
import ludi.forms.Form.DropdownSchemaItem;
import ludi.forms.Form.NumberSchemaItem;
import ludi.forms.Form.FormSchemaItem;


class FormControl {
    public static function Text(label:String, ?placeholder:String):TextSchemaItem {
        return {
            label: label,
            type: "text",
            placeholder: placeholder
        };
    }

    public static function Checkbox(label:String):FormSchemaItem {
        return {
            label: label,
            type: "checkbox"
        };
    }

    public static function Number(label:String, ?min:Float, ?max:Float, ?step:Float):NumberSchemaItem {
        return {
            label: label,
            type: "number",
            min: min,
            max: max,
            step: step
        };
    }

    public static function Dropdown(label:String, options:Array<String>, ?subformSchema:Map<String, Array<FormSchemaItem>>):DropdownSchemaItem {
        return {
            label: label,
            type: "dropdown",
            options: options,
            subformSchema: subformSchema
        };
    }

    public static function Button(label:String):FormSchemaItem {
        return {
            label: label,
            type: "button"
        };
    }
}