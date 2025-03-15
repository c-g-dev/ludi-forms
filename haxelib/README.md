# ludi-forms

I got tired of rewriting form systems and hating them so this is my centralized library for the task.

```haxe
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
```

[Demo](https://c-g-dev.github.io/ludi-forms/bin/index.html)

Importantly, subforms can be set under any field item, allowing conditional tree-like form structures. 

The CSS is not auto applied. Style in your own .css, copy paste it from this repo, or programmatically pull the default CSS from FormStyling.getDefaultCSS().
