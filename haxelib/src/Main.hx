import ludi.forms.Form;
import js.jquery.JQuery;

class Main {
    static function main() {
        var schema: FormSchema = [
            {label: "Name", type: "text", placeholder: "Enter your name"},
            {label: "Age", type: "number", min: 0, max: 150, step: 2},
            {
                label: "Country", 
                type: "dropdown", 
                options: ["USA", "UK", "Canada"],
                subformSchema: [
                    "USA" => [{label: "State", type: "text", placeholder: "Enter your state"}],
                    "UK" => [{label: "County", type: "text", placeholder: "Enter your county"}]
                ]
            },
            {label: "Submit", type: "button"}
        ];
        
        var form = Form.create(schema, (form) -> {
            form.onChange("Submit", () -> {
                trace(form.getValues());
            });
        });
        
        new JQuery("body").append(form);
    }
}