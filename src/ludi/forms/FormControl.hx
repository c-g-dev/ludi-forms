package ludi.forms;

import ludi.forms.Form.FormSchemaItem;

typedef FormSchemaItem_Dropdown = FormSchemaItem & {
    options:Array<String>
};

class FormControl {
    public static function Text(label:String):FormSchemaItem {
        return {
            label: label,
            type: "text"
        };
    }

    public static function Checkbox(label:String):FormSchemaItem {
        return {
            label: label,
            type: "checkbox"
        };
    }

    public static function Number(label:String):FormSchemaItem {
        return {
            label: label,
            type: "number"
        };
    }

    public static function Dropdown(label:String, options:Array<String>):FormSchemaItem_Dropdown {
        return {
            label: label,
            type: "dropdown",
            options: options
        };
    }

    public static function Button(label:String):FormSchemaItem {
        return {
            label: label,
            type: "button"
        };
    }
}