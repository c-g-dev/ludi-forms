# ludi-forms

I got tired of rewriting form systems and hating them so this is my centralized library for the task.

```haxe
        var schema = [
            {label: "Name", type: "text"},
            {label: "Age", type: "number"},
            {label: "Country", type: "dropdown", options: ["USA", "UK", "Canada"]},
            {label: "Submit", type: "button"}
        ];

        var otherSchema = [
            {label: "Details", type: "text"}
        ];

        var form = Form.create(schema, (form) -> {
            form.onChange("Country", () -> {
                var val = form.getValues().get("Country").value;
                if (val == "USA") {
                    form.setSubform("Country", otherSchema);
                } else {
                    form.removeSubform("Country");
                }
            });
            
            form.onChange("Submit", () -> {
                trace(form.getValues());
            });
        });

        new JQuery("body").append(form);
```

Importantly, subforms can be set under any field item, allowing conditional tree-like form structures. 
