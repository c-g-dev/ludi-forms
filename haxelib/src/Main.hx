import ludi.forms.Form;
import js.jquery.JQuery;

class Main {
    static function main() {
        var schema:FormSchema = [
            {label: "Background Image", type: "text", placeholder: "Path to background image (e.g., assets/bg.png)"},
            {label: "Background Opacity", type: "number", min: 0.0, max: 1.0, step: 0.1},
            
            /*{
                label: "Padding",
                type: "group",
                subformSchema: [
                    {label: "Top", type: "number", min: 0, step: 1},
                    {label: "Bottom", type: "number", min: 0, step: 1},
                    {label: "Left", type: "number", min: 0, step: 1},
                    {label: "Right", type: "number", min: 0, step: 1}
                ]
            },*/
            
            {
                label: "Size",
                type: "dropdown",
                options: ["Explicit", "MatchBackground"],
                subformSchema: [
                    "Explicit" => [
                        {label: "Width", type: "number", min: 0, step: 1.0},
                        {label: "Height", type: "number", min: 0, step: 1.0}
                    ]
                ]
            },
            
            {label: "Font Family", type: "text", placeholder: "e.g., Arial"},
            {label: "Font Size", type: "number", min: 1, step: 1},
            {label: "Text Color", type: "text", placeholder: "Hex color (e.g., 0xFFFFFF)"},
            {label: "Line Spacing", type: "number", min: 0, step: 0.1},
            
            {
                label: "Position",
                type: "dropdown",
                options: ["Top", "Center", "Bottom"]
            },
            {label: "Offset X", type: "number", step: 1},
            {label: "Offset Y", type: "number", step: 1},
            
            {
                label: "Text Effect",
                type: "dropdown",
                options: ["None", "FadeIn"],
                subformSchema: [
                    "None" => [],
                    "FadeIn" => [
                        {label: "Fade In Speed", type: "number", min: 0, step: 0.1}
                    ]
                ]
            },
            {label: "Text Speed", type: "number", min: 0, step: 1.0},
            
            {label: "Has Name Box", type: "checkbox"},
            {label: "Has Cursor", type: "checkbox"},
            
            {label: "Submit", type: "button"}
        ];
        
        // Subform schema for Name Box Config
        var nameBoxSubformSchema:FormSchema = [
            {label: "Background Color", type: "text", placeholder: "Hex color (e.g., 0x333333)"},
            {label: "Text Color", type: "text", placeholder: "Hex color (e.g., 0xFFFFFF)"},
            {label: "Font Size", type: "number", min: 1, step: 1},
            {
                label: "Padding",
                type: "group",
                subformSchema: [
                    {label: "Top", type: "number", min: 0, step: 1},
                    {label: "Bottom", type: "number", min: 0, step: 1},
                    {label: "Left", type: "number", min: 0, step: 1},
                    {label: "Right", type: "number", min: 0, step: 1}
                ]
            },
            {label: "Offset X", type: "number", step: 1},
            {label: "Offset Y", type: "number", step: 1}
        ];
        
        // Subform schema for Cursor Config
        var cursorSubformSchema:FormSchema = [
            {label: "Sprite Path", type: "text", placeholder: "Path to cursor image"},
            {
                label: "Size",
                type: "group",
                subformSchema: [
                    {label: "Width", type: "number", min: 0, step: 1},
                    {label: "Height", type: "number", min: 0, step: 1}
                ]
            },
            {
                label: "Positioning",
                type: "dropdown",
                options: ["AfterTextEnd", "Specific"],
                subformSchema: [
                    "AfterTextEnd" => [],
                    "Specific" => [
                        {label: "X", type: "number", step: 1},
                        {label: "Y", type: "number", step: 1}
                    ]
                ]
            },
            {label: "Offset X", type: "number", step: 1},
            {label: "Offset Y", type: "number", step: 1},
            {
                label: "Animation Type",
                type: "dropdown",
                options: ["None", "Bounce", "Fade", "Pulse"]
            },
            {label: "Animation Speed", type: "number", min: 0, step: 0.1},
            {label: "Is Visible", type: "checkbox"}
        ];
        
        // Form creation with dynamic subform handling
        var form = Form.create(schema, (form) -> {
            // Handle Has Name Box checkbox
            form.onChange("Has Name Box", () -> {
                var val:Bool = form.getValues().get("Has Name Box").value;
                if (val) {
                    form.setSubform("Has Name Box", nameBoxSubformSchema);
                } else {
                    form.removeSubform("Has Name Box");
                }
            });
            
            // Handle Has Cursor checkbox
            form.onChange("Has Cursor", () -> {
                var val:Bool = form.getValues().get("Has Cursor").value;
                if (val) {
                    form.setSubform("Has Cursor", cursorSubformSchema);
                } else {
                    form.removeSubform("Has Cursor");
                }
            });
            
            // Handle form submission
            form.onChange("Submit", () -> {
                trace(form.getValues());
            });
        });
        
        new JQuery("body").append(form);
    }
}