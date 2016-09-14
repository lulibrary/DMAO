$(document).on("change", "select#institution_configuration_systems_configuration_cris_system_system_id", function(select) {

    $.ajax({
        url: "/admin/systems/cris_systems/" + $(this).val() + '/config_keys',
        dataType: "json",
        success: function(data) {
            $.each(data, function(index, value) {
                $("#cris-system-configuration").append(configKeyInput(value.id, value.name, value.display_name));
            });
        },
        error: function(data){

        }
    });

    function configKeyInput(id, name, displayName) {

        var input = "<p>";
        input += "<label for='institution_configuration_cris_system_" + name + "'>" + displayName + "</label>";
        input += "<br>";
        input += "<input type='text' name='institution_configuration[systems_configuration][cris_system][configuration_key_values][" + id + "]" + "'>";
        input += "</p>" ;

        return input;

    }

});