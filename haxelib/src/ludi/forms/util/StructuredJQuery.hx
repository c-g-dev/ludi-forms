package ludi.forms.util;

import js.jquery.JQuery;

@:forward
abstract StructuredJQuery<T>(JQuery) to JQuery from JQuery {
    public function setFields(fields: T) {
        this.data("structuredFields", fields);
    }

    public function getFields(): T {
        return this.data("structuredFields");
    }
}
