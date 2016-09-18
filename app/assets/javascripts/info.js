//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require grayscale.min

$(document).on("change", "select#institution_id", function(select) {

    if ($(this).val() !== "") {

        $("input#login-button").removeAttr("disabled");

    } else {

        $("input#login-button").attr("disabled", "disabled");

    }

});