import ludi.forms.Form;
import js.jquery.JQuery;

class Main {
    static function main() {
        var schema:FormSchema = [
            {label: "Background Image", type: "text", placeholder: "Path to background image (e.g., assets/bg.png)"},
            {label: "Background Opacity", type: "number", min: 0.0, max: 1.0, step: 0.1},
            
            {label: "Padding Top", type: "number", min: 0, step: 1},
            {label: "Padding Bottom", type: "number", min: 0, step: 1},
            {label: "Padding Left", type: "number", min: 0, step: 1},
            {label: "Padding Right", type: "number", min: 0, step: 1},
            
            {
                label: "Size",
                type: "dropdown",
                options: ["Explicit", "MatchBackground"],
                subformSchema: [
                    "Explicit" => [
                        {label: "Width", type: "number", min: 0, step: 1.0},
                        {label: "Height", type: "number", min: 0, step: 1.0}
                    ],
                    "MatchBackground" => []
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

            {label: "Test File", type: "file"},
            
            {label: "Submit", type: "button"}
        ];
        
        // Subform schema for Name Box Config
        var nameBoxSubform:FormSchema = [
            {label: "Name Box Background Color", type: "text", placeholder: "Hex color (e.g., 0x333333)"},
            {label: "Name Box Text Color", type: "text", placeholder: "Hex color (e.g., 0xFFFFFF)"},
            {label: "Name Box Font Size", type: "number", min: 1, step: 1},
            {label: "Name Box Padding Top", type: "number", min: 0, step: 1},
            {label: "Name Box Padding Bottom", type: "number", min: 0, step: 1},
            {label: "Name Box Padding Left", type: "number", min: 0, step: 1},
            {label: "Name Box Padding Right", type: "number", min: 0, step: 1},
            {label: "Name Box Offset X", type: "number", step: 1},
            {label: "Name Box Offset Y", type: "number", step: 1}
        ];
        
        // Subform schema for Cursor Config
        var cursorSubform:FormSchema = [
            {label: "Cursor Sprite Path", type: "text", placeholder: "Path to cursor image"},
            {label: "Cursor Width", type: "number", min: 0, step: 1},
            {label: "Cursor Height", type: "number", min: 0, step: 1},
            {
                label: "Cursor Positioning",
                type: "dropdown",
                options: ["AfterTextEnd", "Specific"],
                subformSchema: [
                    "AfterTextEnd" => [],
                    "Specific" => [
                        {label: "Cursor X", type: "number", step: 1},
                        {label: "Cursor Y", type: "number", step: 1}
                    ]
                ]
            },
            {label: "Cursor Offset X", type: "number", step: 1},
            {label: "Cursor Offset Y", type: "number", step: 1},
            {
                label: "Cursor Animation Type",
                type: "dropdown",
                options: ["None", "Bounce", "Fade", "Pulse"]
            },
            {label: "Cursor Animation Speed", type: "number", min: 0, step: 0.1},
            {label: "Cursor Is Visible", type: "checkbox"}
        ];
        
        // Create and configure the form
        var form = Form.create(schema, (form) -> {
            // Handle Has Name Box checkbox
            form.onChange("Has Name Box", () -> {
                var val = form.getValues().get("Has Name Box").value;
                if (val == true) {
                    form.setSubform("Has Name Box", nameBoxSubform);
                } else {
                    form.removeSubform("Has Name Box");
                }
            });
            
            // Handle Has Cursor checkbox
            form.onChange("Has Cursor", () -> {
                var val = form.getValues().get("Has Cursor").value;
                if (val == true) {
                    form.setSubform("Has Cursor", cursorSubform);
                } else {
                    form.removeSubform("Has Cursor");
                }
            });
            
            // Handle Submit button
            form.onChange("Submit", () -> {
                trace(form.getValues());
            });
        });
        
        new JQuery("body").append(form);
    }
}